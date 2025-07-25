import 'package:dio/dio.dart';
import 'package:sales_app/src/core/api/api_client.dart';

class DioApiClient extends ApiClient {
  final Dio _dio;

  DioApiClient(this._dio);

  @override
  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.get(
      path,
      queryParameters: queryParameters
    );

    return response.data;
  }

  @override
  Future<T> post<T>(String path, {dynamic data}) async {
    final response = await _dio.request(
      path,
      data: data,
      options: Options(method: 'POST'),
    );

    return response.data;
  }
}