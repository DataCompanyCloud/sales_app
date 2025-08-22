import 'dart:ui';

import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/address_model.dart';
import 'package:sales_app/src/features/customer/data/models/cnpj_model.dart';
import 'package:sales_app/src/features/customer/data/models/contact_info_model.dart';
import 'package:sales_app/src/features/customer/data/models/cpf_model.dart';
import 'package:sales_app/src/features/customer/data/models/credit_limit_model.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/data/models/state_registration_model.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/tax_regime.dart';

@Entity()
class CustomerModel {
  /// customerId
  @Id()
  int id;                 // local
  String customerUuId;    // obrigatório, gerado no app
  int? serverId;          // nulo até sincronizar

  String? customerCode;
  String? fullName;
  String? legalName;
  String? tradeName;
  bool isActive;
  String? notes;
  int? taxRegime;
  List<int> paymentMethod;
  int? businessGroupId;
  String? businessSector;

  final address = ToOne<AddressModel>();
  final creditLimit = ToOne<CreditLimitModel>();
  final cpf = ToOne<CPFModel>();
  final cnpj = ToOne<CNPJModel>();
  final stateRegistration = ToOne<StateRegistrationModel>();
  final contacts = ToMany<ContactInfoModel>();

  CustomerModel({
    required this.id,
    required this.customerUuId,
    this.serverId,
    this.isActive = true,
    this.customerCode,
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
    final modelAddress = address.target;
    final contactInfoList = contacts.map((c) => c.toEntity()).toList();
    final payments = paymentMethod.map((p) => PaymentMethod.values[p]).toList();

    if (cpf.target != null && cnpj.target == null) {
      return Customer.person(
        customerId: id,
        customerUuId: customerUuId,
        serverId: serverId,
        customerCode: customerCode,
        fullName: fullName,
        paymentMethods: payments,
        taxRegime: taxRegime != null ? TaxRegime.values[taxRegime!] : null,
        creditLimit: creditLimit.target?.toEntity(),
        cpf: cpf.target?.toEntity(),
        contacts: contactInfoList,
        address: modelAddress?.toEntity(),
        isActive: isActive,
        notes: notes
      );
    }

    if (cnpj.target != null && cpf.target == null) {
      return Customer.company(
        customerId: id,
        customerUuId: customerUuId,
        serverId: serverId,
        customerCode: customerCode,
        legalName: legalName,
        tradeName: tradeName,
        stateRegistration: stateRegistration.target!.toEntity(), //TODO precisa rever isso aqui
        paymentMethods: payments,
        businessSector: businessSector,
        businessGroupId: businessGroupId,
        taxRegime: taxRegime != null ? TaxRegime.values[taxRegime!] : null,
        creditLimit: creditLimit.target?.toEntity(),
        cnpj: cnpj.target?.toEntity(),
        contacts: contactInfoList,
        address: modelAddress?.toEntity(),
        isActive: isActive,
        notes: notes
      );
    }

    // fallback: raw
    return Customer.raw(
      customerId: id,
      customerUuId: customerUuId,
      serverId: serverId,
      customerCode: customerCode,
      fullName: fullName,
      legalName: legalName,
      tradeName: tradeName,
      stateRegistration: stateRegistration.target!.toEntity(), //TODO precisa rever isso aqui
      paymentMethods: payments,
      businessSector: businessSector,
      businessGroupId: businessGroupId,
      taxRegime: taxRegime != null ? TaxRegime.values[taxRegime!] : null,
      creditLimit: creditLimit.target?.toEntity(),
      cpf: cpf.target?.toEntity(),
      cnpj: cnpj.target?.toEntity(),
      contacts: contactInfoList,
      address: modelAddress?.toEntity(),
      isActive: isActive,
      notes: notes
    );
  }
}

extension CustomerPersonMapper on PersonCustomer {
  CustomerModel toModel() {
    final model = CustomerModel(
      id: customerId,
      customerUuId: customerUuId,
      serverId: serverId,
      isActive: isActive,
      customerCode: customerCode,
      fullName: fullName,
      paymentMethod: paymentMethods.map((p) => p.index).toList(),
      taxRegime: taxRegime?.index,
      notes: notes
    );

    if (cpf != null) {
      model.cpf.target = cpf!.toModel();
    }
    if (address != null) {
      model.address.target = address!.toModel();
    }
    if (contacts.isNotEmpty) {
      model.contacts.addAll(contacts.map((p) => p.toModel()));
    }
    if (creditLimit != null) {
      model.creditLimit.target = creditLimit!.toModel();
    }

    return model;
  }
}

extension CustomerCompanyMapper on CompanyCustomer {
  CustomerModel toModel() {
    final model = CustomerModel(
      id: customerId,
      customerUuId: customerUuId,
      serverId: serverId,
      isActive: isActive,
      customerCode: customerCode,
      legalName: legalName,
      tradeName: tradeName,
      taxRegime: taxRegime?.index,
      paymentMethod: paymentMethods.map((p) => p.index).toList(),
      businessSector: businessSector,
      businessGroupId: businessGroupId,
      notes: notes
    );

    if (cnpj != null) {
      model.cnpj.target = cnpj!.toModel();
    }
    if (address != null) {
      model.address.target = address!.toModel();
    }
    if (contacts.isNotEmpty) {
      model.contacts.addAll(contacts.map((p) => p.toModel()));
    }
    if (creditLimit != null) {
      model.creditLimit.target = creditLimit!.toModel();
    }

    model.stateRegistration.target = stateRegistration.toModel();

    return model;
  }
}

extension CustomerMapper on RawCustomer {
  CustomerModel toModel() {
    final model = CustomerModel(
      id: customerId,
      customerUuId: customerUuId,
      serverId: serverId,
      isActive: isActive,
      customerCode: customerCode,
      paymentMethod: paymentMethods.map((p) => p.index).toList(),
      businessSector: businessSector,
      businessGroupId: businessGroupId,
      fullName: fullName,
      legalName: legalName,
      tradeName: tradeName,
      taxRegime: taxRegime?.index,
      notes: notes
    );

    if (cpf != null) {
      model.cpf.target = cpf!.toModel();
    }
    if (cnpj != null) {
      model.cnpj.target = cnpj!.toModel();
    }
    if (address != null) {
      model.address.target = address!.toModel();
    }
    if (contacts.isNotEmpty) {
      model.contacts.addAll(contacts.map((p) => p.toModel()));
    }
    if (creditLimit != null) {
      model.creditLimit.target = creditLimit!.toModel();
    }

    model.stateRegistration.target = stateRegistration.toModel();

    return model;
  }
}