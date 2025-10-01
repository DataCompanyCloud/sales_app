import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/cnpj_model.dart';
import 'package:sales_app/src/features/customer/data/models/cpf_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/email.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone.dart';
import 'package:sales_app/src/features/order/domain/entities/order_customer.dart';

@Entity()
class OrderCustomerModel {
  @Id()
  int id;

  @Index()
  int customerId;
  String customerCode;
  String customerUuId;
  String customerName;
  Email email;
  Phone phone;

  final cpf = ToOne<CPFModel>();
  final cnpj = ToOne<CNPJModel>();

  OrderCustomerModel ({
    this.id = 0,
    required this.customerId,
    required this.customerCode,
    required this.customerUuId,
    required this.customerName,
    required this.email,
    required this.phone
  });
}

// extension OrderCustomerModeMapper on OrderCustomerModel {
//   /// De OrderCustomerModel → OrderCustomer
//   OrderCustomer toEntity() {
//     return OrderCustomer(
//       customerId: customerId,
//       customerCode: customerCode,
//       customerUuId: customerUuId,
//       customerName: customerName,
//       email: email,
//       phone: phone,
//       cpf: cpf.target?.toEntity(),
//       cnpj: cnpj.target?.toEntity()
//     );
//   }
// }

// extension OrderCustomerMapper on OrderCustomer {
//   OrderCustomerModel toModel(){
//
//   }
// }