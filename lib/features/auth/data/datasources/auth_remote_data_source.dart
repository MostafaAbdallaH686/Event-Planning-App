import 'package:event_planning_app/core/utils/errors/errors/exceptions.dart';
import 'package:event_planning_app/core/utils/network/api_endpoint.dart';
import 'package:event_planning_app/core/utils/network/api_helper.dart';
import 'package:event_planning_app/features/auth/data/models/auth_response_model.dart';
import 'package:event_planning_app/features/auth/data/models/user_model.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    String role = 'ATTENDEE',
  });

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> loginWithGoogle();
  Future<AuthResponseModel> loginWithFacebook();
  Future<String> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiHelper _apiHelper;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  const AuthRemoteDataSourceImpl({
    required ApiHelper apiHelper,
    required GoogleSignIn googleSignIn,
    required FacebookAuth facebookAuth,
  })  : _apiHelper = apiHelper,
        _googleSignIn = googleSignIn,
        _facebookAuth = facebookAuth;

 @override
Future<UserModel> register({
  required String username,
  required String email,
  required String password,
  String role = 'ATTENDEE',
}) async {
  try {
    final response = await _apiHelper.post(
      endPoint: ApiEndpoint.register,
      data: {
        'username': username,
        'email': email,
        'password': password,
        'role': role,
      },
    );

    print('📥 Register response: $response'); 

    return UserModel.fromJson(response as Map<String, dynamic>); 
  } on CustomDioException {
    rethrow;
  } catch (e) {
    print('❌ Registration error: $e');
    throw CustomDioException(message: 'Registration failed: $e');
  }
}

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiHelper.post(
        endPoint: ApiEndpoint.login,
        data: {
          'email': email,
          'password': password,
        },
        isAuth: false,
      );

      print('📥 Login response type: ${response.runtimeType}');
      print('📥 Login response data: $response');

      // ApiHelper.post should return response.data (Map<String, dynamic>)
      // NOT the whole Response object
      return AuthResponseModel.fromJson(response as Map<String, dynamic>);
    } on CustomDioException {
      rethrow;
    } catch (e) {
      print('❌ Login parsing error: $e');
      throw CustomDioException(message: 'Login failed: $e');
    }
  }

  @override
  Future<AuthResponseModel> loginWithGoogle() async {
    try {
      // Sign out first to ensure account picker shows
      await _googleSignIn.signOut();

      // Trigger Google Sign In
      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      if (googleUser == null) {
        throw const CustomDioException(
          message: 'Google sign-in cancelled',
          code: 'sign-in-cancelled',
        );
      }

      // Get authentication
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw const CustomDioException(
          message: 'Failed to get Google ID token',
        );
      }

      // Send ID token to backend
      final response = await _apiHelper.post(
        endPoint: '${ApiEndpoint.login}/google',
        data: {
          'idToken': googleAuth.idToken,
        },
        isAuth: false,
      );

      return AuthResponseModel.fromJson(response as Map<String, dynamic>);
    } on CustomDioException {
      rethrow;
    } catch (e) {
      throw CustomDioException(message: 'Google sign-in failed: $e');
    }
  }

  @override
  Future<AuthResponseModel> loginWithFacebook() async {
    try {
      // Trigger Facebook Login
      final LoginResult result = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status != LoginStatus.success) {
        throw CustomDioException(
          message: result.message ?? 'Facebook login failed',
          code: 'facebook-login-failed',
        );
      }

      final accessToken = result.accessToken;
      if (accessToken == null) {
        throw const CustomDioException(
          message: 'Failed to get Facebook access token',
        );
      }

      // Send access token to backend
      final response = await _apiHelper.post(
        endPoint: '${ApiEndpoint.login}/facebook',
        data: {
          'accessToken': accessToken.tokenString,
        },
        isAuth: false,
      );

      return AuthResponseModel.fromJson(response as Map<String, dynamic>);
    } on CustomDioException {
      rethrow;
    } catch (e) {
      throw CustomDioException(message: 'Facebook login failed: $e');
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    try {
      final response = await _apiHelper.post(
        endPoint: ApiEndpoint.refreshToken,
        data: {
          'refreshToken': refreshToken,
        },
        isAuth: false,
      );

      return response['accessToken'] as String;
    } on CustomDioException {
      rethrow;
    } catch (e) {
      throw CustomDioException(message: 'Token refresh failed: $e');
    }
  }
}
