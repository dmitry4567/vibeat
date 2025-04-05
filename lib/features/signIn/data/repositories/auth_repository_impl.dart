import 'dart:convert';
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
  Future<Tuple2<UserEntity?, bool>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return const Tuple2(null, false);

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final response = await _apiClient.post(
        '/auth/google',
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
        id: responseData['id'],
        email: responseData['email'],
        name: responseData['name'],
        jwtToken: responseData['token'],
      );

      await cacheUser(user);

      // Проверяем наличие параметра 'message' в responseData
      final bool hasMessage = responseData.containsKey('message');

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
    try {
      final jwtToken = await _secureStorage.read(key: AppStrings.jwtTokenKey);
      if (jwtToken == null) return null;

      final account = await _googleSignIn.signInSilently();
      if (account == null) return null;

      return UserEntity(
        id: account.id,
        email: account.email,
        name: account.displayName,
        photoUrl: account.photoUrl,
        jwtToken: jwtToken,
      );
    } catch (e) {
      print('Error in getCurrentUser: $e');
      return null;
    }
  }

  @override
  Future<void> cacheUser(UserEntity user) async {
    await _secureStorage.write(
      key: AppStrings.jwtTokenKey,
      value: user.jwtToken,
    );
  }

  @override
  Future<void> clearCache() async {
    await _secureStorage.delete(key: AppStrings.jwtTokenKey);
  }

  @override
  Future<bool> sendDataAnketa() async {
    final response = await _apiClient.post(
      '/anketa',
      options: d.Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'data': ["genre1", "genre2", "genre3"],
      },
    );

    if (response.statusCode != 200) return false;

    return true;
  }
}
