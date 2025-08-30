import 'package:equatable/equatable.dart';

enum AuthType { email, google }

class UserEntity extends Equatable {
  final String jwtToken;
  final String refreshToken;
  final AuthType authType;

  const UserEntity({
    required this.jwtToken,
    required this.refreshToken,
    required this.authType,
  });

  @override
  List<Object?> get props => [jwtToken, refreshToken, authType];
}
