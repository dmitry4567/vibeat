import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:vibeat/core/api/auth_interceptor.dart';
import 'package:vibeat/core/api_client.dart';
import 'package:vibeat/features/domain/repositories/auth_repository.dart';
import 'package:vibeat/features/presentation/bloc/auth_bloc.dart';
import '../features/data/repositories/auth_repository_impl.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Logger());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(
    () => GoogleSignIn(
      clientId:
          '81758102489-02at57f056e9gr911upacte4llidj607.apps.googleusercontent.com',
      serverClientId:
          '81758102489-595rl6k8eiq65p06tipflgjk96llo7go.apps.googleusercontent.com',
      scopes: [
        'email',
        'profile',
        'openid',
      ],
      // hostedDomain: '',
    ),
  );

  // API Client
  sl.registerLazySingleton(() => ApiClient(
        dio: sl(),
        logger: sl(),
      ));

  // Interceptors
  sl.registerLazySingleton(() => AuthInterceptor(
        secureStorage: sl(),
      ));

  // Initialize API Client
  final apiClient = sl<ApiClient>();
  await apiClient.initialize('http://192.168.0.135:3000');

  // Add auth interceptor
  sl<Dio>().interceptors.add(sl<AuthInterceptor>());

  // BLoCs
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      googleSignIn: sl(),
      secureStorage: sl(),
      apiClient: sl(),
    ),
  );
}
