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

  AuthLogin({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthRegister extends AuthEvent {
  final String name;
  final String username;
  final String email;
  final String password;

  AuthRegister({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, username, email, password];
}

class AuthUpdateProfile extends AuthEvent {
  final String name;
  final String email;
  final String username;

  AuthUpdateProfile({
    required this.name,
    required this.email,
    required this.username,
  });

  @override
  List<Object> get props => [name, email, username];
}

class AuthGetDataUser extends AuthEvent {}

class AuthLogout extends AuthEvent {}
