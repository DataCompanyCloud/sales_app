import 'dart:convert';
import 'package:sales_app/src/features/auth/domain/entites/user.dart';
import 'package:sales_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl extends AuthRepository{
  static const _userKey = 'auth_user';

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
    return User.fromJson(data);
  }

  @override
  Future<void> save(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString(_userKey, jsonString);
  }
}