import 'package:event_planning_app/core/utils/model/event_model.dart';
import 'package:event_planning_app/features/home/data/catagory_model.dart';

class HomeData {
  final List<CategoryModel> categories;
  final List<EventModel> upcomingEvents;
  final List<EventModel> popularEvents;
  final List<EventModel> recommendedEvents;

  const HomeData({
    required this.categories,
    required this.upcomingEvents,
    required this.popularEvents,
    required this.recommendedEvents,
  });
}
