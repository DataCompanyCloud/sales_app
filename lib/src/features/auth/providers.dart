import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/api_client_provider.dart';
import 'package:sales_app/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sales_app/src/features/auth/data/services/auth_service.dart';
import 'package:sales_app/src/features/auth/domain/entities/user.dart';
import 'package:sales_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:sales_app/src/features/auth/presentation/controllers/auth_controller.dart';

final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authServicesProvider = FutureProvider<AuthService>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient);
});

final authControllerProvider =
AsyncNotifierProvider<AuthController, User?>(AuthController.new);
