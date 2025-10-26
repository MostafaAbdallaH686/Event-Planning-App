import 'dart:io';
import 'package:event_planning_app/core/utils/errors/network_failure.dart';
import 'package:event_planning_app/core/utils/network/api_endpoint.dart';
import 'package:event_planning_app/core/utils/network/api_helper.dart';
import 'package:event_planning_app/features/events/data/events_model.dart';
import 'package:event_planning_app/features/events/data/events_repository.dart';

class EventRepositoryApi implements EventRepository {
  final ApiHelper _api;

  EventRepositoryApi(this._api);

  @override
  Future<EventModel> createEvent({
    required EventModel input,
    File? imageFile,
  }) async {
    try {
      final fields = <String, dynamic>{
        'title': input.title.trim(),
        'description': input.description.trim(),
        'categoryId': input.categoryId, // Must be valid UUID from your DB
        'location': input.location.trim(),
        'dateTime': input.date.toUtc().toIso8601String(),
        'maxAttendees': input.maxAttendees, // 🔧 FIXED: Was missing!
        'paymentRequired': input.paymentRequired,
      };

      print('🚀 Creating event: ${input.title}');
      print('📅 Date: ${input.date.toIso8601String()}');
      print('👥 Max attendees: ${input.maxAttendees}');
      print('💰 Payment: \$${input.paymentRequired}');

      final json = await _api.postMultipart(
        endPoint: ApiEndpoint.events,
        fields: fields,
        file: imageFile,
        fileField: 'image', // Must match your multer middleware
        isAuth: true,
        onSendProgress: (sent, total) {
          final percent = (sent / total * 100).toStringAsFixed(0);
          print('📤 Upload progress: $percent%');
        },
      );

      // Parse response
      if (json is Map<String, dynamic>) {
        print('✅ Event created successfully!');
        return EventModel.fromJson(json);
      }

      throw CustomDioException(
        errMessage: 'Unexpected response format: ${json.runtimeType}',
      );
    } on CustomDioException {
      rethrow;
    } catch (e) {
      print('❌ Create event error: $e');
      throw CustomDioException(errMessage: 'Unexpected error: $e');
    }
  }
}
