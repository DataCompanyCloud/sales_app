import 'dart:convert';
import 'package:sales_app/src/features/auth/domain/entities/user.dart';
import 'package:sales_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl extends AuthRepository{
  static const _userKey = 'auth_user';
  static const _syncBaseKey = 'sync_key';

  @override
  Future<void> delete(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  @override
  Future<User> fetch() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);

    if (jsonString == null) {
      // Nenhum usuário salvo
      throw Exception('Nenhum usuário encontrado');
    }

    final Map<String, dynamic> data = jsonDecode(jsonString);
    final user = User.fromJson(data);
    final isSync = prefs.getBool('${_syncBaseKey}_${user.id}');

    // print(isSync);
    return user.copyWith(isSync: isSync ?? false);
  }

  @override
  Future<User> save(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString(_userKey, jsonString);

    final isSync = prefs.getBool('${_syncBaseKey}_${user.id}');
    // print ('${_syncBaseKey}_${user.userId}');
    if (isSync == null) {
      await prefs.setBool('${_syncBaseKey}_${user.id}', false);
    }

    return user.copyWith(
      isSync: isSync ?? user.isSync
    );
  }

  @override
  Future<void> sync(User user) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${_syncBaseKey}_${user.id}', user.isSync);
  }
}