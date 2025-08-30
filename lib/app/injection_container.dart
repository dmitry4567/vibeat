import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibeat/core/api/auth_interceptor.dart';
import 'package:vibeat/core/api_client.dart';
import 'package:vibeat/core/network/network_info.dart';
import 'package:vibeat/features/anketa/data/datasource/anketa_remote_data_sourse.dart';
import 'package:vibeat/features/anketa/data/repositories/anketa_repository_impl.dart';
import 'package:vibeat/features/anketa/domain/repositories/anketa_repositories.dart';
import 'package:vibeat/features/anketa/domain/usecases/get_anketa.dart';
import 'package:vibeat/features/anketa/domain/usecases/send_anketa_response.dart';
import 'package:vibeat/features/anketa/presentation/bloc/anketa_bloc.dart';
import 'package:vibeat/features/signIn/domain/repositories/auth_repository.dart';
import 'package:vibeat/features/signIn/presentation/bloc/auth_bloc.dart';
import 'package:vibeat/info_beatmaker/widgets/bloc/all_beats_of_beatmaker_bloc.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import '../features/signIn/data/repositories/auth_repository_impl.dart';
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

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // API Client
  sl.registerLazySingleton(() => ApiClient(
        dio: sl(),
        logger: sl(),
      ));

  // Interceptors
  sl.registerLazySingleton(
    () => AuthInterceptor(
      dio: sl<Dio>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final ip = sharedPreferences.getString("ip");
  if (ip == null) {
    sharedPreferences.setString("ip", "192.168.0.135");
  }

  // Initialize API Client
  final apiClient = sl<ApiClient>();
  await apiClient.initialize('http://$ip:8080/');
  // await apiClient.initialize('http://172.20.10.4:3000');

  // Add auth interceptor
  sl<Dio>().interceptors.add(sl<AuthInterceptor>());

  // BLoCs
  sl.registerLazySingleton(() => PlayerBloc());
  sl.registerLazySingleton(() => AllBeatsOfBeatmakerBloc(playerBloc: sl()));

  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => AnketaBloc(
        getAnketa: sl(),
        sendAnketaResponse: sl(),
      ));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      googleSignIn: sl(),
      secureStorage: sl(),
      apiClient: sl(),
    ),
  );

  sl.registerLazySingleton<AnketaRepository>(
    () => AnketaRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAnketa(sl()));
  sl.registerLazySingleton(() => SendAnketaResponse(sl()));

  // Data sources
  sl.registerLazySingleton<AnketaRemoteDataSource>(
    () => AnketaRemoteDataSourceImpl(apiClient: sl()),
  );
}
