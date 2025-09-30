import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_radius.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/auth/data/user_model.dart';
import 'package:flutter/material.dart';

class ProfileInterests extends StatelessWidget {
  final UserModel user;
  final VoidCallback onChange;
  const ProfileInterests(
      {super.key, required this.user, required this.onChange});

  Color _colorFor(String interest) {
    final idx = (interest.toLowerCase().hashCode & 0x7FFFFFFF) %
        AppColor.colorsInterests.length;
    return AppColor.colorsInterests[idx];
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final interests = user.interests;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppString.interests,
              style: AppTextStyle.bold20(AppColor.colorb4D),
            ),
            const Spacer(),
            InkWell(
              onTap: onChange,
              borderRadius: AppRadius.profileChangeRadius,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColor.colorbl0FF,
                  borderRadius: AppRadius.profileChangeRadius,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, size: 18, color: AppColor.colorblFF),
                    SizedBox(width: 6),
                    Text(
                      AppString.change,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .5,
                        color: AppColor.colorblFF,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        user.interests.isNotEmpty
            ? Wrap(
                spacing: 14,
                runSpacing: 18,
                children: interests.map((t) {
                  final color = _colorFor(t);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: AppRadius.profileChipRadius,
                    ),
                    child: Text(
                      t,
                      style: const TextStyle(
                        color: AppColor.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .3,
                      ),
                    ),
                  );
                }).toList(),
              )
            : Text(AppString.noInterests),
      ],
    );
  }
}
