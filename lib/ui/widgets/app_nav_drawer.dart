import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:horti_vige/data/enums/user_type.dart';
import 'package:horti_vige/ui/widgets/exit_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:horti_vige/data/models/user/user_model.dart';
import 'package:horti_vige/data/services/stripe.dart';
import 'package:horti_vige/providers/user_provider.dart';
import 'package:horti_vige/ui/resources/app_icons_icons.dart';
import 'package:horti_vige/ui/screens/common/landing_screen.dart';
import 'package:horti_vige/ui/screens/common/profile_screen.dart';
import 'package:horti_vige/ui/screens/consultant/conversations.dart';
import 'package:horti_vige/ui/screens/consultant/main/consultant_main_screen.dart';
import 'package:horti_vige/ui/screens/user/main/user_main_screen.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

// Static menu items
class MenuItems {
  static const home = MenuItem(title: 'Home', icon: AppIcons.home_outlined);
  static const chat = MenuItem(title: 'Chat', icon: AppIcons.ic_chat_outlined);
  static const profile = MenuItem(title: 'Profile', icon: Icons.person_2);
  static const logOut = MenuItem(title: 'Logout', icon: Icons.logout);
  static const all = <MenuItem>[home, chat, profile, logOut];
}

class MenuItem {
  const MenuItem({required this.title, required this.icon});
  final String title;
  final IconData icon;
}

// Main ZoomDrawerScreen widget
class ZoomDrawerScreen extends StatefulWidget {
  const ZoomDrawerScreen({super.key});
  static const String routeName = 'UserMain';

  @override
  State<ZoomDrawerScreen> createState() => _ZoomDrawerScreenState();
}

class _ZoomDrawerScreenState extends State<ZoomDrawerScreen> {
  MenuItem currentItem = MenuItems.home;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).updateFCMToken();
    // NotificationService.askForNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<UserProvider>(context, listen: false).getCurrentUser());
    return ZoomDrawer(
      controller: ZoomDrawerController(),
      menuScreen: AppNavDrawer(
        user:
            Provider.of<UserProvider>(context, listen: false).getCurrentUser(),
        currentItem: currentItem,
        onSelectItem: (item) {
          setState(() {
            currentItem = item;
          });
          ZoomDrawer.of(context)?.close();
          if (item == MenuItems.logOut) _logOut(context);
        },
      ),
      mainScreen: Material(elevation: 2, child: _getScreen()),
      angle: 0,
      borderRadius: 0,
      menuBackgroundColor: AppColors.colorBeige,
    );
  }

  void _logOut(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).logoutUser().then((_) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LandingScreen.routeName,
        (route) => false,
      );
    });
  }

  Widget _getScreen() {
    final currentUser = context.read<UserProvider>().getCurrentUser();
    if (currentUser == null) return LandingScreen();

    switch (currentItem) {
      case MenuItems.home:
        return currentUser.type == UserType.CUSTOMER
            ? const UserMainScreen()
            : const ConsultantMainScreen();
      case MenuItems.chat:
        return const Conversations();
      case MenuItems.profile:
        return const ProfileScreen();
      default:
        return const UserMainScreen();
    }
  }
}

// AppNavDrawer widget for the drawer menu
class AppNavDrawer extends StatelessWidget {
  const AppNavDrawer({
    super.key,
    required this.currentItem,
    required this.onSelectItem,
    required this.user,
  });

  final MenuItem currentItem;
  final Function(MenuItem) onSelectItem;
  final UserModel? user;

 Future<bool> _onWillPop(BuildContext context) async {
    // Show confirmation dialog when the user tries to exit
    return (await showDialog(
          context: context,
          builder: (context) => const ExitBottomSheet()
        
        
        )) ??
        false; // Return false if dialog is dismissed
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      
      child: Scaffold(
        backgroundColor: AppColors.colorBeige,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            _buildUserInfo(),
            const SizedBox(height: 20),
            ...MenuItems.all.map((item) => _buildMenuItem(item)).toList(),
            if (user?.specialist != null) _buildChatTile(context),
            const Spacer(),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: (user?.profileUrl.isNotEmpty ?? false)
            ? NetworkImage(user!.profileUrl)
            : null,
      ),
      title: Text(
        user?.userName ?? 'N/A',
        style: AppTextStyles.titleStyle
            .changeColor(AppColors.colorGreen)
            .changeSize(18),
      ),
      subtitle: Text(
        user?.email ?? 'example@gmail.com',
        style: AppTextStyles.bodyStyle
            .changeColor(AppColors.colorGray)
            .changeSize(11),
      ),
      onTap: () => onSelectItem(MenuItems.profile),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ListTile(
        selected: currentItem == item,
        selectedTileColor: AppColors.colorWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(item.icon),
        title: Text(item.title),
        onTap: () => onSelectItem(item),
      ),
    );
  }

  Widget _buildChatTile(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Conversations())),
      leading: const Icon(Icons.message),
      title: const Text('Chats', style: AppTextStyles.bodyStyleMedium),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        if (user?.specialist != null) _buildStripeTile(),
        _buildLogoutTile(),
      ],
    );
  }

  Widget _buildStripeTile() {
    return ListTile(
      onTap: () async {
        final url = StripeController.instance.getAccountUrl();
        if (url != null && await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        }
      },
      leading: const Icon(Icons.attach_money_outlined),
      title: const Text('My Stripe', style: AppTextStyles.bodyStyleMedium),
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      onTap: () => onSelectItem(MenuItems.logOut),
      leading: const Icon(Icons.logout),
      title: const Text('Logout', style: AppTextStyles.bodyStyleMedium),
    );
  }
}
