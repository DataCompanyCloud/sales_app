import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/schedule/domain/entities/customer_visit.dart';

part 'itinerary.freezed.dart';
part 'itinerary.g.dart';

@freezed
abstract class Itinerary with _$Itinerary {
  const Itinerary._();

  const factory Itinerary.period({
    required int itineraryId,
    required DateTime day,
    required List<CustomerVisit> visits
  }) = PeriodItinerary;

  const factory Itinerary.region({
    required int itineraryId,
    required String itineraryName,
    required List<CustomerVisit> visits,
    required bool canBePaused,
    required bool isPaused,
    DateTime? startDate,
    DateTime? endDate,
  }) = RegionItinerary;

  const factory Itinerary.raw({
    required int itineraryId,
    required DateTime? day,
    required String? itineraryName,
    required List<CustomerVisit> visits,
    required bool?canBePaused,
    required bool? isPaused,
    DateTime? startDate,
    DateTime? endDate,
  }) = RawItinerary;

  factory Itinerary({
    required int itineraryId,
    required DateTime? day,
    required String? itineraryName,
    required List<CustomerVisit> visits,
    required bool?canBePaused,
    required bool? isPaused,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    // validações

    return Itinerary.raw(
      itineraryId: itineraryId,
      day: day,
      itineraryName: itineraryName,
      visits: visits,
      canBePaused: canBePaused,
      isPaused: isPaused,
      startDate: startDate,
      endDate: endDate,
    );
  }

  factory Itinerary.fromJson(Map<String, dynamic> json) =>
      _$ItineraryFromJson(json);

}