import 'package:flutter/material.dart';

import '../../../core/utils/theme/app_colors.dart';
import '../../../core/utils/utils/app_distance.dart';
import '../../../core/utils/utils/app_radius.dart';
import '../../../core/utils/utils/app_string.dart';

class EventShareBottomSheet extends StatelessWidget {
  const EventShareBottomSheet({super.key});

  void _onShareTap(BuildContext context, String appName) {
    Navigator.pop(context);
  }

  Widget _buildShareItem(
      BuildContext context,
      String title,
      Color bgColor,
      IconData icon,
      void Function(BuildContext, String) onTapCallback) {
    return Column(
      children: [
        InkWell(
          // Correct usage: Pass context and title (appName)
          onTap: () => onTapCallback(context, title),
          borderRadius: AppRadius.small,
          child: Container(
            width: AppWidth.w48,
            height: AppHeight.h48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: AppRadius.small,
            ),
            child: Center(
              child: Icon(
                icon,
                color: AppColor.white,
                size: AppWidth.w24,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDistance.small / 2),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: AppColor.colorgr88,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: const EdgeInsets.only(top: AppDistance.medium),
      decoration: BoxDecoration(
        color: AppColor.scaffoldBackground,
        borderRadius: AppRadius.large.copyWith(bottomLeft: Radius.zero, bottomRight: Radius.zero),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppWidth.w40,
            height: AppHeight.h5,
            decoration: BoxDecoration(
              color: AppColor.colorbr80.withOpacity(0.5),
              borderRadius: AppRadius.segmentsRadius,
            ),
          ),
          SizedBox(height: AppHeight.h20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDistance.large),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppString.shareWithFriends,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColor.colorb26,
                ),
              ),
            ),
          ),
          SizedBox(height: AppHeight.h20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDistance.small),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: AppDistance.small,
              mainAxisSpacing: AppDistance.medium,
              childAspectRatio: 0.8,
              children: [
                // Passing the method reference directly, avoiding the complex helper function
                _buildShareItem(context, AppString.copyLink, AppColor.colorbrD8, Icons.link, _onShareTap),
                _buildShareItem(context, AppString.whatsapp, AppColor.colorbrD8, Icons.message, _onShareTap),
                _buildShareItem(context, AppString.facebook, AppColor.facebookbutton, Icons.facebook, _onShareTap),
                _buildShareItem(context, AppString.messenger, AppColor.primaryButton, Icons.chat, _onShareTap),

                _buildShareItem(context, AppString.twitter, AppColor.colorblFF, Icons.close, _onShareTap),
                _buildShareItem(context, AppString.instagram, AppColor.colorbr80, Icons.camera_alt, _onShareTap),
                _buildShareItem(context, AppString.skype, AppColor.colorblFF, Icons.add_call, _onShareTap),
                _buildShareItem(context, AppString.message, AppColor.colorbr80, Icons.message_outlined, _onShareTap),
              ],
            ),
          ),
          SizedBox(height: AppHeight.h20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDistance.large),
            child: SizedBox(
              width: double.infinity,
              height: AppHeight.h54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryButton,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRaduis),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  AppString.cancel,
                  style: TextStyle(fontSize: 18, color: AppColor.white),
                ),
              ),
            ),
          ),
          SizedBox(height: AppHeight.h32),
        ],
      ),
    );
  }
}