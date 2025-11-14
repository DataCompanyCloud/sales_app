import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cpf.dart';

part 'order_customer.freezed.dart';
part 'order_customer.g.dart';

@freezed
abstract class OrderCustomer with _$OrderCustomer {
  const OrderCustomer._();

  const factory OrderCustomer.raw({
    required int customerId,
    required String customerCode,
    required String customerUuId,
    required String customerName,
    @Default(<ContactInfo>[]) List<ContactInfo> contactInfo,
    CPF? cpf,
    CNPJ? cnpj,
    int? orderId
  }) = _OrderCustomer;

  factory OrderCustomer({
    required int customerId,
    required String customerCode,
    required String customerUuId,
    required String customerName,
    required List<ContactInfo> contactInfo ,
    CPF? cpf,
    CNPJ? cnpj,
    int? orderId
  }) {
    //TODO: Fazer as validações

    return OrderCustomer.raw(
      customerId: customerId,
      customerCode: customerCode,
      customerUuId: customerUuId,
      customerName: customerName,
      contactInfo: contactInfo,
      cpf: cpf,
      cnpj: cnpj,
      orderId: orderId
    );
  }

  factory OrderCustomer.fromJson(Map<String, dynamic> json) =>
      _$OrderCustomerFromJson(json);
}