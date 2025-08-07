abstract class SyncRepository {
  Future<bool> get();
  Future<void> update(bool value);
  Future<void> delete();
}