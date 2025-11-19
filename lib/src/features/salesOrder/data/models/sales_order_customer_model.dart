import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/address_model.dart';
import 'package:sales_app/src/features/customer/data/models/contact_info_model.dart';
import 'package:sales_app/src/features/customer/data/models/phone_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cpf.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_customer.dart';

@Entity()
class SalesOrderCustomerModel {
  @Id()
  int id;

  @Index()
  int customerId;
  String? customerCode;
  String customerUuId;
  String customerName;
  int? orderId;
  String? cnpj;
  String? cpf;

  final contactInfo = ToOne<ContactInfoModel>();
  final address = ToOne<AddressModel>();

  SalesOrderCustomerModel ({
    this.id = 0,
    required this.customerId,
    required this.customerCode,
    required this.customerUuId,
    required this.customerName,
    required this.cnpj,
    required this.cpf,
    this.orderId
  });
}

extension SalesOrderCustomerModeMapper on SalesOrderCustomerModel {
  /// De OrderCustomerModel → OrderCustomer
  SalesOrderCustomer toEntity() {
    return SalesOrderCustomer(
      customerId: customerId,
      customerCode: customerCode,
      customerUuId: customerUuId,
      customerName: customerName,
      contactInfo: contactInfo.target?.toEntity(),
      address: address.target!.toEntity(),
      cnpj: cnpj != null ? CNPJ(value: cnpj!) : null,
      cpf: cpf != null ? CPF(value: cpf!) : null,
      orderId: orderId
    );
  }

  void deleteRecursively(
    Box<SalesOrderCustomerModel> salesOrderCustomerBox,
    Box<ContactInfoModel> contactInfoBox,
    Box<PhoneModel> phoneBox,
    Box<AddressModel> addressBox
  ) {

    if (contactInfo.target != null) {
      contactInfo.target!.deleteRecursively(contactInfoBox: contactInfoBox, phoneBox: phoneBox);
    }

    if (address.target != null) {
      addressBox.remove(address.targetId);
    }

    salesOrderCustomerBox.remove(id);
  }
}

extension SalesOrderCustomerMapper on SalesOrderCustomer {
  /// De OrderCustomer → OrderCustomerModel
  SalesOrderCustomerModel toModel() {

    final model = SalesOrderCustomerModel(
      customerId: customerId,
      customerCode: customerCode,
      customerUuId: customerUuId,
      customerName: customerName,
      cnpj: cnpj?.value,
      cpf: cpf?.value,
      orderId: orderId
    );

    if (address != null) {
      model.address.target = address!.toModel();
    }

    if (contactInfo != null) {
      model.contactInfo.target = contactInfo!.toModel();
    }

    return model;
  }
}

