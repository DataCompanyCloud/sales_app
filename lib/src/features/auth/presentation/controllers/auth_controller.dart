import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/auth/domain/entites/user.dart';
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

  Future<void> login(String login, String password) async {
    state = const AsyncLoading();

    try {
      final service = await ref.read(authServicesProvider.future);
      final user = await service.login(login, password);

      final repo = ref.read(authRepositoryProvider);
      // await repo.save(user);
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
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

