// import 'dart:io';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:event_planning_app/core/utils/errors/auth_failure.dart';
// import 'package:event_planning_app/core/utils/errors/facebook_login_failure.dart';
// import 'package:event_planning_app/core/utils/errors/firestore_failure.dart';
// import 'package:event_planning_app/core/utils/errors/google_signin_failure.dart';
// import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
// import 'package:event_planning_app/features/auth/cubit/user_state.dart';
// import 'package:event_planning_app/features/auth/data/user_model.dart';
// import 'package:event_planning_app/features/auth/data/user_repo.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

// UserRepository get mockUserRepository => MockUserRepository();

// class MockUserRepository extends Mock implements UserRepository {}

// @GenerateMocks([
//   UserRepository,
//   User,
//   FirebaseAuth,
// ])
// void main() {
//   late UserCubit userCubit;
//   late MockUserRepository mockRepository;

//   // Sample test data
//   final testUser = UserModel(
//     uid: 'test-uid',
//     username: 'testuser',
//     email: 'test@example.com',
//     emailVerified: true,
//     profilePicture: '',
//     about: '',
//   );

//   final unverifiedUser = UserModel(
//     uid: 'test-uid',
//     username: 'testuser',
//     email: 'test@example.com',
//     emailVerified: false,
//     profilePicture: '',
//     about: '',
//   );

//   setUp(() {
//     mockRepository = MockUserRepository();
//     userCubit = UserCubit(mockRepository);
//   });

//   tearDown(() {
//     userCubit.close();
//   });

//   group('UserCubit', () {
//     test('initial state is UserInitial', () {
//       expect(userCubit.state, isA<UserInitial>());
//     });

//     group('toggleObscure', () {
//       test('toggles obscureText and emits UserObscureToggled', () {
//         expect(userCubit.obscureText, true);

//         userCubit.toggleObscure();
//         expect(userCubit.obscureText, false);
//         expect(userCubit.state, isA<UserObscureToggled>());

//         userCubit.toggleObscure();
//         expect(userCubit.obscureText, true);
//       });
//     });

//     group('toggleObscureConfirm', () {
//       test('toggles obscureConfirmText and emits UserConfirmObscureToggled',
//           () {
//         expect(userCubit.obscureConfirmText, true);

//         userCubit.toggleObscureConfirm();
//         expect(userCubit.obscureConfirmText, false);
//         expect(userCubit.state, isA<UserConfirmObscureToggled>());

//         userCubit.toggleObscureConfirm();
//         expect(userCubit.obscureConfirmText, true);
//       });
//     });

//     group('loginWithUsername', () {
//       blocTest<UserCubit, UserState>(
//         'emits [UserLoadingUsername, UserLoggedIn] when login succeeds with verified email',
//         build: () {
//           when(mockRepository.loginWithUsernameOrEmail(
//             usernameOrEmail: 'testuser',
//             password: 'password123',
//           )).thenAnswer((_) async => testUser);
//           return userCubit;
//         },
//         act: (cubit) {
//           cubit.loginNameCtrl.text = 'testuser';
//           cubit.loginPasswordCtrl.text = 'password123';
//           return cubit.loginWithUsername(
//             username: 'testuser',
//             password: 'password123',
//           );
//         },
//         expect: () => [
//           UserLoadingUsername(),
//           UserLoggedIn(testUser),
//         ],
//         verify: (_) {
//           expect(userCubit.loginNameCtrl.text, '');
//           expect(userCubit.loginPasswordCtrl.text, '');
//         },
//       );

//       blocTest<UserCubit, UserState>(
//         'emits [UserLoadingUsername, UserErrorNotVerified] when email is not verified',
//         build: () {
//           when(mockRepository.loginWithUsernameOrEmail(
//             usernameOrEmail: 'testuser',
//             password: 'password123',
//           )).thenAnswer((_) async => unverifiedUser);
//           return userCubit;
//         },
//         act: (cubit) => cubit.loginWithUsername(
//           username: 'testuser',
//           password: 'password123',
//         ),
//         expect: () => [
//           UserLoadingUsername(),
//           UserErrorNotVerified("Email not verified, please verify your email"),
//         ],
//       );

