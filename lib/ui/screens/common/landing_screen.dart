import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:horti_vige/generated/assets.dart';
import 'package:horti_vige/ui/screens/auth/animated_authenticated_landing.dart';
import 'package:horti_vige/ui/screens/auth/login_screen.dart';
import 'package:horti_vige/ui/widgets/app_nav_drawer.dart';
import 'package:horti_vige/ui/widgets/exit_bottom_sheet.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});
  static String routeName = 'Landing';

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  Future<User?> checkUserAuthState() async {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: checkUserAuthState(),
      builder: (context, snapshot) {
        // Show splash message until Firebase completes checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SvgPicture.asset(
              Assets.assetsImagesBottomLeafs,
              color: const Color.fromARGB(255, 5, 110, 8),
            ),
          );
        }

        // Once Firebase is done loading, navigate based on authentication state
        if (snapshot.hasData) {
          return const AnimatedLandingScreen(); // User is authenticated
        } else {
          return const LoginScreen(); // User is not authenticated
        }
      },
    );
  }
}
