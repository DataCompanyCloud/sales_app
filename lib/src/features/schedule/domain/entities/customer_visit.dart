import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_visit.freezed.dart';
part 'customer_visit.g.dart';

@freezed
abstract class CustomerVisit with _$CustomerVisit {
  const CustomerVisit._();

  const factory CustomerVisit.raw({
    required String customerUuId,
    DateTime? visitDate,
  }) = RawCustomerVisit;

  factory CustomerVisit({
    required String customerUuId,
    DateTime? visitDate,
  }) {
    return CustomerVisit.raw(
      customerUuId: customerUuId,
      visitDate: visitDate
    );
  }

  factory CustomerVisit.fromJson(Map<String, dynamic> json) =>
      _$CustomerVisitFromJson(json);

}

