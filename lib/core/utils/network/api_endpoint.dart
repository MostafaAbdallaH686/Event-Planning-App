//ToDO later
// NOT USED THERE IS NOT Api
abstract class ApiEndpoint {
  // Auth
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String refreshToken = "/auth/refresh-token";
  static const String profile = "/auth/profile/me";

  // Events
  static const String events = "/events";

  // Categories
  static const String categories = "/categories";

  // Upload
  static const String uploadImage = "/upload/image";
  // User interests (favorite/bookmark)
  static const String userInterests = "/users/me/interests";
  static String addInterest(String eventId) => "/users/me/interests/$eventId";
  static String removeInterest(String eventId) =>
      "/users/me/interests/$eventId";
}

abstract class ApiBaseUrl {
  static const String baseUrl =
      "https://event-management-api-production-4980.up.railway.app/api";
}
