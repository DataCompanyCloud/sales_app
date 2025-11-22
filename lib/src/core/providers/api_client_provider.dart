import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/dio_api_client.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.1.5:3000',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));
  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return DioApiClient(dio);
});

// final sharedPreferenceProvider = Provider<SharedPreferences>((ref) {
//   final prefs = ref.watch(sharedPreferenceProvider);
//   return SharedPreferencesService(prefs);
// });