import 'package:tuple/tuple.dart';
import 'package:vibeat/features/signIn/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Tuple2<UserEntity?, String?>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Tuple2<UserEntity?, bool>> signInWithGoogle();
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Future<void> cacheUser(UserEntity user, AuthType authType);
  Future<void> clearCache();
}
