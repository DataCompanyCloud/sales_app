import 'package:objectbox/objectbox.dart';
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
import 'package:sales_app/src/features/customer/domain/valueObjects/customer_filter.dart';

class CustomerRepositoryImpl extends CustomerRepository{
  final Store store;

  CustomerRepositoryImpl(this.store);

  @override
  Future<List<Customer>> fetchAll(CustomerFilter filter) async {
    final box = store.box<CustomerModel>();

    // filters
    final name = filter.name;
    final document = filter.document;
    final email = filter.email;
    final phone = filter.phone;

    Condition<CustomerModel>? conditions;
    if (name != null && name.isNotEmpty) {
      final nameFormat = name.toLowerCase();
      conditions = CustomerModel_.fullName.contains(nameFormat, caseSensitive: false)
        .or(CustomerModel_.legalName.contains(nameFormat, caseSensitive: false))
        .or(CustomerModel_.tradeName.contains(nameFormat, caseSensitive: false));
    }

    final queryBuilder = box.query(conditions);

    // linkers
    if (document != null && document.isNotEmpty) {
      queryBuilder
        .link(CustomerModel_.cpf, CPFModel_.value.contains(document));
      queryBuilder
        .link(CustomerModel_.cnpj, CNPJModel_.value.contains(document));
    }

    if (email != null && email.isNotEmpty) {
      final emailFormat = email.toLowerCase();
      queryBuilder.link(
        CustomerModel_.email,
        EmailModel_.value.contains(emailFormat, caseSensitive: false),
      );
    }

    if (phone != null && phone.isNotEmpty) {
      queryBuilder.linkMany(
        CustomerModel_.phones,
        PhoneModel_.value.contains(phone),
      );
    }

    final query = queryBuilder.build();
    final models = await query.findAsync();
    query.close();

    // Converte para entidades
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Customer> fetchById(int customerId) async {
    final customerBox = store.box<CustomerModel>();

    final model = await customerBox.getAsync(customerId);

    if (model == null) {
      throw AppException(AppExceptionCode.CODE_001_CUSTOMER_LOCAL_NOT_FOUND, "Cliente não encontrado");
    }

    return model.toEntity();
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
        final oldModel = customerBox.get(customer.customerId);

        final newModel = customer.maybeMap(
          person: (p) => p.toModel(),
          company: (c) => c.toModel(),
          raw: (r) => r.toModel(),
          orElse: () => throw AppException(
            AppExceptionCode.CODE_003_CUSTOMER_DATA_INVALID,
            "Dados do Cliente inválidos para atualização",
          ),
        );

        if (oldModel != null) {
          // 🔹 Remove relacionamentos antigos
          if (oldModel.email.target != null) emailBox.remove(oldModel.email.targetId);
          if (oldModel.cpf.target != null) cpfBox.remove(oldModel.cpf.targetId);
          if (oldModel.cnpj.target != null) cnpjBox.remove(oldModel.cnpj.targetId);

          for (final phone in oldModel.phones) {
            phoneBox.remove(phone.id);
          }

          final oldAddress = oldModel.address.target;
          if (oldAddress != null) {
            if (oldAddress.cep.target != null) {
              cepBox.remove(oldAddress.cep.targetId);
            }
            addressBox.remove(oldAddress.id);
          }

          // 🔹 Mantém o mesmo ID do registro antigo
          newModel.id = oldModel.id;
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

    final insertId = store.runInTransaction(TxMode.write, () {
      final oldModel = customerBox.get(customer.customerId);

      // Cria novo modelo com os dados atualizados
      final newModel = customer.maybeMap(
        person: (p) => p.toModel(),
        company: (c) => c.toModel(),
        raw: (r) => r.toModel(),
        orElse: () => throw AppException(AppExceptionCode.CODE_003_CUSTOMER_DATA_INVALID,"Dados do Cliente inválidos para atualização"),
      );

      if (oldModel != null) {
        // Limpa relacionamentos antigos
        if (oldModel.email.target != null) emailBox.remove(oldModel.email.targetId);
        if (oldModel.cpf.target != null) cpfBox.remove(oldModel.cpf.targetId);
        if (oldModel.cnpj.target != null) cnpjBox.remove(oldModel.cnpj.targetId);

        for (final phone in oldModel.phones) {
          phoneBox.remove(phone.id);
        }

        final oldAddress = oldModel.address.target;
        if (oldAddress != null) {
          if (oldAddress.cep.target != null) {
            cepBox.remove(oldAddress.cep.targetId);
          }
          addressBox.remove(oldAddress.id);
        }

        newModel.id = oldModel.id;
      }

      return customerBox.put(newModel);
    });

    final model = await customerBox.getAsync(insertId);

    if (model == null) {
      throw AppException(AppExceptionCode.CODE_001_CUSTOMER_LOCAL_NOT_FOUND,"Cliente não encontrado após sua inserção");
    }

    return model.toEntity();
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