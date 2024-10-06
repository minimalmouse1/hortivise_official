import 'package:flutter/material.dart';

import 'package:horti_vige/ui/resources/app_icons_icons.dart';
import 'package:horti_vige/ui/screens/consultant/main/pages/consultant_home_page.dart';
import 'package:horti_vige/ui/screens/user/main/pages/my_wallet.dart';
import 'package:horti_vige/ui/screens/user/main/pages/user_blogs_page.dart';
import 'package:horti_vige/ui/screens/user/main/pages/user_consultants_page.dart';
import 'package:horti_vige/ui/screens/user/main/pages/user_notifications_page.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

class ConsultantMainScreen extends StatefulWidget {
  const ConsultantMainScreen({super.key});
  static const String routeName = 'ConsultantMain';

  @override
  State<ConsultantMainScreen> createState() => _ConsultantMainScreenState();
}

class _ConsultantMainScreenState extends State<ConsultantMainScreen> {
  final _pages = const [
    ConsultantHomePage(),
    UserConsultantsPage(),
    MyWallet(),
    UserNotificationsPage(),
    UserBlogsPage(),
  ];

  int _index = 0;

  @override
  void dispose() {
    //_pages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBeige,
      body: _pages[_index],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _index = index;
            });
          },
          currentIndex: _index,
          selectedItemColor: AppColors.colorGreen,
          unselectedItemColor: AppColors.colorGray.withAlpha(80),
          showUnselectedLabels: true,
          showSelectedLabels: true,
          selectedIconTheme: const IconThemeData(size: 22),
          unselectedIconTheme: const IconThemeData(size: 22),
          selectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppTextStyles.bottomTabTextStyle,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(AppIcons.home_outlined),
              activeIcon: Icon(AppIcons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.consultations_outlined),
              activeIcon: Icon(AppIcons.consultations_filled),
              label: 'Consultation',
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.wallet_outlined),
              activeIcon: Icon(AppIcons.wallet_filled),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.notifications_outlined),
              activeIcon: Icon(AppIcons.notificatins_filled),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.blog_outlined),
              activeIcon: Icon(AppIcons.blog_filled),
              label: 'Blogs',
            ),
          ],
        ),
      ),
    );
  }
}
