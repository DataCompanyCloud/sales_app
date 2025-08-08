import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/address_model.dart';
import 'package:sales_app/src/features/customer/data/models/cnpj_model.dart';
import 'package:sales_app/src/features/customer/data/models/cpf_model.dart';
import 'package:sales_app/src/features/customer/data/models/email_model.dart';
import 'package:sales_app/src/features/customer/data/models/phone_model.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';

@Entity()
class CustomerModel {
  /// customerId
  @Id()
  int id;                  // local
  String customerUuId;     // obrigatório, gerado no app
  int? serverId;        // nulo até sincronizar

  String? customerCode;
  String? fullName;
  String? legalName;
  String? tradeName;
  bool isActive;

  final address = ToOne<AddressModel>();
  final email = ToOne<EmailModel>();
  final phones = ToMany<PhoneModel>();

  final cpf = ToOne<CPFModel>();
  final cnpj = ToOne<CNPJModel>();

  CustomerModel({
    required this.id,
    required this.customerUuId,
    this.serverId,
    this.isActive = true,
    this.customerCode,
    this.fullName,
    this.legalName,
    this.tradeName
  });
}


extension CustomerModelMapper on CustomerModel {
  Customer toEntity() {
    final modelEmail = email.target;
    final modelAddress = address.target;
    final phoneList = phones.map((p) => p.toEntity()).toList();

    if (cpf.target != null && cnpj.target == null) {
      return Customer.person(
        customerId: id,
        customerUuId: customerUuId,
        serverId: serverId,
        customerCode: customerCode,
        fullName: fullName,
        cpf: cpf.target?.toEntity(),
        email: modelEmail?.toEntity(),
        phones: phoneList,
        address: modelAddress?.toEntity(),
        isActive: isActive
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
        cnpj: cnpj.target?.toEntity(),
        email: modelEmail?.toEntity(),
        phones: phoneList,
        address: modelAddress?.toEntity(),
        isActive: isActive
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
      cpf: cpf.target?.toEntity(),
      cnpj: cnpj.target?.toEntity(),
      email: modelEmail?.toEntity(),
      phones: phoneList,
      address: modelAddress?.toEntity(),
      isActive: isActive
    );
  }
}

extension CustomerPersonMapper on PersonCustomer {
  CustomerModel toModel() {
    final entity = CustomerModel(
      id: customerId,
      customerUuId: customerUuId,
      serverId: serverId,
      isActive: isActive,
      customerCode: customerCode,
      fullName: fullName
    );

    if (cpf != null) {
      entity.cpf.target = cpf!.toModel();
    }
    if (email != null) {
      entity.email.target = email!.toModel();
    }
    if (address != null) {
      entity.address.target = address!.toModel();
    }
    if (phones != null) {
      entity.phones.addAll(phones!.map((p) => p.toModel()));
    }

    return entity;
  }
}

extension CustomerCompanyMapper on CompanyCustomer {
  CustomerModel toModel() {
    final entity = CustomerModel(
      id: customerId,
      customerUuId: customerUuId,
      serverId: serverId,
      isActive: isActive,
      customerCode: customerCode,
      legalName: legalName,
      tradeName: tradeName
    );

    if (cnpj != null) {
      entity.cnpj.target = cnpj!.toModel();
    }
    if (email != null) {
      entity.email.target = email!.toModel();
    }
    if (address != null) {
      entity.address.target = address!.toModel();
    }
    if (phones != null) {
      entity.phones.addAll(phones!.map((p) => p.toModel()));
    }

    return entity;
  }
}

extension CustomerMapper on RawCustomer {
  CustomerModel toModel() {
    final entity = CustomerModel(
      id: customerId,
      customerUuId: customerUuId,
      serverId: serverId,
      isActive: isActive,
      customerCode: customerCode,
      fullName: fullName,
      legalName: legalName,
      tradeName: tradeName
    );

    if (cpf != null) {
      entity.cpf.target = cpf!.toModel();
    }
    if (cnpj != null) {
      entity.cnpj.target = cnpj!.toModel();
    }
    if (email != null) {
      entity.email.target = email!.toModel();
    }
    if (address != null) {
      entity.address.target = address!.toModel();
    }
    if (phones != null) {
      entity.phones.addAll(phones!.map((p) => p.toModel()));
    }

    return entity;
  }
}