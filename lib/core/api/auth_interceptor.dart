
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibeat/core/constants/strings.dart';

class AuthInterceptor extends QueuedInterceptorsWrapper {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  AuthInterceptor({
    required this.dio,
    required this.secureStorage,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorage.read(key: AppStrings.jwtTokenKey);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    if (statusCode != 401 || statusCode == null) {
      return handler.resolve(err.response!);
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final accesToken = await secureStorage.read(key: AppStrings.jwtTokenKey);
    // if (accesToken == null) return handler.reject(err);

    final requestedAccessToken =
        err.requestOptions.headers['Authorization'].split(' ')[1];

    if (requestedAccessToken == accesToken) {
      final refreshToken =
          await secureStorage.read(key: AppStrings.refreshTokenKey);

      final ip = sharedPreferences.getString("ip");

      final tokenRefreshDio = Dio()..options.baseUrl = 'http://$ip:8080';

      final response = await tokenRefreshDio.get('/user/renewAccessToken',
          options: Options(headers: {
            "Authorization": 'Bearer $refreshToken',
          }));
      tokenRefreshDio.close();

      if (response.statusCode == null || response.statusCode! ~/ 100 != 2) {
        return handler.reject(err);
      }

      final body = response.data;
      // if (!body.containsKey('access_token')) {
      // return handler.reject(err);
      // }

      final jwtToken = body['data']['access_token'] as String;
      final newRefreshToken = body['data']['refresh_token'] as String;

      await secureStorage.write(
        key: AppStrings.jwtTokenKey,
        value: jwtToken,
      );
      await secureStorage.write(
        key: AppStrings.refreshTokenKey,
        value: newRefreshToken,
      );

      final retried = await dio.fetch(
        err.requestOptions
          ..headers = {
            'Authorization': 'Bearer $jwtToken',
          },
      );

      if (retried.statusCode == null || retried.statusCode! ~/ 100 != 2) {
        return handler.reject(err);
      }

      return handler.resolve(retried);
    }

    return handler.resolve(err.response!);
  }
}
