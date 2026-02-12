import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/address_model.dart';
import 'package:sales_app/src/features/customer/data/models/contact_info_model.dart';
import 'package:sales_app/src/features/customer/data/models/credit_limit_model.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/data/models/phone_model.dart';
import 'package:sales_app/src/features/customer/data/models/state_registration_model.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cpf.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/state_registration.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/tax_regime.dart';

@Entity()
class CustomerModel {
  /// customerId
  @Id()
  int id;                 // local
  String uuid;    // obrigatório, gerado no app

  String? code;
  String? fullName;
  String? legalName;
  String? tradeName;
  bool isActive;
  String? notes;
  int? taxRegime;
  List<int> paymentMethod;
  int? businessGroupId;
  String? businessSector;

  String? cpf;
  String? cnpj;

  final addresses = ToMany<AddressModel>();
  final creditLimit = ToOne<CreditLimitModel>();
  final stateRegistration = ToOne<StateRegistrationModel>();
  final contacts = ToMany<ContactInfoModel>();

  CustomerModel({
    required this.id,
    required this.uuid,
    this.code,
    this.cpf,
    this.cnpj,
    this.isActive = true,
    this.fullName,
    this.legalName,
    this.tradeName,
    this.taxRegime,
    this.paymentMethod = const [],
    this.businessGroupId,
    this.businessSector,
    this.notes
  });
}

extension CustomerModelMapper on CustomerModel {
  Customer toEntity() {
    final addressList = addresses.map((a) => a.toEntity()).toList();
    final contactInfoList = contacts.map((c) => c.toEntity()).toList();
    final payments = paymentMethod.map((p) => PaymentMethod.values[p]).toList();

    StateRegistration? modelStateRegistration;
    if (stateRegistration.target != null) {
      modelStateRegistration = stateRegistration.target!.toEntity();
    }

    return Customer(
      id: id,
      uuid: uuid,
      externalId: '',
      code: code,
      fullName: fullName,
      legalName: legalName,
      tradeName: tradeName,
      stateRegistration: modelStateRegistration,
      paymentMethods: payments,
      businessSector: businessSector,
      taxRegime: taxRegime != null ? TaxRegime.values[taxRegime!] : null,
      creditLimit: creditLimit.target?.toEntity(),
      cpf: cpf != null ? CPF.raw(value: cpf!) : null,
      cnpj: cnpj != null ? CNPJ.raw(value: cnpj!) : null,
      contacts: contactInfoList,
      addresses: addressList,
      isActive: isActive,
      notes: notes,
    );
  }

  /// Remove este CustomerModel e todas as entidades relacionadas.
  void deleteRecursively({
    required Box<CustomerModel> customerBox,
    required Box<AddressModel> addressBox,
    required Box<ContactInfoModel> contactBox,
    required Box<CreditLimitModel> creditLimitBox,
    required Box<MoneyModel> moneyBox,
    required Box<PhoneModel> phoneBox,
    required Box<StateRegistrationModel> stateRegBox,
  }) {
    // State registration
    if (stateRegistration.target != null) {
      stateRegBox.remove(stateRegistration.targetId);
    }

    final credit  = creditLimit.target;
    if (credit != null) {
      credit.deleteRecursively(creditLimitBox: creditLimitBox, moneyBox: moneyBox);
    }

    for (final address in addresses) {
      addressBox.remove(address.id);
    }

    for (final contact in contacts) {
      contact.deleteRecursively(contactInfoBox: contactBox, phoneBox: phoneBox);
    }

    customerBox.remove(id);
  }
}




extension CustomerPersonMapper on PersonCustomer {
  CustomerModel toModel() {
    final model = CustomerModel(
      id: id,
      uuid: uuid,
      code: code,
      cpf: cpf?.value,
      isActive: isActive,
      fullName: fullName,
      paymentMethod: paymentMethods.map((p) => p.index).toList(),
      taxRegime: taxRegime?.index,
      notes: notes,
    );

    model.creditLimit.target = creditLimit?.toModel();

    if (contacts.isNotEmpty) {
      model.contacts.addAll(contacts.map((p) => p.toModel()));
    }

    if (addresses.isNotEmpty) {
      model.addresses.addAll(addresses.map((a) => a.toModel()));
    }

    return model;
  }
}

extension CustomerCompanyMapper on CompanyCustomer {
  CustomerModel toModel() {
    final model = CustomerModel(
      id: id,
      uuid: uuid,
      code: code,
      cnpj: cnpj?.value,
      isActive: isActive,
      legalName: legalName,
      tradeName: tradeName,
      taxRegime: taxRegime?.index,
      paymentMethod: paymentMethods.map((p) => p.index).toList(),
      businessSector: businessSector,
      notes: notes
    );

    model.creditLimit.target = creditLimit?.toModel();
    model.stateRegistration.target = stateRegistration.toModel();

    if (contacts.isNotEmpty) {
      model.contacts.addAll(contacts.map((p) => p.toModel()));
    }

    if (addresses.isNotEmpty) {
      model.addresses.addAll(addresses.map((a) => a.toModel()));
    }

    return model;
  }
}