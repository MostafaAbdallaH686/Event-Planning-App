import 'dart:io';
import 'package:event_planning_app/features/auth/data/user_model.dart';
import 'package:event_planning_app/features/auth/data/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:event_planning_app/core/utils/errors/auth_failure.dart';
import 'package:event_planning_app/core/utils/errors/facebook_login_failure.dart';
import 'package:event_planning_app/core/utils/errors/failures.dart';
import 'package:event_planning_app/core/utils/errors/firestore_failure.dart';
import 'package:event_planning_app/core/utils/errors/google_signin_failure.dart';
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

  Future<void> loginWithUsername({
    required String username,
    required String password,
  }) async {
    emit(UserLoadingUsername());

    try {
      UserModel user = await _repository.loginWithUsernameOrEmail(
        usernameOrEmail: username,
        password: password,
      );

      if (!user.emailVerified) {
        emit(UserErrorNotVerified(
            "Email not verified, please verify your email"));
        return;
      }
      print('user email verified: ${user.emailVerified}');

      emit(UserLoggedIn(user));
      print('User logged in: ${user.username}');

      loginNameCtrl.clear();
      loginPasswordCtrl.clear();
    } on AuthFailure catch (e) {
      emit(UserErrorLoginUsername(e.message));
      print('MO::AuthFailure: ${e.message}');
    } on FirestoreFailure catch (e) {
      emit(UserErrorLoginUsername(e.message));
    } on UnexpectedFailure catch (e) {
      emit(UserErrorLoginUsername(e.message));
    } catch (e) {
      emit(UserErrorLoginUsername('Login failed: $e'));
    }
  }

  Future<void> loginWithFacebook() async {
    emit(UserLoadingFacebook());

    try {
      UserModel user = await _repository.loginWithFacebook();
      emit(UserLoggedIn(user));
    } on FacebookLoginFailure catch (e) {
      if (e.code == 'login-cancelled') {
        emit(UserInitial());
      } else {
        emit(UserErrorLoginFacebook(e.message));
      }
    } on AuthFailure catch (e) {
      emit(UserErrorLoginFacebook(e.message));
    } catch (e) {
      emit(UserErrorLoginFacebook('Facebook login failed: $e'));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(UserLoadingGoogle());

    try {
      UserModel user = await _repository.loginWithGoogle();
      emit(UserLoggedIn(user));
    } on GoogleSignInFailure catch (e) {
      if (e.code == 'sign-in-cancelled') {
        emit(UserInitial());
      } else {
        emit(UserErrorLoginGoogle(e.message));
      }
    } on AuthFailure catch (e) {
      emit(UserErrorLoginGoogle(e.message));
    } catch (e) {
      emit(UserErrorLoginGoogle('Google sign-in failed: $e'));
    }
  }

  Future<void> signUpWithUsernameAndEmail({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(UserSigningUp());

    try {
      UserModel user = await _repository.signUpWithUsernameAndEmail(
        username: username,
        email: email,
        password: password,
      );

      final userInstance = FirebaseAuth.instance.currentUser;
      if (userInstance != null && !userInstance.emailVerified) {
        emit(UserVerificationSent());
        emit(UserErrorNotVerified(
            "Email not verified, please verify your email"));
      } else {
        emit(UserSignedUp(user));
      }

      registerNameCtrl.clear();
      emailCtrl.clear();
      registerPasswordCtrl.clear();
      confirmPassCtrl.clear();
    } on AuthFailure catch (e) {
      emit(UserErrorSignUp(e.message));
    } on FirestoreFailure catch (e) {
      emit(UserErrorSignUp(e.message));
    } catch (e) {
      emit(UserErrorSignUp('Sign up failed: $e'));
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await _repository.sendVerificationEmail(user);
        emit(UserVerificationSent());
      } catch (e) {
        emit(UserErrorVerificationSent('Failed to send verification email'));
      }
    }
  }

  Future<void> logout() async {
    emit(UserLoggingOut());

    try {
      await _repository.logout();

      loginNameCtrl.clear();
      loginPasswordCtrl.clear();
      registerNameCtrl.clear();
      emailCtrl.clear();
      registerPasswordCtrl.clear();
      confirmPassCtrl.clear();

      emit(UserLoggedOut());
    } on AuthFailure catch (e) {
      emit(UserErrorLogout(e.message));
    } catch (e) {
      emit(UserErrorLogout('Logout failed'));
    }
  }

  Future<void> deleteAccount() async {
    emit(UserDeletingAccount());

    try {
      await _repository.deleteAccount();

      loginNameCtrl.clear();
      loginPasswordCtrl.clear();
      registerNameCtrl.clear();
      emailCtrl.clear();
      registerPasswordCtrl.clear();
      confirmPassCtrl.clear();

      emit(UserDeletedAccount());
    } on AuthFailure catch (e) {
      emit(UserErrorDeleteAccount(e.message));
    } on FirestoreFailure catch (e) {
      emit(UserErrorDeleteAccount(e.message));
    } catch (e) {
      emit(UserErrorDeleteAccount('Failed to delete account'));
    }
  }

  Future<void> resetPassword({required String email}) async {
    emit(UserResettingPassword());

    try {
      await _repository.resetPassword(email: email);
      emit(UserResetPasswordSent());
      forgetPemailCtrl.clear();
    } on AuthFailure catch (e) {
      emit(UserErrorResetPassword(e.message));
    } catch (e) {
      emit(UserErrorResetPassword('Failed to send password reset email'));
    }
  }

  Future<void> fetchCurrentUser() async {
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        emit(UserLoggedIn(user));
      } else {
        emit(UserLoggedOut());
      }
    } on AuthFailure catch (e) {
      emit(UserErrorLoginUsername(e.message));
    } on FirestoreFailure catch (e) {
      emit(UserErrorLoginUsername(e.message));
    } catch (e) {
      emit(UserLoggedOut());
    }
  }

  Future<void> updateProfile({
    String? username,
    String? email,
    String? about,
    File? profileImage,
  }) async {
    emit(UserUpdatingProfile());

    try {
      UserModel user = await _repository.updateProfile(
        username: username,
        email: email,
        about: about,
        profileImage: profileImage,
      );

      emit(UserUpdatedProfile(user));
    } on AuthFailure catch (e) {
      emit(UserErrorUpdateProfile(e.message));
    } on FirestoreFailure catch (e) {
      emit(UserErrorUpdateProfile(e.message));
    } catch (e) {
      emit(UserErrorUpdateProfile('Failed to update profile'));
    }
  }
}
