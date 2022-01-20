part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Event login
class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthGetDataUser extends AuthEvent {}

class AuthLogout extends AuthEvent {}
