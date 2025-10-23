import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/auth/domain/entities/user.dart';
import 'package:sales_app/src/features/auth/domain/valueObjects/password.dart';
import 'package:sales_app/src/features/auth/providers.dart';

class AuthController extends AsyncNotifier<User?> {

  @override
  FutureOr<User?> build() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      return await repo.fetch(); // Tenta buscar o usuário salvo localmente ao iniciar
    } catch(e) {
      print(e);
    }
    return null;
  }

  Future<void> login(String login, String password, bool rememberMe) async {
    state = const AsyncLoading();

    try {
      final service = await ref.read(authServicesProvider.future);
      final user = await service.login(login, password);

      final userPassword = Password.fromPlain(password);

      final userLogged = user.copyWith(
        isValidated: true,
        userPassword: userPassword.encrypted
      );

      final repo = ref.read(authRepositoryProvider);
      await repo.save(userLogged);

      state = AsyncData(userLogged);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Autenticar pela senha do aplicativo
  Future<void> authenticateByPassword(String password) async {
    state = await AsyncValue.guard(() async {
      final user = state.value;
      if (user == null) return null;

      try {
        final userPassword = Password.fromPlain(password);

        if (userPassword.encrypted == user.userPassword) {

          final newUser = user.copyWith(
            isValidated: true
          );

          return newUser;
        }
      } catch (e, st) {
        print(e);
      }

      return user;
    });


  }

  Future<void> authenticateByDigital() async {
    state = await AsyncValue.guard(() async {
      final user = state.value;
      if (user == null) return null;

      try {
        final newUser = user.copyWith(
            isValidated: true
        );

        return newUser;
      } catch (e, st) {
        print(e);
      }

      return user;
    });


  }

  Future<void> logout() async {
    final currentUser = state.value;
    if (currentUser != null) {
      final repo = ref.read(authRepositoryProvider);
      await repo.delete(currentUser);
    }
    state = const AsyncData(null);
  }
}

