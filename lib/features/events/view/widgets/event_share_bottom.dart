import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:flutter/material.dart';

class EventShareBottomSheet extends StatelessWidget {
  const EventShareBottomSheet({super.key});

  void _onShareTap(BuildContext context, String appName) {
    Navigator.pop(context);
  }

  Widget _buildShareItem(BuildContext context, String title, Color bgColor,
      IconData icon, void Function(BuildContext, String) onTapCallback) {
    return Column(
      children: [
        InkWell(
          // Correct usage: Pass context and title (appName)
          onTap: () => onTapCallback(context, title),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                icon,
                color: AppColor.white,
                size: 24,
              ),
            ),
          ),
        ),
        //  const SizedBox(height: 15),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: AppColor.colorbr88,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: AppColor.scaffoldBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: AppColor.colorbr80.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
              children: [
                // Passing the method reference directly, avoiding the complex helper function
                _buildShareItem(context, AppString.copyLink, AppColor.colorbrD8,
                    Icons.link, _onShareTap),
                _buildShareItem(context, AppString.whatsapp, AppColor.colorbrD8,
                    Icons.message, _onShareTap),
                _buildShareItem(context, AppString.facebook,
                    AppColor.facebookbutton, Icons.facebook, _onShareTap),
                _buildShareItem(context, AppString.messenger,
                    AppColor.sharedbutton, Icons.chat, _onShareTap),

                _buildShareItem(context, AppString.twitter, AppColor.blue,
                    Icons.close, _onShareTap),
                _buildShareItem(context, AppString.instagram,
                    AppColor.colorbr80, Icons.camera_alt, _onShareTap),
                _buildShareItem(context, AppString.skype, AppColor.blue,
                    Icons.add_call, _onShareTap),
                _buildShareItem(context, AppString.message, AppColor.colorbr80,
                    Icons.message_outlined, _onShareTap),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.sharedbutton,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
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
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
