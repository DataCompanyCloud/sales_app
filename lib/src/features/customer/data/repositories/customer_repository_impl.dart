import 'package:sales_app/objectbox.g.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/data/models/address_model.dart';
import 'package:sales_app/src/features/customer/data/models/cep_model.dart';
import 'package:sales_app/src/features/customer/data/models/cnpj_model.dart';
import 'package:sales_app/src/features/customer/data/models/cpf_model.dart';
import 'package:sales_app/src/features/customer/data/models/customer_model.dart';
import 'package:sales_app/src/features/customer/data/models/email_model.dart';
import 'package:sales_app/src/features/customer/data/models/phone_model.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl extends CustomerRepository{
  final Store store;

  CustomerRepositoryImpl(this.store);

  @override
  Future<List<Customer>> fetchAll({String? search}) async {
    final box = store.box<CustomerModel>();

    // Se não houver termo, retorna tudo (ou adapte para paginação/sort)
    final raw = (search ?? '').trim();
    if (raw.isEmpty) {
      final all = await box.getAllAsync();
      return all.map((m) => m.toEntity()).toList();
    }

    final term = raw.toLowerCase();
    final digits = raw.replaceAll(RegExp(r'\D+'), '');

    // 1) Busca por NOME (fullName | legalName | tradeName), case-insensitive
    final nameCond =
    CustomerModel_.fullName.contains(term, caseSensitive: false)
        .or(CustomerModel_.legalName.contains(term, caseSensitive: false))
        .or(CustomerModel_.tradeName.contains(term, caseSensitive: false));

    final nameQuery = box.query(nameCond).build();
    final byName = await nameQuery.findAsync();
    nameQuery.close();

    // 2) Busca por DOCUMENTO (CPF/CNPJ) quando houver dígitos no termo
    final List<CustomerModel> byDoc = [];
    if (digits.isNotEmpty) {
      // CPF
      final cpfQB = box.query();
      cpfQB.link(CustomerModel_.cpf, CPFModel_.value.contains(digits));
      final cpfQuery = cpfQB.build();
      final cpfMatches = await cpfQuery.findAsync();
      cpfQuery.close();

      // CNPJ
      final cnpjQB = box.query();
      cnpjQB.link(CustomerModel_.cnpj, CNPJModel_.value.contains(digits));
      final cnpjQuery = cnpjQB.build();
      final cnpjMatches = await cnpjQuery.findAsync();
      cnpjQuery.close();

      byDoc
        ..addAll(cpfMatches)
        ..addAll(cnpjMatches);
    }

    // 3) Mescla resultados removendo duplicados por id
    final seen = <int>{};
    final merged = <CustomerModel>[];
    for (final m in [...byName, ...byDoc]) {
      if (seen.add(m.id)) merged.add(m);
    }

    return merged.map((m) => m.toEntity()).toList();
  }


  @override
  Future<Customer> fetchById(int customerId) async {
    try {
      final customerBox = store.box<CustomerModel>();

      final model = await customerBox.getAsync(customerId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_001_CUSTOMER_LOCAL_NOT_FOUND, "Cliente não encontrado");
      }

      return model.toEntity();
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException.errorUnexpected(e.toString());
    }
  }


  @override
  Future<void> saveAll(List<Customer> customers) async {
    final customerBox = store.box<CustomerModel>();
    final phoneBox = store.box<PhoneModel>();
    final addressBox = store.box<AddressModel>();
    final cepBox = store.box<CEPModel>();
    final emailBox = store.box<EmailModel>();
    final cpfBox = store.box<CPFModel>();
    final cnpjBox = store.box<CNPJModel>();

    store.runInTransaction(TxMode.write, () {
      for (final customer in customers) {
        final existing = customerBox.get(customer.customerId);

        final newModel = customer.maybeMap(
          person: (p) => p.toModel(),
          company: (c) => c.toModel(),
          raw: (r) => r.toModel(),
          orElse: () => throw AppException(
            AppExceptionCode.CODE_003_CUSTOMER_DATA_INVALID,
            "Dados do Cliente inválidos para atualização",
          ),
        );

        if (existing != null) {
          // 🔹 Remove relacionamentos antigos
          if (existing.email.target != null) emailBox.remove(existing.email.targetId);
          if (existing.cpf.target != null) cpfBox.remove(existing.cpf.targetId);
          if (existing.cnpj.target != null) cnpjBox.remove(existing.cnpj.targetId);

          for (final phone in existing.phones) {
            phoneBox.remove(phone.id);
          }

          final oldAddress = existing.address.target;
          if (oldAddress != null) {
            if (oldAddress.cep.target != null) {
              cepBox.remove(oldAddress.cep.targetId);
            }
            addressBox.remove(oldAddress.id);
          }

          // 🔹 Mantém o mesmo ID do registro antigo
          newModel.id = existing.id;
        } else {
          newModel.id = 0;
        }

        customerBox.put(newModel);
      }
    });
  }

  @override
  Future<Customer> save(Customer customer) async {
    final customerBox = store.box<CustomerModel>();
    final phoneBox = store.box<PhoneModel>();
    final addressBox = store.box<AddressModel>();
    final cepBox = store.box<CEPModel>();
    final emailBox = store.box<EmailModel>();
    final cpfBox = store.box<CPFModel>();
    final cnpjBox = store.box<CNPJModel>();

    final id = store.runInTransaction(TxMode.write, () {
      final existing = customerBox.get(customer.customerId);

      // Cria o modelo novo a partir da entity
      final newModel = customer.maybeMap(
        person: (p) => p.toModel(),
        company: (c) => c.toModel(),
        raw: (r) => r.toModel(),
        orElse: () => throw AppException(
          AppExceptionCode.CODE_003_CUSTOMER_DATA_INVALID,
          "Dados do Cliente inválidos para atualização",
        ),
      );

      if (existing != null) {
        newModel.id = existing.id;

        // Limpa relacionamentos antigos com checagem de ID > 0
        final emailId = existing.email.targetId;
        if (emailId != 0) emailBox.remove(emailId);

        final cpfId = existing.cpf.targetId;
        if (cpfId != 0) cpfBox.remove(cpfId);

        final cnpjId = existing.cnpj.targetId;
        if (cnpjId != 0) cnpjBox.remove(cnpjId);

        for (final ph in existing.phones) {
          if (ph.id != 0) phoneBox.remove(ph.id);
        }

        final oldAddr = existing.address.target;
        if (oldAddr != null) {
          final cepId = oldAddr.cep.targetId;
          if (cepId != 0) cepBox.remove(cepId);
          if (oldAddr.id != 0) addressBox.remove(oldAddr.id);
        }

      } else {
        newModel.id = 0;
      }

      // Importante: put() cuidará de persistir ToOne/ToMany que você setou em newModel
      return customerBox.put(newModel);
    });

    final saved = await customerBox.getAsync(id);
    if (saved == null) {
      throw AppException(
        AppExceptionCode.CODE_001_CUSTOMER_LOCAL_NOT_FOUND,
        "Cliente não encontrado após sua inserção",
      );
    }
    return saved.toEntity();
  }


  @override
  Future<void> delete(Customer customer) async {
    final customerBox = store.box<CustomerModel>();
    final addressBox = store.box<AddressModel>();
    final cepBox = store.box<CEPModel>();
    final emailBox = store.box<EmailModel>();
    final phoneBox = store.box<PhoneModel>();
    final cpfBox = store.box<CPFModel>();
    final cnpjBox = store.box<CNPJModel>();

    store.runInTransaction(TxMode.write, () async {
      final model = await customerBox.getAsync(customer.customerId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_001_CUSTOMER_LOCAL_NOT_FOUND, "Cliente não encontrado");
      }

      final email = model.email.target;
      if (email != null) await emailBox.removeAsync(email.id);

      for (final phone in model.phones) {
        await phoneBox.removeAsync(phone.id);
      }

      final cpf = model.cpf.target;
      if (cpf != null) await cpfBox.removeAsync(cpf.id);

      final cnpj = model.cnpj.target;
      if (cnpj != null) await cnpjBox.removeAsync(cnpj.id);

      final address = model.address.target;
      if (address != null) {
        final cep = address.cep.target;
        if (cep != null) await cepBox.removeAsync(cep.id);
        await addressBox.removeAsync(address.id);
      }

      await customerBox.removeAsync(model.id);
    });
  }

  @override
  Future<void> deleteAll() async {
    final customerBox = store.box<CustomerModel>();
    final addressBox = store.box<AddressModel>();
    final cepBox = store.box<CEPModel>();
    final emailBox = store.box<EmailModel>();
    final phoneBox = store.box<PhoneModel>();
    final cpfBox = store.box<CPFModel>();
    final cnpjBox = store.box<CNPJModel>();

    store.runInTransaction(TxMode.write, () {
      final allCustomers = customerBox.getAll();
      for (final model in allCustomers) {
        final email = model.email.target;
        if (email != null) emailBox.remove(email.id);

        for (final phone in model.phones) {
          phoneBox.remove(phone.id);
        }

        final cpf = model.cpf.target;
        if (cpf != null) cpfBox.remove(cpf.id);

        final cnpj = model.cnpj.target;
        if (cnpj != null) cnpjBox.remove(cnpj.id);

        final address = model.address.target;
        if (address != null) {
          final cep = address.cep.target;
          if (cep != null) cepBox.remove(cep.id);
          addressBox.remove(address.id);
        }
      }
      customerBox.removeAll();
    });
  }

  @override
  Future<int> count() {
    final customerBox = store.box<CustomerModel>();
    return Future.value(customerBox.count());
  }

}