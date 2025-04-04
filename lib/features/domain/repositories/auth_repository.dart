import 'package:tuple/tuple.dart';
import 'package:vibeat/features/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Tuple2<UserEntity?, bool>> signInWithGoogle();
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Future<void> cacheUser(UserEntity user);
  Future<void> clearCache();
  Future<bool> sendDataAnketa();
}