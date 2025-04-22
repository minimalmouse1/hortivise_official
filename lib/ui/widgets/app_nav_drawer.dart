import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:horti_vige/data/enums/enums.dart';
import 'package:horti_vige/data/services/auth_service.dart';
import 'package:horti_vige/ui/screens/auth/login_screen.dart';
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
import 'package:horti_vige/ui/widgets/app_version_text.dart';

// Static menu items
class MenuItems {
  static const home = MenuItem(title: 'Home', icon: AppIcons.home_outlined);
  static const chat = MenuItem(title: 'Chat', icon: AppIcons.ic_chat_outlined);
  static const profile = MenuItem(title: 'Profile', icon: Icons.person_2);
  static const logOut = MenuItem(title: 'Logout', icon: Icons.logout);
  static const all = <MenuItem>[
    home,
    chat,
    profile,
  ];
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
  }

  @override
  Widget build(BuildContext context) {
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
          ZoomDrawer.of(context)?.close(); // Close the drawer after selection
        },
      ),
      mainScreen: Material(
        elevation: 2,
        child: _getScreen(), // Display the correct screen
      ),
      angle: 0,
      borderRadius: 0,
      menuBackgroundColor: AppColors.colorBeige,
    );
  }

  Widget _getScreen() {
    final currentUser = context.read<UserProvider>().getCurrentUser();
    if (currentUser == null) return const LandingScreen();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBeige,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          _buildUserInfo(),
          const SizedBox(height: 20),
          ...MenuItems.all
              .map((item) => _buildMenuItem(item, context))
              .toList(),
          // if (user?.specialist != null) _buildChatTile(context),
          const Spacer(),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    String formatUserName(String? userName) {
      if (userName == null || userName.isEmpty) return 'N/A';

      // Capitalize the first letter and add ellipsis if length > 6
      String formattedName = userName[0].toUpperCase() + userName.substring(1);
      return formattedName.length > 8
          ? '${formattedName.substring(0, 8)}...'
          : formattedName;
    }

    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: (user?.profileUrl.isNotEmpty ?? false)
            ? NetworkImage(user!.profileUrl)
            : null,
      ),
      title: Text(
        formatUserName(user?.userName),
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

  Widget _buildMenuItem(MenuItem item, context) {
    final isSelected = currentItem == item;

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ListTile(
        selected: isSelected,
        selectedTileColor:
            AppColors.colorGreen, // Background color for selected tile
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(
          item.icon,
          color: isSelected ? Colors.white : AppColors.colorGray,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.colorGray,
          ),
        ),
        onTap: () {
          // Close the Zoom Drawer and navigate to the selected screen
          ZoomDrawer.of(context)?.close();
          onSelectItem(item); // Trigger the callback to update the main screen
        },
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
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            children: [
              _buildDeleteAccountTile(context),
              _buildLogoutTile(context),
             // const AppVersionText(),
            ],
          ),
        ),
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

  Widget _buildDeleteAccountTile(BuildContext context) {
    return ListTile(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => _showDeleteAccountConfirmation(context),
      ),
      leading: const Icon(
        Icons.delete_forever,
        color: Colors.red,
      ),
      title: Text(
        'Delete Account',
        style: AppTextStyles.bodyStyleMedium.copyWith(
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _showDeleteAccountConfirmation(BuildContext context) {
    final passwordController = TextEditingController();
    bool isPasswordVisible = false;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Please enter your password to confirm account deletion. This action cannot be undone.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter your password'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      Navigator.pop(context);
                      _deleteAccount(context, passwordController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteAccount(BuildContext context, String password) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final authService = AuthService();

      // Show loading indicator
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Delete the user account with password
      final success = await authService.deleteAccount(password);

      if (success) {
        // Clear user data from provider
        userProvider.clearUser();

        // Close loading dialog and navigate to login screen
        if (context.mounted) {
          Navigator.pop(context); // Remove loading indicator

          // Navigate to login screen and remove all previous routes
          Navigator.of(context).pushNamedAndRemoveUntil(
            LoginScreen.routeName,
            (route) => false, // This will remove all previous routes
          );

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context); // Remove loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete account. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Remove loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildLogoutTile(context) {
    return ListTile(
      onTap: () {
        AuthService().signOut();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
      leading: const Icon(Icons.logout),
      title: const Text('Logout', style: AppTextStyles.bodyStyleMedium),
    );
  }
}
