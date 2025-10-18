import 'package:event_planning_app/core/utils/model/user_model.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:flutter/material.dart';

class ProfileAbout extends StatefulWidget {
  final UserModel user;
  final Size size;
  const ProfileAbout({super.key, required this.user, required this.size});

  @override
  State<ProfileAbout> createState() => _ProfileAboutState();
}

class _ProfileAboutState extends State<ProfileAbout> {
  static const int _maxChars = 150;
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final about = widget.user.about.trim();
    final hasAbout = about.isNotEmpty;
    final needsTruncate = hasAbout && about.length > _maxChars;
    final visibleText = !_expanded && needsTruncate
        ? about.substring(0, _maxChars).trimRight()
        : about;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppString.aboutMe, style: AppTextStyle.bold20(AppColor.colorb26)),
        SizedBox(height: 14),
        if (!hasAbout)
          Text(
            AppString.noAbout,
            style: AppTextStyle.regular15(AppColor.colorgr88),
          )
        else
          GestureDetector(
            onTap: needsTruncate ? _toggle : null,
            behavior: HitTestBehavior.translucent,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: visibleText,
                    style: AppTextStyle.regular15(AppColor.colorgr88),
                  ),
                  if (needsTruncate && !_expanded)
                    TextSpan(
                      text: '... ',
                      style: AppTextStyle.regular15(AppColor.colorgr88),
                    ),
                  if (needsTruncate)
                    TextSpan(
                      text: _expanded ? AppString.readLess : AppString.readMore,
                      style: AppTextStyle.bold15(AppColor.colorblFF),
                    ),
                  if (needsTruncate)
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Transform.rotate(
                        angle: _expanded ? 3.1416 : 0.0,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: widget.size.height * 0.02,
                          color: AppColor.colorblFF,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
