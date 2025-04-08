import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vibeat/core/api_client.dart';
import 'package:vibeat/core/constants/strings.dart';
import 'package:vibeat/features/signIn/domain/entities/user_entity.dart';
import 'package:vibeat/features/signIn/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart' as d;
import 'package:tuple/tuple.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _secureStorage;
  final ApiClient _apiClient;

  AuthRepositoryImpl({
    required GoogleSignIn googleSignIn,
    required FlutterSecureStorage secureStorage,
    required ApiClient apiClient,
  })  : _googleSignIn = googleSignIn,
        _secureStorage = secureStorage,
        _apiClient = apiClient;

  @override
  Future<Tuple2<UserEntity?, String?>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _apiClient.post(
        '/login',
        options: d.Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'email': email,
          'password': password,
        },
      );

      final responseData = response.data;

      final user =
          UserEntity(jwtToken: responseData['token'], authType: AuthType.email);

      await cacheUser(user, AuthType.email);

      return Tuple2(user, null);
    } on d.DioException catch (e) {
      final responseData = e.response!.data;

      return Tuple2(null, responseData['message']);
    }
  }

  @override
  Future<Tuple2<UserEntity?, bool>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return const Tuple2(null, false);

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final response = await _apiClient.post(
        '/auth/google/getjwt',
        options: d.Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'token': googleAuth.idToken,
        },
      );

      if (response.statusCode != 200) return const Tuple2(null, false);

      final responseData = response.data;

      final user = UserEntity(
        jwtToken: responseData['token'],
        authType: AuthType.google,
      );

      await cacheUser(user, AuthType.google);

      // Проверяем наличие параметра 'message' в responseData
      final bool hasMessage = responseData.containsKey('new_user');

      return Tuple2(user, hasMessage);
    } catch (e) {
      print('Error in signInWithGoogle: $e');
      return const Tuple2(null, false);
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await clearCache();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final authType = await _secureStorage.read(key: AppStrings.authType);

    if (authType == AuthType.email.name) {
      final jwtToken = await _secureStorage.read(key: AppStrings.jwtTokenKey);
      if (jwtToken == null) return null;

      return UserEntity(
        jwtToken: jwtToken,
        authType: AuthType.email,
      );
    } else if (authType == AuthType.google.name) {
      try {
        final account = await _googleSignIn.signInSilently();
        if (account == null) return null;

        final jwtToken = await _secureStorage.read(key: AppStrings.jwtTokenKey);
        if (jwtToken == null) return null;

        return UserEntity(
          jwtToken: jwtToken,
          authType: AuthType.google,
        );
      } catch (e) {
        print('Error in _getCurrentUserFromGoogle: $e');
        return null;
      }
    }

    return null;
  }

  @override
  Future<void> cacheUser(UserEntity user, AuthType authType) async {
    await _secureStorage.write(
      key: AppStrings.jwtTokenKey,
      value: user.jwtToken,
    );
    await _secureStorage.write(
      key: AppStrings.authType,
      value: authType.name,
    );
  }

  @override
  Future<void> clearCache() async {
    await _secureStorage.delete(key: AppStrings.jwtTokenKey);
    await _secureStorage.delete(key: AppStrings.authType);
  }
}