//       blocTest<UserCubit, UserState>(
//         'emits [UserLoadingUsername, UserErrorLoginUsername] when AuthFailure occurs',
//         build: () {
//           when(mockRepository.loginWithUsernameOrEmail(
//             usernameOrEmail: 'testuser',
//             password: 'wrongpassword',
//           )).thenThrow(AuthFailure(message: 'Invalid credentials'));
//           return userCubit;
//         },
//         act: (cubit) => cubit.loginWithUsername(
//           username: 'testuser',
//           password: 'wrongpassword',
//         ),
//         expect: () => [
//           UserLoadingUsername(),
//           UserErrorLoginUsername('Invalid credentials'),
//         ],
//       );

//       blocTest<UserCubit, UserState>(
//         'emits [UserLoadingUsername, UserErrorLoginUsername] when FirestoreFailure occurs',
//         build: () {
//           when(mockRepository.loginWithUsernameOrEmail(
//             usernameOrEmail: 'testuser',
//             password: 'password123',
//           )).thenThrow(FirestoreFailure(message: 'Database error'));
//           return userCubit;
//         },
//         act: (cubit) => cubit.loginWithUsername(
//           username: 'testuser',
//           password: 'password123',
//         ),
//         expect: () => [
//           UserLoadingUsername(),
//           UserErrorLoginUsername('Database error'),
//         ],
//       );
//     });

//     group('loginWithFacebook', () {
//       blocTest<UserCubit, UserState>(
//         'emits [UserLoadingFacebook, UserLoggedIn] when Facebook login succeeds',
//         build: () {
//           when(mockRepository.loginWithFacebook())
//               .thenAnswer((_) async => testUser);
//           return userCubit;
//         },
//         act: (cubit) => cubit.loginWithFacebook(),
//         expect: () => [
//           UserLoadingFacebook(),
//           UserLoggedIn(testUser),
//         ],
//       );

//       blocTest<UserCubit, UserState>(
//         'emits [UserLoadingFacebook, UserInitial] when Facebook login is cancelled',
//         build: () {
//           when(mockRepository.loginWithFacebook()).thenThrow(
//               FacebookLoginFailure(
//                   message: 'Login cancelled', code: 'login-cancelled'));
//           return userCubit;
//         },
//         act: (cubit) => cubit.loginWithFacebook(),
//         expect: () => [
//           UserLoadingFacebook(),
//           UserInitial(),
//         ],
//       );

//       blocTest<UserCubit, UserState>(
//         'emits [UserLoadingFacebook, UserErrorLoginFacebook] when Facebook login fails',
//         build: () {
//           when(mockRepository.loginWithFacebook()).thenThrow(
//               FacebookLoginFailure(message: 'Facebook error', code: 'error'));
//           return userCubit;
//         },
//         act: (cubit) => cubit.loginWithFacebook(),
//         expect: () => [
//           UserLoadingFacebook(),
//           UserErrorLoginFacebook('Facebook error'),
//         ],
//       );
//     });

//     group('loginWithGoogle', () {
//       blocTest<UserCubit, UserState>(
//         'emits [UserLoadingGoogle, UserLoggedIn] when Google login succeeds',
//         build: () {
//           when(mockRepository.loginWithGoogle())
//               .thenAnswer((_) async => testUser);
//           return userCubit;
//         },
//         act: (cubit) => cubit.loginWithGoogle(),
//         expect: () => [
//           UserLoadingGoogle(),
//           UserLoggedIn(testUser),
//         ],
//       );

//       blocTest<UserCubit, UserState>(
//         'emits [UserLoadingGoogle, UserInitial] when Google sign-in is cancelled',
//         build: () {
//           when(mockRepository.loginWithGoogle()).thenThrow(GoogleSignInFailure(
//               message: 'Sign-in cancelled', code: 'sign-in-cancelled'));
//           return userCubit;
//         },
//         act: (cubit) => cubit.loginWithGoogle(),
//         expect: () => [
//           UserLoadingGoogle(),
//           UserInitial(),
//         ],
//       );
//     });

