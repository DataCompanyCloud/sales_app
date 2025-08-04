import 'package:sales_app/src/features/auth/domain/entites/user.dart';

abstract class AuthRepository {
  /// Buscar um usuário
  Future<User> fetch();
  /// Salvar um usuário
  Future<void> save(User user);
  /// Deletar um usuário
  Future<void> delete(User user);
}