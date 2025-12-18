import 'package:sales_app/objectbox.g.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/data/models/address_model.dart';
import 'package:sales_app/src/features/customer/data/models/contact_info_model.dart';
import 'package:sales_app/src/features/customer/data/models/credit_limit_model.dart';
import 'package:sales_app/src/features/customer/data/models/customer_model.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/data/models/phone_model.dart';
import 'package:sales_app/src/features/customer/data/models/state_registration_model.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl extends CustomerRepository{
  final Store store;

  CustomerRepositoryImpl(this.store);

  @override
  Future<List<Customer>> fetchAll(CustomerFilter filter)  async {
    final box = store.box<CustomerModel>();
    Condition<CustomerModel>? cond;

    // Texto
    // final raw = filter.q?.trim();
    // if (raw != null && raw.isNotEmpty) {
    //   cond = CustomerModel_..contains(raw, caseSensitive: false) | SalesOrderModel_.orderCode.contains(raw, caseSensitive: false);
    // }
    //
    // if (filter.status != null) {
    //   final statusCond = SalesOrderModel_.status.equals(filter.status!.index);
    //   cond = (cond == null) ? statusCond : (cond & statusCond);
    // }


    final qb = (cond == null) ? box.query() : box.query(cond);
    final q = qb.build();

    try {
      final models = await q.findAsync();
      return models.map((m) => m.toEntity()).toList();
    } finally {
      q.close();
    }
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
    final contactBox = store.box<ContactInfoModel>();
    final creditLimitBox = store.box<CreditLimitModel>();
    final moneyBox = store.box<MoneyModel>();
    final phoneBox = store.box<PhoneModel>();
    final stateRegBox = store.box<StateRegistrationModel>();

    store.runInTransaction(TxMode.write, () {
      for (final customer in customers) {
        final CustomerModel? existing = customer.customerId > 0
          ? customerBox.get(customer.customerId)
          : null
        ;

        final newModel = customer.maybeMap(
          person: (p) => p.toModel(),
          company: (c) => c.toModel(),
          orElse: () => throw AppException(
            AppExceptionCode.CODE_003_CUSTOMER_DATA_INVALID,
            "Dados do Cliente inválidos para atualização",
          ),
        );

        newModel.id = existing?.id ?? 0;
        if (existing != null) {
          existing.deleteRecursively(
            customerBox: customerBox,
            addressBox: addressBox,
            contactBox: contactBox,
            creditLimitBox: creditLimitBox,
            moneyBox: moneyBox,
            phoneBox: phoneBox,
            stateRegBox: stateRegBox
          );
        }

        return customerBox.put(newModel);
      }
    });
  }

  @override
  Future<Customer> save(Customer customer) async {
    final customerBox = store.box<CustomerModel>();
    final addressBox = store.box<AddressModel>();
    final contactBox = store.box<ContactInfoModel>();
    final creditLimitBox = store.box<CreditLimitModel>();
    final moneyBox = store.box<MoneyModel>();
    final phoneBox = store.box<PhoneModel>();
    final stateRegBox = store.box<StateRegistrationModel>();

    final id = store.runInTransaction(TxMode.write, () {
      final CustomerModel? existing = customer.customerId > 0
        ? customerBox.get(customer.customerId)
        : null;

      final newModel = customer.maybeMap(
        person: (p) => p.toModel(),
        company: (c) => c.toModel(),
        orElse: () => throw AppException(
          AppExceptionCode.CODE_003_CUSTOMER_DATA_INVALID,
          "Dados do Cliente inválidos para atualização",
        ),
      );

      newModel.id = existing?.id ?? 0;
      if (existing != null) {
        existing.deleteRecursively(
          customerBox: customerBox,
          addressBox: addressBox,
          contactBox: contactBox,
          creditLimitBox: creditLimitBox,
          moneyBox: moneyBox,
          phoneBox: phoneBox,
          stateRegBox: stateRegBox
        );
      }

      return customerBox.put(newModel);
    });

    final saved = await customerBox.getAsync(id);
    if (saved == null) {
      throw AppException(AppExceptionCode.CODE_001_CUSTOMER_LOCAL_NOT_FOUND, "Cliente não encontrado após sua inserção");
    }

    return saved.toEntity();
  }

  @override
  Future<void> delete(Customer customer) async {
    final customerBox = store.box<CustomerModel>();
    final addressBox = store.box<AddressModel>();
    final contactBox = store.box<ContactInfoModel>();
    final creditLimitBox = store.box<CreditLimitModel>();
    final moneyBox = store.box<MoneyModel>();
    final phoneBox = store.box<PhoneModel>();
    final stateRegBox = store.box<StateRegistrationModel>();

    store.runInTransaction(TxMode.write, () {
      final model = customerBox.get(customer.customerId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_001_CUSTOMER_LOCAL_NOT_FOUND, "Cliente não encontrado");
      }

      model.deleteRecursively(
        customerBox: customerBox,
        addressBox: addressBox,
        contactBox: contactBox,
        creditLimitBox: creditLimitBox,
        moneyBox: moneyBox,
        phoneBox: phoneBox,
        stateRegBox: stateRegBox
      );
    });
  }

  @override
  Future<void> deleteAll() async {
    final customerBox = store.box<CustomerModel>();
    final addressBox = store.box<AddressModel>();
    final contactBox = store.box<ContactInfoModel>();
    final creditLimitBox = store.box<CreditLimitModel>();
    final moneyBox = store.box<MoneyModel>();
    final phoneBox = store.box<PhoneModel>();
    final stateRegBox = store.box<StateRegistrationModel>();

    store.runInTransaction(TxMode.write, () {
      final allCustomers = customerBox.getAll();

      for (final model in allCustomers) {
        model.deleteRecursively(
          customerBox: customerBox,
          addressBox: addressBox,
          contactBox: contactBox,
          creditLimitBox: creditLimitBox,
          moneyBox: moneyBox,
          phoneBox: phoneBox,
          stateRegBox: stateRegBox
        );
      }
    });
  }

  @override
  Future<int> count() {
    final customerBox = store.box<CustomerModel>();
    return Future.value(customerBox.count());
  }
}