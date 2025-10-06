import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';

class ContentModel {
  final String image;
  final String title;
  const ContentModel(
    this.image,
    this.title,
  );
}

final List<ContentModel> onboardingContent = [
  ContentModel(
    AppImage.onborading1,
    AppString.onboardingtitle1,
  ),
  ContentModel(
    AppImage.onborading2,
    AppString.onboardingtitle2,
  ),
  ContentModel(
    AppImage.onborading3,
    AppString.onboardingtitle3,
  ),
];
