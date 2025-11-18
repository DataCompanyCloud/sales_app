import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/contact_info_model.dart';
import 'package:sales_app/src/features/customer/data/models/phone_model.dart';
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

  final contactInfo = ToMany<ContactInfoModel>();

  SalesOrderCustomerModel ({
    this.id = 0,
    required this.customerId,
    required this.customerCode,
    required this.customerUuId,
    required this.customerName,
    this.orderId
  });
}

extension SalesOrderCustomerModeMapper on SalesOrderCustomerModel {
  /// De OrderCustomerModel → OrderCustomer
  SalesOrderCustomer toEntity() {
    final contactInfoList = contactInfo.map((c) => c.toEntity()).toList();

    return SalesOrderCustomer(
      customerId: customerId,
      customerCode: customerCode,
      customerUuId: customerUuId,
      customerName: customerName,
      contactInfo: contactInfoList,
      orderId: orderId
    );
  }

  void deleteRecursively(
    Box<SalesOrderCustomerModel> salesOrderCustomerBox,
    Box<ContactInfoModel> contactInfoBox,
    Box<PhoneModel> phoneBox
  ) {
    for (var contact in contactInfo) {
      contact.deleteRecursively(contactInfoBox: contactInfoBox, phoneBox: phoneBox);
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
      customerName: customerName
    );

    model.orderId = orderId;

    if (contactInfo.isNotEmpty) {
      model.contactInfo.addAll(contactInfo.map((p) => p.toModel()));
    }

    return model;
  }
}

