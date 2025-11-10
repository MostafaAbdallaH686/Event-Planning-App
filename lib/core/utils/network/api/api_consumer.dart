abstract class ApiConsumer {
  // Simulate a network call
 Future <dynamic>  get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }
      );
 Future <dynamic> post(
      String url, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? data,
        Map<String, dynamic>? headers,
        bool isFormData = false,
      }
      );

 Future<dynamic> delete(
      String url, {
        Map<String, dynamic>? queryParameters,
       Map<String, dynamic>? data,
        Map<String, dynamic>? headers,
       bool isFormData = false,
      }
      );
Future<dynamic>  patch(
      String url, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? data,
        Map<String, dynamic>? headers,
      bool isFormData = false,
      }
      );
}