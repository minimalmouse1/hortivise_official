// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:horti_vige/ui/utils/styles/text_styles.dart';
// import 'package:horti_vige/ui/utils/colors/colors.dart';
//
// class AppVersionText extends StatelessWidget {
//   const AppVersionText({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<PackageInfo>(
//       future: PackageInfo.fromPlatform(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: Text(
//               'Version ${snapshot.data!.version}',
//               style: AppTextStyles.bodyStyle.copyWith(
//                 color: AppColors.colorGray,
//                 fontSize: 12,
//               ),
//             ),
//           );
//         }
//         return const SizedBox.shrink();
//       },
//     );
//   }
// }
