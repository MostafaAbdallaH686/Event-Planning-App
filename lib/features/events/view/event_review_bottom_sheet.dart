import 'package:flutter/material.dart';

import '../../../core/utils/theme/app_colors.dart';
import '../../../core/utils/theme/app_text_style.dart';
import '../../../core/utils/utils/app_distance.dart';
import '../../../core/utils/utils/app_image.dart';
import '../../../core/utils/utils/app_radius.dart';
import '../../../core/utils/utils/app_padding.dart';
import '../../../core/utils/utils/app_string.dart';

class EventReviewBottomSheet extends StatefulWidget {
  const EventReviewBottomSheet({super.key});

  @override
  State<EventReviewBottomSheet> createState() => _EventReviewBottomSheetState();
}

class _EventReviewBottomSheetState extends State<EventReviewBottomSheet> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double sheetHeight = MediaQuery.of(context).size.height * 0.70;

    return Material(
      color: AppColor.scaffoldBackground,
      borderRadius: AppRadius.large.copyWith(bottomLeft: Radius.zero, bottomRight: Radius.zero),
      child: Container(
        height: sheetHeight,
        padding: EdgeInsets.only(
          top: AppDistance.medium,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColor.scaffoldBackground,
          borderRadius: AppRadius.large.copyWith(bottomLeft: Radius.zero, bottomRight: Radius.zero),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: AppWidth.w40,
                  height: AppHeight.h5,
                  decoration: BoxDecoration(
                    color: AppColor.colorbr80.withOpacity(0.5),
                    borderRadius: AppRadius.segmentsRadius,
                  ),
                ),
              ),
              SizedBox(height: AppHeight.h32),

              Padding(
                padding: AppPadding.horizontal16,
                child: Text(
                  AppString.leaveAReview,
                  style: AppTextStyle.bold20(AppColor.colorb26),
                ),
              ),
              SizedBox(height: AppHeight.h20),

              Padding(
                padding: AppPadding.horizontal16,
                child: _buildStaticEventCardPlaceholder(),
              ),
              SizedBox(height: AppHeight.h40),

              Center(
                child: Text(
                  AppString.giveYourRating,
                  style: AppTextStyle.medium14(AppColor.colorgr88),
                ),
              ),
              SizedBox(height: AppHeight.h20),

              Center(child: _buildStarRating()),
              SizedBox(height: AppHeight.h32),

              Padding(
                padding: AppPadding.horizontal16,
                child: _buildCommentField(),
              ),
              SizedBox(height: AppHeight.h32),

              Padding(
                padding: AppPadding.horizontal16,
                child: Row(
                  children: [
                    Expanded(child: _buildCancelButton()),
                    SizedBox(width: AppDistance.medium),
                    Expanded(child: _buildSubmitButton()),
                  ],
                ),
              ),
              SizedBox(height: AppHeight.h32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaticEventCardPlaceholder() {
    final String eventDateTime = "${AppString.eventDateSpecific} • ${AppString.eventTimeSpecific}";

    return Container(
      padding: AppPadding.taskContainer,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: AppRadius.dialogRadius,
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadowColor,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppRadius.dialogRadius,
            child: Image.asset(
              AppImage.singer,
              width: AppWidth.w80,
              height: AppHeight.h80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: AppDistance.small),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                // FIXED: Using 'regular13' as the correct available style
                Text(
                  eventDateTime,
                  style: AppTextStyle.regular13(AppColor.subTitleGrey),
                ),
                SizedBox(height: AppHeight.h5),
                // FIXED: Using 'semibold15'
                Text(
                  AppString.eventSpecificTitle,
                  style: AppTextStyle.semibold15(AppColor.colorb26),
                ),
                SizedBox(height: AppHeight.h5),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: AppColor.colorbr688),
                    SizedBox(width: AppDistance.small / 2),
                    // FIXED: Using 'light12'
                    Text(
                      AppString.eventLocationName,
                      style: AppTextStyle.light12(AppColor.colorbr688),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Icon(Icons.bookmark_sharp, size: 24, color: AppColor.black),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            Icons.star_rounded,
            size: 40,
            color: index < _rating ? AppColor.starYellow : AppColor.colorbrD8,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1;
            });
          },
        );
      }),
    );
  }

  Widget _buildCommentField() {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(AppDistance.small),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.black, width: 1),
        borderRadius: AppRadius.buttonRaduis,
      ),
      child: TextField(
        controller: _commentController,
        decoration: InputDecoration(
          hintText: AppString.addAComment,
          // FIXED: Using 'light12'
          hintStyle: AppTextStyle.light12(AppColor.subTitleGrey),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        maxLines: 5,
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      height: AppHeight.h54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.white,
          foregroundColor: AppColor.black,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRaduis),
          side: BorderSide(color: AppColor.black.withOpacity(0.1)),
          elevation: 0,
        ),
        onPressed: () => Navigator.pop(context),
        child: Text(
          AppString.cancel,
          // FIXED: Using 'semibold17'
          style: AppTextStyle.semibold17(AppColor.black),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: AppHeight.h54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryButton,
          foregroundColor: AppColor.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRaduis),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          AppString.submit,

          style: AppTextStyle.semibold17(AppColor.white),
        ),
      ),
    );
  }
}