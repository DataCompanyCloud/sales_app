import 'package:sales_app/src/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  /// Buscar um usuário
  Future<User> fetch();
  /// Salvar um usuário
  Future<User> save(User user);
  /// Deletar um usuário
  Future<void> delete(User user);
  /// Sync um usuário
  Future<void> sync(User user);
}