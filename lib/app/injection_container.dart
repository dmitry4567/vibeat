import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vibeat/features/auth/domain/repositories/auth_repository.dart';
import 'package:vibeat/features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      googleSignIn: sl(),
      secureStorage: sl(),
      serverAuthEndpoint: 'http://192.168.0.135:3000/auth/google',
    ),
  );

  // External
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
}
