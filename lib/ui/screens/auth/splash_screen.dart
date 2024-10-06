// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:horti_vige/data/enums/user_type.dart';
// import 'package:horti_vige/generated/assets.dart';
// import 'package:horti_vige/providers/user_provider.dart';
// import 'package:horti_vige/ui/screens/common/landing_screen.dart';
// import 'package:horti_vige/ui/screens/common/profile_screen.dart';
// import 'package:horti_vige/ui/screens/consultant/conversations.dart';
// import 'package:horti_vige/ui/screens/consultant/main/consultant_main_screen.dart';
// import 'package:horti_vige/ui/screens/user/main/pages/user_home_page.dart';
// import 'package:horti_vige/ui/screens/user/main/user_main_screen.dart';
// import 'package:horti_vige/ui/widgets/app_nav_drawer.dart';
// import 'package:provider/provider.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//   static String routeName = 'SplashScreen';

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//     MenuItem currentItem = MenuItems.home;

//   @override
//   void initState() {
//     super.initState();
//     _getScreen();
//   }

//   Widget _getScreen() {
//     final currentUser = context.read<UserProvider>().getCurrentUser();
//     if (currentUser == null) return  LandingScreen();
//     switch (currentItem) {
//       case MenuItems.home:
//         return currentUser.type == UserType.CUSTOMER
//             ? const UserMainScreen()
//             : const ConsultantMainScreen();
//       case MenuItems.chat:
//         return const Conversations();
//       case MenuItems.profile:
//         return const ProfileScreen();
//     }
//     return const UserMainScreen();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green, // Set the background color here

//       body: Container(
//         decoration: BoxDecoration(color: Colors.purple),
//         child: Center(
//           child: SvgPicture.asset(
//             Assets.assetsImagesLeftLeafs,
//             color: Colors.red,
//           ), // Your splash logo
//         ),
//       ),
//     );
//   }
// }
