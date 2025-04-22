// import 'package:flutter/material.dart';
// import 'package:horti_vige/ui/utils/colors/colors.dart';
// import 'package:horti_vige/ui/utils/styles/text_styles.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class TermsPrivacyText extends StatelessWidget {
//   const TermsPrivacyText({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: GestureDetector(
//         onTap: () async {
//           //const url = 'https://www.hortivige.com/privacy-policy/';
//           const url = 'https://hortivise.com/privacy-policy/';
//           if (await canLaunchUrl(Uri.parse(url))) {
//             await launchUrl(Uri.parse(url));
//           }
//         },
//         child: Text(
//           'Privacy Policy',
//           style: AppTextStyles.bodyStyle.copyWith(
//             color: AppColors.colorGreen,
//             decoration: TextDecoration.underline,
//           ),
//         ),
//       ),
//     );
//   }
// }
