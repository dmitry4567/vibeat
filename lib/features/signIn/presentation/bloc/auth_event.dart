part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class EmailPasswordRequested extends AuthEvent {
  final String email;
  final String password;

  const EmailPasswordRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class GoogleSignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AnketaDataRequested extends AuthEvent {}