//     group('signUpWithUsernameAndEmail', () {
//       blocTest<UserCubit, UserState>(
//         'emits [UserSigningUp, UserSignedUp] when sign up succeeds with verified email',
//         build: () {
//           when(mockRepository.signUpWithUsernameAndEmail(
//             username: 'newuser',
//             email: 'new@example.com',
//             password: 'password123',
//           )).thenAnswer((_) async => testUser);
//           return userCubit;
//         },
//         act: (cubit) {
//           cubit.registerNameCtrl.text = 'newuser';
//           cubit.emailCtrl.text = 'new@example.com';
//           cubit.registerPasswordCtrl.text = 'password123';
//           cubit.confirmPassCtrl.text = 'password123';
//           return cubit.signUpWithUsernameAndEmail(
//             username: 'newuser',
//             email: 'new@example.com',
//             password: 'password123',
//           );
//         },
//         expect: () => [
//           UserSigningUp(),
//           UserSignedUp(testUser),
//         ],
//         verify: (_) {
//           expect(userCubit.registerNameCtrl.text, '');
//           expect(userCubit.emailCtrl.text, '');
//           expect(userCubit.registerPasswordCtrl.text, '');
//           expect(userCubit.confirmPassCtrl.text, '');
//         },
//       );

//       blocTest<UserCubit, UserState>(
//         'emits [UserSigningUp, UserErrorSignUp] when AuthFailure occurs',
//         build: () {
//           when(mockRepository.signUpWithUsernameAndEmail(
//             username: 'newuser',
//             email: 'new@example.com',
//             password: 'password123',
//           )).thenThrow(AuthFailure(message: 'Email already exists'));
//           return userCubit;
//         },
//         act: (cubit) => cubit.signUpWithUsernameAndEmail(
//           username: 'newuser',
//           email: 'new@example.com',
//           password: 'password123',
//         ),
//         expect: () => [
//           UserSigningUp(),
//           UserErrorSignUp('Email already exists'),
//         ],
//       );
//     });

//     group('logout', () {
//       blocTest<UserCubit, UserState>(
//         'emits [UserLoggingOut, UserLoggedOut] and clears controllers when logout succeeds',
//         build: () {
//           when(mockRepository.logout()).thenAnswer((_) async {});
//           return userCubit;
//         },
//         act: (cubit) {
//           // Set some text to verify it gets cleared
//           cubit.loginNameCtrl.text = 'test';
//           cubit.loginPasswordCtrl.text = 'test';
//           return cubit.logout();
//         },
//         expect: () => [
//           UserLoggingOut(),
//           UserLoggedOut(),
//         ],
//         verify: (_) {
//           expect(userCubit.loginNameCtrl.text, '');
//           expect(userCubit.loginPasswordCtrl.text, '');
//         },
//       );

//       blocTest<UserCubit, UserState>(
//         'emits [UserLoggingOut, UserErrorLogout] when logout fails',
//         build: () {
//           when(mockRepository.logout())
//               .thenThrow(AuthFailure(message: 'Logout failed'));
//           return userCubit;
//         },
//         act: (cubit) => cubit.logout(),
//         expect: () => [
//           UserLoggingOut(),
//           UserErrorLogout('Logout failed'),
//         ],
//       );
//     });

//     group('deleteAccount', () {
//       blocTest<UserCubit, UserState>(
//         'emits [UserDeletingAccount, UserDeletedAccount] when delete succeeds',
//         build: () {
//           when(mockRepository.deleteAccount()).thenAnswer((_) async {});
//           return userCubit;
//         },
//         act: (cubit) => cubit.deleteAccount(),
//         expect: () => [
//           UserDeletingAccount(),
//           UserDeletedAccount(),
//         ],
//       );

//       blocTest<UserCubit, UserState>(
//         'emits [UserDeletingAccount, UserErrorDeleteAccount] when delete fails',
//         build: () {
//           when(mockRepository.deleteAccount())
//               .thenThrow(AuthFailure(message: 'Delete failed'));
//           return userCubit;
//         },
//         act: (cubit) => cubit.deleteAccount(),
//         expect: () => [
//           UserDeletingAccount(),
//           UserErrorDeleteAccount('Delete failed'),
//         ],
//       );
//     });

