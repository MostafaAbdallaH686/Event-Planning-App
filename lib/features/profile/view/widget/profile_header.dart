import 'package:event_planning_app/core/utils/model/user_model.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_radius.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEdit;
  final Size size;

  const ProfileHeader(
      {super.key,
      required this.user,
      required this.onEdit,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: size.height * 0.08,
          backgroundColor: AppColor.colorgr88,
          backgroundImage:
              (user.profilePicture != null && user.profilePicture!.isNotEmpty)
                  ? NetworkImage(user.profilePicture!)
                  : null,
          child: (user.profilePicture == null || user.profilePicture!.isEmpty)
              ? Text(
                  user.username.isNotEmpty
                      ? user.username[0].toUpperCase()
                      : '?',
                  style: AppTextStyle.bold35(AppColor.colorb26),
                )
              : null,
        ),
        SizedBox(height: size.height * 0.025),
        Text(
          user.username,
          style: AppTextStyle.bold24(AppColor.colorb26),
        ),
        SizedBox(height: size.height * 0.0125),
        Text(
          user.email,
          style: AppTextStyle.regular14(AppColor.colorgr88),
        ),
        SizedBox(height: size.height * 0.0175),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Stat(number: user.followingCount, label: AppString.following),
            Container(
              width: 1,
              height: 30,
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.09),
              color: AppColor.colorgrDD,
            ),
            _Stat(number: user.followersCount, label: AppString.followers),
          ],
        ),
        const SizedBox(height: 34),
        SizedBox(
          width: 230,
          height: 54,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColor.colorblFF,
              side: BorderSide(color: AppColor.colorblFF, width: 1.4),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.buttonRaduis,
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: .2,
              ),
            ),
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 22, color: AppColor.colorblFF),
            label: Text(AppString.editProfile),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final int number;
  final String label;
  const _Stat({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(number.toString(), style: AppTextStyle.bold16(AppColor.colorb26)),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyle.regular13(AppColor.colorgr88),
        ),
      ],
    );
  }
}
