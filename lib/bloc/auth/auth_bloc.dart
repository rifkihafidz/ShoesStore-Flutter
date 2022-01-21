import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shamo_frontend/local_storage/user.dart';
import 'package:shamo_frontend/models/user_model.dart';
import 'package:shamo_frontend/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLogin>((event, emit) async {
      try {
        emit(AuthLoading());
        final currentUser = await AuthService().login(
          email: event.email,
          password: event.password,
        );
        await LocalStorage().saveUserData(currentUser);
        emit(AuthLoggedIn(user: currentUser));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<AuthRegister>((event, emit) async {
      try {
        emit(AuthLoading());
        final newUser = await AuthService().register(
          name: event.name,
          username: event.username,
          email: event.email,
          password: event.password,
        );
        await LocalStorage().saveUserData(newUser);
        emit(AuthLoggedIn(user: newUser));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<AuthUpdateProfile>((event, emit) async {
      try {
        emit(AuthLoading());
        final updatedUser = await AuthService().updateProfile(
            name: event.name, email: event.email, username: event.username);
        emit(AuthLoggedIn(user: updatedUser));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<AuthGetDataUser>((event, emit) {
      try {
        emit(AuthLoading());
        UserModel _user = LocalStorage().getUserData();
        emit(AuthLoggedIn(user: _user));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<AuthLogout>((event, emit) async {
      try {
        emit(AuthLoading());
        LocalStorage().deleteUserData();
        await AuthService().logout();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });
  }
}
