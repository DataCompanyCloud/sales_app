import 'package:sales_app/src/features/sync/domain/repositories/sync_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncRepositoryImpl extends SyncRepository {
  static const _syncKey = 'sync_user';

  @override
  Future<void> delete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_syncKey);
  }

  @override
  Future<bool> get() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_syncKey);

    if (value == null) {
      throw Exception('Sincronização não encontrada');
    }

    return value;
  }

  @override
  Future<void> update(bool value) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_syncKey, value);
  }
}