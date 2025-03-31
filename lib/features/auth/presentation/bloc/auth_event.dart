part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GoogleSignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}