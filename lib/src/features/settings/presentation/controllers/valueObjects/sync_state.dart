enum SyncStatus {
  inactive,
  preparing,
  syncing,
}

class SyncState {
  final bool isSyncing;
  final int itemsSyncAmount;
  final int total;
  final DateTime? lastSync;
  final String? error;

  // 0.0 - 1.0
  double get progress {
    if (total == 0 || itemsSyncAmount == 0) return 0;
    return itemsSyncAmount / total;
  }


  SyncState({
    this.isSyncing = false,
    this.itemsSyncAmount = 0,
    this.total = 0,
    this.lastSync,
    this.error,
  });

  SyncState copyWith({
    bool? isSyncing,
    int? total,
    int? itemsSyncAmount,
    DateTime? lastSync,
    String? error,
  }) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      itemsSyncAmount: itemsSyncAmount ?? this.itemsSyncAmount,
      total: total ?? this.total,
      lastSync: lastSync ?? this.lastSync,
      error: error,
    );
  }

}
