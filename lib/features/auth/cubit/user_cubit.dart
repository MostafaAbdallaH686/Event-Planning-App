import 'package:event_planning_app/features/auth/data/user_model.dart';
import 'package:event_planning_app/features/auth/data/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;
  UserCubit(this._repository) : super(UserInitial());
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool obscureText = true;
  void toggleObscure() {
    obscureText = !obscureText;
    emit(UserObscureToggled(obscureText));
  }

  @override
  Future<void> close() {
    nameCtrl.dispose();
    passwordCtrl.dispose();
    return super.close();
  }

  Future<void> loginWithUsername(
      {required String username, required String password}) async {
    emit(UserLoadingUsername());
    try {
      UserModel user = await _repository.loginWithUsername(
          username: username, password: password);
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

  Future<void> resetPassword({required String email}) async {
    emit(UserResettingPassword());
    try {
      await _repository.resetPassword(email: email);
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
      } else {
        emit(UserLoggedOut());
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> signUpWithUsernameAndEmail(
      {required String username,
      required String email,
      required String password}) async {
    emit(UserSigningUp());
    try {
      UserModel user = await _repository.signUpWithUsernameAndEmail(
          username: username, email: email, password: password);
      emit(UserSignedUp(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
