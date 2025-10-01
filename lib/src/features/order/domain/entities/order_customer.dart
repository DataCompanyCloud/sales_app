// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';
// import 'package:sales_app/src/features/customer/domain/valueObjects/email.dart';
// import 'package:sales_app/src/features/customer/domain/valueObjects/phone.dart';
//
// @freezed
// abstract class OrderCustomer with _$OrderCustomer {
//   const OrderCustomer._();
//
//   const factory OrderCustomer.raw({
//     required int customerId,
//     required String customerCode,
//     required String customerUuId,
//     required String customerName,
//     required Email email,
//     required Phone phone
//   }) = _OrderCustomer;
//   final int customerId;
//   final String customerCode;
//   final String customerUuId;
//   final String customerName;
//   final Email email;
//   final Phone phone;
//
//   final CNPJ cnpj;
//   final CPF cpf;
// }