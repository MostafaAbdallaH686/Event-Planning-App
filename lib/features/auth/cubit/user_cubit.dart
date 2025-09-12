import 'package:event_planning_app/features/auth/data/user_model.dart';
import 'package:event_planning_app/features/auth/data/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;
  UserCubit(this._repository) : super(UserInitial());
  final TextEditingController confirmPassCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController forgetPemailCtrl = TextEditingController();
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
    forgetPemailCtrl.dispose();
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
      UserModel user = await _repository.loginWithUsernameOrEmail(
          usernameOrEmail: username, password: password);
      if (!user.emailVerified) {
        emit(UserErrorNotVerified(
            "Email not verified, please verify your email"));
        return;
      }
      emit(UserLoggedIn(user));
      loginNameCtrl.clear();
      loginPasswordCtrl.clear();
    } catch (e) {
      emit(UserErrorLoginUsername(e.toString()));
    }
  }

  Future<void> loginWithFacebook() async {
    emit(UserLoadingFacebook());
    try {
      UserModel user = await _repository.loginWithFacebook();
      emit(UserLoggedIn(user));
    } catch (e) {
      emit(UserErrorLoginFacebook(e.toString()));
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
      emit(UserResetPasswordSent());
      emailCtrl.clear(); // assuming this was used
    } catch (e) {
      emit(UserErrorResetPassword(e.toString()));
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
      emit(UserErrorLoginGoogle(e.toString()));
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

      final userInstance = FirebaseAuth.instance.currentUser;

      if (userInstance != null && userInstance.emailVerified == false) {
        emit(UserErrorNotVerified(
            "Email not verified, please verify your email"));
      }
      emit(UserVerificationSent());
      emit(UserSignedUp(user));
      registerNameCtrl.clear();
      emailCtrl.clear();
      registerPasswordCtrl.clear();
      confirmPassCtrl.clear();
    } catch (e) {
      emit(UserErrorSignUp(e.toString()));
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await _repository.sendVerificationEmail(user);
        emit(UserVerificationSent());
      } catch (e) {
        emit(UserErrorVerificationSent(e.toString()));
      }
    }
  }
}
