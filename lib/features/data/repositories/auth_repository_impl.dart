import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vibeat/core/api_client.dart';
import 'package:vibeat/core/constants/strings.dart';
import 'package:vibeat/features/domain/entities/user_entity.dart';
import 'package:vibeat/features/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart' as d;

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
  Future<UserEntity?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

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

      if (response.statusCode != 200) return null;

      final responseData = response.data;

      final user = UserEntity(
        id: responseData['id'],
        email: responseData['email'],
        name: responseData['name'],
        jwtToken: responseData['token'],
      );

      await cacheUser(user);
      return user;
    } catch (e) {
      print('Error in signInWithGoogle: $e');
      return null;
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
}
