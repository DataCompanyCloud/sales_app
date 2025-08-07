import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/auth/domain/entities/user.dart';
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

  Future<void> updateAuth(User user) async {
    try {
      state = AsyncLoading();
      final repo = ref.read(authRepositoryProvider);
      await repo.save(user);
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }


  Future<void> login(String login, String password, bool rememberMe) async {
    state = const AsyncLoading();

    try {
      final service = await ref.read(authServicesProvider.future);
      final user = await service.login(login, password);

      final userLogged = user.copyWith(
        rememberMe: rememberMe
      );

      if (rememberMe) {
        final repo = ref.read(authRepositoryProvider);
        await repo.save(userLogged);
      }

      state = AsyncData(userLogged);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      AppException exception = AppException(AppExceptionCode.CODE_012_AUTH_NETWORK_ERROR, "Falha ao fazer login");

      if (status == 401) {
        exception = AppException(AppExceptionCode.CODE_007_AUTH_INVALID_CREDENTIALS, "Credênciais inválidas");
      }

      if (status == 404) {
        exception = AppException(AppExceptionCode.CODE_014_USER_NOT_FOUND, "Usuário não existe");
      }

      state = AsyncError(exception, StackTrace.current);
    } catch (e, st) {
      state = AsyncError(AppException.errorUnexpected(e.toString()), st);
    }
  }

  Future<void> logout() async {
    final currentUser = state.value;
    if (currentUser != null) {
      final repo = ref.read(authRepositoryProvider);
      await repo.delete(currentUser);
    }
    state = const AsyncData(null); // ou AsyncValue<User>.data(null) se User? for aceito
  }
}

