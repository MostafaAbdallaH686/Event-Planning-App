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
  static String eventById(String id) => "/events/$id";
  static const String myEvents = "/events/my-events";

  // Categories
  static const String categories = "/categories";

  // Upload
  static const String uploadImage = "/upload/image";
}

abstract class ApiBaseUrl {
  static const String baseUrl =
      "https://event-management-api-production-4980.up.railway.app/api";
}
