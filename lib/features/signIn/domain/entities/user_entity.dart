import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final String jwtToken;

  const UserEntity({
    required this.id,
    required this.email,
    required this.jwtToken,
    this.name,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [id, email, jwtToken, name, photoUrl];
}