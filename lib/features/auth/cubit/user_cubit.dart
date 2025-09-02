import 'package:event_planning_app/features/auth/data/user_model.dart';
import 'package:event_planning_app/features/auth/data/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;
  UserCubit(this._repository) : super(UserInitial());
  final TextEditingController confirmPassCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController registerNameCtrl = TextEditingController();
  final TextEditingController registerPasswordCtrl = TextEditingController();
  final TextEditingController loginNameCtrl = TextEditingController();
  final TextEditingController loginPasswordCtrl = TextEditingController();
  bool obscureText = true;
  bool obscureConfirmText = true;

  void toggleObscure() {
    obscureText = !obscureText;
    emit(UserObscureToggled(obscureText));
  }

  void toggleObscureConfirm() {
    obscureConfirmText = !obscureConfirmText;
    emit(UserConfirmObscureToggled(obscureConfirmText));
  }

  @override
  Future<void> close() {
    registerNameCtrl.dispose();
    registerPasswordCtrl.dispose();
    loginNameCtrl.dispose();
    confirmPassCtrl.dispose();
    emailCtrl.dispose();
    loginPasswordCtrl.dispose();
    return super.close();
  }

  Future<void> loginWithUsername(
      {required String username, required String password}) async {
    emit(UserLoadingUsername());
    try {
      UserModel user = await _repository.loginWithUsername(
          username: username, password: password);
      emit(UserLoggedIn(user));
      loginNameCtrl.clear();
      loginPasswordCtrl.clear();
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
    // Clear all relevant fields on logout
    loginNameCtrl.clear();
    loginPasswordCtrl.clear();
    registerNameCtrl.clear();
    emailCtrl.clear();
    registerPasswordCtrl.clear();
    confirmPassCtrl.clear();
  }

  Future<void> resetPassword({required String email}) async {
    emit(UserResettingPassword());
    try {
      await _repository.resetPassword(email: email);
      emit(UserEmailSent());
      emailCtrl.clear(); // assuming this was used
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
      registerNameCtrl.clear();
      emailCtrl.clear();
      registerPasswordCtrl.clear();
      confirmPassCtrl.clear();
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
