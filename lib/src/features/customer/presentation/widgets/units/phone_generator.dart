import 'package:sales_app/src/features/customer/domain/entities/phone.dart';
import 'package:sales_app/src/features/customer/presentation/controllers/customer_controller_old.dart';

List<Phone> generatePhoneList({int count = 3}) {
  return List.generate(count, (_) => Phone(value: gerarPhone()));
}