//     group('resetPassword', () {
//       blocTest<UserCubit, UserState>(
//         'emits [UserResettingPassword, UserResetPasswordSent] when reset succeeds',
//         build: () {
//           when(mockRepository.resetPassword(email: 'test@example.com'))
//               .thenAnswer((_) async {});
//           return userCubit;
//         },
//         act: (cubit) {
//           cubit.forgetPemailCtrl.text = 'test@example.com';
//           return cubit.resetPassword(email: 'test@example.com');
//         },
//         expect: () => [
//           UserResettingPassword(),
//           UserResetPasswordSent(),
//         ],
//         verify: (_) {
//           expect(userCubit.forgetPemailCtrl.text, '');
//         },
//       );

//       blocTest<UserCubit, UserState>(
//         'emits [UserResettingPassword, UserErrorResetPassword] when reset fails',
//         build: () {
//           when(mockRepository.resetPassword(email: 'test@example.com'))
//               .thenThrow(AuthFailure(message: 'User not found'));
//           return userCubit;
//         },
//         act: (cubit) => cubit.resetPassword(email: 'test@example.com'),
//         expect: () => [
//           UserResettingPassword(),
//           UserErrorResetPassword('User not found'),
//         ],
//       );
//     });

//     group('fetchCurrentUser', () {
//       blocTest<UserCubit, UserState>(
//         'emits [UserLoggedIn] when user exists',
//         build: () {
//           when(mockRepository.getCurrentUser())
//               .thenAnswer((_) async => testUser);
//           return userCubit;
//         },
//         act: (cubit) => cubit.fetchCurrentUser(),
//         expect: () => [
//           UserLoggedIn(testUser),
//         ],
//       );

//       blocTest<UserCubit, UserState>(
//         'emits [UserLoggedOut] when user is null',
//         build: () {
//           when(mockRepository.getCurrentUser()).thenAnswer((_) async => null);
//           return userCubit;
//         },
//         act: (cubit) => cubit.fetchCurrentUser(),
//         expect: () => [
//           UserLoggedOut(),
//         ],
//       );
//     });

//     group('updateProfile', () {
//       final updatedUser = UserModel(
//         uid: 'test-uid',
//         username: 'updateduser',
//         email: 'updated@example.com',
//         emailVerified: true,
//         profilePicture: 'https://example.com/image.jpg',
//         about: 'Updated bio',
//       );

//       blocTest<UserCubit, UserState>(
//         'emits [UserUpdatingProfile, UserUpdatedProfile] when update succeeds',
//         build: () {
//           when(mockRepository.updateProfile(
//             username: 'updateduser',
//             email: 'updated@example.com',
//             about: 'Updated bio',
//             profileImage: null,
//           )).thenAnswer((_) async => updatedUser);
//           return userCubit;
//         },
//         act: (cubit) => cubit.updateProfile(
//           username: 'updateduser',
//           email: 'updated@example.com',
//           about: 'Updated bio',
//         ),
//         expect: () => [
//           UserUpdatingProfile(),
//           UserUpdatedProfile(updatedUser),
//         ],
//       );

//       blocTest<UserCubit, UserState>(
//         'emits [UserUpdatingProfile, UserErrorUpdateProfile] when update fails',
//         build: () {
//           when(mockRepository.updateProfile(
//             username: 'updateduser',
//             email: null,
//             about: null,
//             profileImage: null,
//           )).thenThrow(FirestoreFailure(message: 'Update failed'));
//           return userCubit;
//         },
//         act: (cubit) => cubit.updateProfile(username: 'updateduser'),
//         expect: () => [
//           UserUpdatingProfile(),
//           UserErrorUpdateProfile('Update failed'),
//         ],
//       );
//     });

//     test('dispose method disposes all controllers', () {
//       userCubit.close();

//       expect(() => userCubit.forgetPemailCtrl.text, throwsA(isA<Error>()));
//       expect(() => userCubit.registerNameCtrl.text, throwsA(isA<Error>()));
//       expect(() => userCubit.registerPasswordCtrl.text, throwsA(isA<Error>()));
//       expect(() => userCubit.loginNameCtrl.text, throwsA(isA<Error>()));
//       expect(() => userCubit.confirmPassCtrl.text, throwsA(isA<Error>()));
//       expect(() => userCubit.emailCtrl.text, throwsA(isA<Error>()));
//       expect(() => userCubit.loginPasswordCtrl.text, throwsA(isA<Error>()));
//     });
//   });
// }
