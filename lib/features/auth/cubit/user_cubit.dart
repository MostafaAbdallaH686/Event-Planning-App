import 'package:event_planning_app/features/auth/data/user_model.dart';
import 'package:event_planning_app/features/auth/data/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  UserCubit(this._repository) : super(UserInitial());

  Future<void> loginWithUsername(String username, String password) async {
    emit(UserLoadingUsername());
    try {
      UserModel user = await _repository.loginWithUsername(username, password);
      emit(UserLoggedIn(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> loginWithFacebook() async {
    emit(UserLoadingFacebook());
    try {
      UserModel user = await _repository.loginWithFacebook();
      emit(UserLoggedIn(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(UserLoggingOut());
    await _repository.logout();
    emit(UserLoggedOut());
  }

  Future<void> resetPassword(String email) async {
    emit(UserLoadingEmail());
    try {
      await _repository.resetPassword(email);
      emit(UserEmailSent());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(UserLoadingGoogle());
    try {
      UserModel? user = await _repository.loginWithGoogle();

      if (user != null) {
        emit(UserLoggedIn(user));
        print("Welcome ${user.username}");
      } else {
        emit(UserLoggedOut());
        print("Sign-in canceled");
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
