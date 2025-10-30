// purpose: This file contains the keys used for storing data in SharedPreferences.
// please make sure to keep the keys consistent across the app to avoid data retrieval issues.

abstract class SharedPrefereneceKey {
  static const String isLogin = "isLogin";

  static const String accesstoken = "access_token";
  static const String refreshtoken = "refresh_token";
  static const String phone = "phone";
  static const String favInterests = " selected_Interests";
  static const String isFirstTime = "isFirstTime";
  //static const String onboardingCompleted = "onboarding_completed";
  static const String isFirstLogin = "is_first_login";
}
