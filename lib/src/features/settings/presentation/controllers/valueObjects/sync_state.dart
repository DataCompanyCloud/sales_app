import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/settings/presentation/controllers/valueObjects/sync_status.dart';

part 'sync_state.freezed.dart';
part 'sync_state.g.dart';

@freezed
abstract class SyncState with _$SyncState {
  const SyncState._();

  const factory SyncState({
    @Default(SyncStatus.inactive) SyncStatus status,
    @Default(0) int itemsSyncAmount,
    @Default(0) int total,
    @Default(null) String? error
  }) = _SyncState;

  factory SyncState.fromJson(Map<String, dynamic> json) => _$SyncStateFromJson(json);

  // 0.0 - 1.0
  double get progress {
    if (total == 0 || itemsSyncAmount == 0) return 0;
    return itemsSyncAmount / total;
  }
}

