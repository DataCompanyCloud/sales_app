import 'package:sales_app/objectbox.g.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/data/models/address_model.dart';
import 'package:sales_app/src/features/customer/data/models/cep_model.dart';
import 'package:sales_app/src/features/customer/data/models/cnpj_model.dart';
import 'package:sales_app/src/features/customer/data/models/contact_info_model.dart';
import 'package:sales_app/src/features/customer/data/models/cpf_model.dart';
import 'package:sales_app/src/features/customer/data/models/credit_limit_model.dart';
import 'package:sales_app/src/features/customer/data/models/customer_model.dart';
import 'package:sales_app/src/features/customer/data/models/email_model.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/data/models/phone_model.dart';
import 'package:sales_app/src/features/customer/data/models/state_registration_model.dart';
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
    final addressBox = store.box<AddressModel>();
    final cepBox = store.box<CEPModel>();
    final cpfBox = store.box<CPFModel>();
    final cnpjBox = store.box<CNPJModel>();
    final contactBox = store.box<ContactInfoModel>();
    final creditLimit = store.box<CreditLimitModel>();
    final moneyBox = store.box<MoneyModel>();
    final stateRegBox = store.box<StateRegistrationModel>();

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
          // Remove relacionamentos antigos
          if (existing.cpf.target != null) {
            cpfBox.remove(existing.cpf.targetId);
          }

          if (existing.cnpj.target != null) {
            cnpjBox.remove(existing.cnpj.targetId);
          }

          if (existing.stateRegistration.target != null) {
            stateRegBox.remove(existing.stateRegistration.targetId);
          }

          final oldCreditLimit = existing.creditLimit.target;
          if (oldCreditLimit != null) {
            if (oldCreditLimit.maximum.target != null) {
              moneyBox.remove(oldCreditLimit.maximum.targetId);
            }
            if (oldCreditLimit.available.target != null) {
              moneyBox.remove(oldCreditLimit.available.targetId);
            }

            creditLimit.remove(existing.creditLimit.targetId);
          }

          for (final contact in existing.contacts) {
            contactBox.remove(contact.id);
          }

          final oldAddress = existing.address.target;
          if (oldAddress != null) {
            if (oldAddress.cep.target != null) {
              cepBox.remove(oldAddress.cep.targetId);
            }
            addressBox.remove(oldAddress.id);
          }

          // Mantém o mesmo ID do registro antigo
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
    final addressBox = store.box<AddressModel>();
    final cepBox = store.box<CEPModel>();
    final cpfBox = store.box<CPFModel>();
    final cnpjBox = store.box<CNPJModel>();
    final contactBox = store.box<ContactInfoModel>();
    final creditLimit = store.box<CreditLimitModel>();
    final moneyBox = store.box<MoneyModel>();
    final stateRegBox = store.box<StateRegistrationModel>();
    final emailBox   = store.box<EmailModel>();
    final phoneBox   = store.box<PhoneModel>();

    final id = store.runInTransaction(TxMode.write, () {
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
        // Remove relacionamentos antigos
        if (existing.cpf.target != null) {
          cpfBox.remove(existing.cpf.targetId);
        }

        if (existing.cnpj.target != null) {
          cnpjBox.remove(existing.cnpj.targetId);
        }

        if (existing.stateRegistration.target != null) {
          stateRegBox.remove(existing.stateRegistration.targetId);
        }

        if (existing.creditLimit.target != null) {
          moneyBox.remove(existing.creditLimit.targetId);
        }

        final oldCreditLimit = existing.creditLimit.target;
        if (oldCreditLimit != null) {
          if (oldCreditLimit.maximum.target != null) {
            moneyBox.remove(oldCreditLimit.maximum.targetId);
          }
          if (oldCreditLimit.available.target != null) {
            moneyBox.remove(oldCreditLimit.available.targetId);
          }

          creditLimit.remove(existing.creditLimit.targetId);
        }

        for (final contact in existing.contacts) {
          final email = contact.email.target;
          if (email != null) emailBox.remove(email.id);

          final phone = contact.phone.target;
          if (phone != null) phoneBox.remove(phone.id);

          contactBox.remove(contact.id);
        }

        final oldAddress = existing.address.target;
        if (oldAddress != null) {
          if (oldAddress.cep.target != null) {
            cepBox.remove(oldAddress.cep.targetId);
          }
          addressBox.remove(oldAddress.id);
        }

        // Mantém o mesmo ID do registro antigo
        newModel.id = existing.id;
      } else {
        newModel.id = 0;
      }

      customerBox.put(newModel);
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
    final contactBox = store.box<ContactInfoModel>();
    final creditLimit = store.box<CreditLimitModel>();
    final moneyBox = store.box<MoneyModel>();

    store.runInTransaction(TxMode.write, () async {
      final model = await customerBox.getAsync(customer.customerId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_001_CUSTOMER_LOCAL_NOT_FOUND, "Cliente não encontrado");
      }

      final cpf = model.cpf.target;
      if (cpf != null) await cpfBox.removeAsync(cpf.id);

      final cnpj = model.cnpj.target;
      if (cnpj != null) await cnpjBox.removeAsync(cnpj.id);

      final oldCreditLimit = model.creditLimit.target;
      if (oldCreditLimit != null) {
        if (oldCreditLimit.maximum.target != null) {
          moneyBox.remove(oldCreditLimit.maximum.targetId);
        }
        if (oldCreditLimit.available.target != null) {
          moneyBox.remove(oldCreditLimit.available.targetId);
        }

        creditLimit.remove(model.creditLimit.targetId);
      }

      for (final contact in model.contacts) {
        final email = contact.email.target;
        if (email != null) emailBox.remove(email.id);

        final phone = contact.phone.target;
        if (phone != null) phoneBox.remove(phone.id);

        contactBox.remove(contact.id);
      }

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
    final cpfBox = store.box<CPFModel>();
    final cnpjBox = store.box<CNPJModel>();
    final emailBox = store.box<EmailModel>();
    final phoneBox = store.box<PhoneModel>();
    final contactBox = store.box<ContactInfoModel>();
    final creditLimit = store.box<CreditLimitModel>();
    final moneyBox = store.box<MoneyModel>();
    final stateRegBox = store.box<StateRegistrationModel>();

    store.runInTransaction(TxMode.write, () {
      final allCustomers = customerBox.getAll();

      for (final model in allCustomers) {
        // ToOne: CPF
        final cpf = model.cpf.target;
        if (cpf != null) cpfBox.remove(cpf.id);

        // ToOne: CNPJ
        final cnpj = model.cnpj.target;
        if (cnpj != null) cnpjBox.remove(cnpj.id);

        // ToOne: State Registration
        final stateReg = model.stateRegistration.target;
        if (stateReg != null) stateRegBox.remove(stateReg.id);

        // ToOne: Credit Limit (MoneyModel)
        final credit = model.creditLimit.target;
        if (credit != null) moneyBox.remove(credit.id);

        final oldCreditLimit = model.creditLimit.target;
        if (oldCreditLimit != null) {
          if (oldCreditLimit.maximum.target != null) {
            moneyBox.remove(oldCreditLimit.maximum.targetId);
          }
          if (oldCreditLimit.available.target != null) {
            moneyBox.remove(oldCreditLimit.available.targetId);
          }

          creditLimit.remove(model.creditLimit.targetId);
        }

        // ToMany: Contacts
        for (final contact in model.contacts) {
          final email = contact.email.target;
          if (email != null) emailBox.remove(email.id);

          final phone = contact.phone.target;
          if (phone != null) phoneBox.remove(phone.id);

          contactBox.remove(contact.id);
        }

        // ToOne: Address (com CEP)
        final address = model.address.target;
        if (address != null) {
          final cep = address.cep.target;
          if (cep != null) cepBox.remove(cep.id);
          addressBox.remove(address.id);
        }
      }

      // Por fim, remove todos os Customers
      customerBox.removeAll();
    });
  }


  @override
  Future<int> count() {
    final customerBox = store.box<CustomerModel>();
    return Future.value(customerBox.count());
  }

}