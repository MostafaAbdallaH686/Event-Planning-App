import 'dart:io';

import 'package:event_planning_app/core/utils/errors/auth_failure.dart';
import 'package:event_planning_app/core/utils/errors/firestore_failure.dart';
import 'package:event_planning_app/core/utils/model/user_model.dart';
import 'package:event_planning_app/features/profile/cubit/profile_state.dart';
import 'package:event_planning_app/features/profile/data/profile_repostiry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  ProfileCubit(this._repository) : super(ProfileInitial());

  Future<void> deleteAccount() async {
    emit(UserDeletingAccount());

    try {
      await _repository.deleteAccount();

      emit(UserDeletedAccount());
    } on AuthFailure catch (e) {
      emit(UserErrorDeleteAccount(e.message));
    } on FirestoreFailure catch (e) {
      emit(UserErrorDeleteAccount(e.message));
    } catch (e) {
      emit(UserErrorDeleteAccount('Failed to delete account'));
    }
  }

  Future<void> logout() async {
    emit(UserLoggingOut());

    try {
      await _repository.logout();

      emit(UserLoggedOut());
    } on AuthFailure catch (e) {
      emit(UserErrorLogout(e.message));
    } catch (e) {
      emit(UserErrorLogout('Logout failed'));
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
    // String? email,
    String? about,
    File? profileImage,
  }) async {
    emit(UserUpdatingProfile());

    try {
      UserModel user = await _repository.updateProfile(
        username: username,
        // email: email,
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

  Future<void> changeEmail({
    required String currentEmail,
    required String newEmail,
    required String password,
  }) async {
    emit(UserChangingEmail());

    try {
      UserModel user = await _repository.changeEmail(
        currentEmail: currentEmail,
        newEmail: newEmail,
        password: password,
      );

      emit(UserChangedEmail(user));
    } on AuthFailure catch (e) {
      emit(UserErrorChangeEmail(e.message));
    } on FirestoreFailure catch (e) {
      emit(UserErrorChangeEmail(e.message));
    } catch (e) {
      emit(UserErrorChangeEmail('Failed to change email'));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(UserChangingPassword());

    try {
      UserModel user = await _repository.updatePassword(
        currentPassword,
        newPassword,
      );

      emit(UserChangedPassword(user));
    } on AuthFailure catch (e) {
      emit(UserErrorChangePassword(e.message));
    } catch (e) {
      emit(UserErrorChangePassword('Failed to change password'));
    }
  }
}
