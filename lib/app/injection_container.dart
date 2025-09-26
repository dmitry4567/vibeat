import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibeat/core/api/auth_interceptor.dart';
import 'package:vibeat/core/api_client.dart';
import 'package:vibeat/core/network/network_info.dart';
import 'package:vibeat/features/favorite/data/datasources/favorite_local_data_source.dart';
import 'package:vibeat/features/favorite/data/datasources/favorite_remote_data_source.dart';
import 'package:vibeat/features/favorite/data/repositories/favorite_repository_impl.dart';
import 'package:vibeat/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:vibeat/features/favorite/domain/usecases/add_to_favorite.dart';
import 'package:vibeat/features/favorite/domain/usecases/get_favorite_beats.dart';
import 'package:vibeat/features/favorite/domain/usecases/is_favorite.dart';
import 'package:vibeat/features/favorite/domain/usecases/remove_from_favorite.dart';
import 'package:vibeat/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vibeat/features/anketa/data/datasource/anketa_remote_data_sourse.dart';
import 'package:vibeat/features/anketa/data/repositories/anketa_repository_impl.dart';
import 'package:vibeat/features/anketa/domain/repositories/anketa_repositories.dart';
import 'package:vibeat/features/anketa/domain/usecases/get_anketa.dart';
import 'package:vibeat/features/anketa/domain/usecases/send_anketa_response.dart';
import 'package:vibeat/features/anketa/presentation/bloc/anketa_bloc.dart';
import 'package:vibeat/features/signIn/domain/repositories/auth_repository.dart';
import 'package:vibeat/features/signIn/presentation/bloc/auth_bloc.dart';
import 'package:vibeat/info_beatmaker/bloc/all_beats_of_beatmaker_bloc.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import '../features/signIn/data/repositories/auth_repository_impl.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();
  Hive.registerAdapter(StringSetAdapter());

  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Logger());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  sl.registerSingletonAsync<SharedPreferences>(() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  });

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

  final box = await Hive.openBox<Set<String>>("liked_tracks");
  sl.registerSingleton<Box<Set<String>>>(box);

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

  final ip = sl<SharedPreferences>().getString("ip");
  if (ip == null) {
    sl<SharedPreferences>().setString("ip", "172.20.10.2");
  }

  // Initialize API Client
  final apiClient = sl<ApiClient>();
  await apiClient.initialize('http://$ip:8080/');
  // await apiClient.initialize('http://172.20.10.4:3000');

  // Add auth interceptor
  sl<Dio>().interceptors.add(sl<AuthInterceptor>());

  // BLoCs
  sl.registerLazySingleton(() => PlayerBloc());
  sl.registerLazySingleton(() => AllBeatsOfBeatmakerBloc());
  sl.registerLazySingleton(() => FavoriteBloc(
        getFavoriteBeats: sl(),
        isFavorite: sl(),
        addToFavorite: sl(),
        removeFromFavorite: sl(),
      ));

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
      favoriteRepository: sl(),
    ),
  );

  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
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

  sl.registerLazySingleton(() => GetFavoriteBeats(sl()));
  sl.registerLazySingleton(() => IsFavorite(sl()));
  sl.registerLazySingleton(() => AddToFavorite(sl()));
  sl.registerLazySingleton(() => RemoveFromFavorite(sl()));

  // Data sources
  sl.registerLazySingleton<AnketaRemoteDataSource>(
    () => AnketaRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<FavoriteRemoteDataSource>(
    () => FavoriteRemoteDataSourceImpl(
      networkInfo: sl(),
      apiClient: sl(),
    ),
  );

  sl.registerLazySingleton<FavoriteLocalDataSource>(
    () => FavoriteLocalDataSourceImpl(box: box),
  );
}
