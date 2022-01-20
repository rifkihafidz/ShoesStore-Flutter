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
        final currentUser = await AuthService()
            .login(email: event.email, password: event.password);
        await LocalStorage().saveUserData(currentUser);
        emit(AuthLoggedIn(user: currentUser));
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

    on<AuthLogout>((event, emit) {
      try {
        emit(AuthLoading());
        LocalStorage().deleteUserData();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });
  }
}
