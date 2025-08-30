// ToDo:: Mostafa :: Do not Touch Please

// import 'package:flutter/material.dart';
// import 'package:to_do_app/core/function/app_route.dart';
// import 'package:to_do_app/core/function/app_svg_image.dart';
// import 'package:to_do_app/core/function/app_width_height.dart';
// import 'package:to_do_app/core/theme/app_text_style.dart';
// import 'package:to_do_app/core/utils/app_icon.dart';

// class CustomMyAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final Widget? trailing;

//   const CustomMyAppBar({
//     super.key,
//     required this.title,
//     this.trailing,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//             horizontal: AppWidthHeight.persantageOfWidth((12 / 375) * 100),
//             vertical: AppWidthHeight.persantageOfHeight((12 / 812) * 100)),
//         child: Row(
//           children: [
//             SizedBox(width: AppWidthHeight.persantageOfWidth((10 / 375) * 100)),
//             GestureDetector(
//               onTap: () => AppRoute.navigateBack(),
//               child: AppSvgImage.showSvgImage(
//                 path: AppIcon.tArrowappbar,
//               ),
//             ),
//             SizedBox(width: AppWidthHeight.persantageOfWidth((8 / 375) * 100)),
//             Text(
//               textScaler: TextScaler.linear(
//                 AppWidthHeight.persantageOfWidth((1 / 375) * 100),
//               ),
//               title,
//               style: AppTextStyle.regularB16,
//               overflow: TextOverflow.ellipsis,
//             ),
//             Spacer(),
//             SizedBox(
//                 width: AppWidthHeight.persantageOfWidth((100 / 375) * 100)),
//             if (trailing != null) trailing!,
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
