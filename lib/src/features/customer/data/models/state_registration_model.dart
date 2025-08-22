import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/state_registration.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/uf.dart';

@Entity()
class StateRegistrationModel {
  @Id()
  int id;

  final int uf;
  final String number;
  final bool isExempt;

  StateRegistrationModel({
    this.id = 0,
    required this.uf,
    required this.number,
    required this.isExempt
  });
}

extension StateRegistrationModelMapper on StateRegistrationModel {
  /// De StateRegistrationModel → StateRegistration
  StateRegistration toEntity() => StateRegistration(
    uf: UF.values[uf],
    number: number,
    isExempt: isExempt
  );
}

extension StateRegistrationMapper on StateRegistration {
  /// De StateRegistration → StateRegistrationModel
  StateRegistrationModel toModel() => StateRegistrationModel(
    uf: uf.index,
    number: number,
    isExempt: isExempt
  );
}