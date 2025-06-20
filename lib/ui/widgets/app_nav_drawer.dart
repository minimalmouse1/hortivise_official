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
  static const deleteAccount =
      MenuItem(title: 'Delete Account', icon: Icons.delete_forever);
  static const all = <MenuItem>[home, chat, profile, logOut, deleteAccount];
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
      case MenuItems.logOut:
        return const LoginScreen();
      case MenuItems.deleteAccount:
        return currentUser.type == UserType.CUSTOMER
            ? const UserMainScreen()
            : const ConsultantMainScreen();
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
          ...MenuItems.all.map((item) => _buildMenuItem(item, context)),
          // if (user?.specialist != null) _buildChatTile(context),
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
    final isDeleteAccount = item == MenuItems.deleteAccount;

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ListTile(
        selected: isSelected,
        selectedTileColor: isDeleteAccount
            ? AppColors.colorRed.withOpacity(0.1)
            : AppColors.colorGreen, // Background color for selected tile
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(
          item.icon,
          color: isSelected
              ? (isDeleteAccount ? AppColors.colorRed : Colors.white)
              : (isDeleteAccount ? AppColors.colorRed : AppColors.colorGray),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: isSelected
                ? (isDeleteAccount ? AppColors.colorRed : Colors.white)
                : (isDeleteAccount ? AppColors.colorRed : AppColors.colorGray),
          ),
        ),
        onTap: () {
          // Handle logout functionality
          if (item == MenuItems.logOut) {
            _handleLogout(context);
          } else if (item == MenuItems.deleteAccount) {
            _handleDeleteAccount(context);
          } else {
            // Close the Zoom Drawer and navigate to the selected screen
            //ZoomDrawer.of(context)?.close();
            onSelectItem(
                item); // Trigger the callback to update the main screen
          }
        },
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    try {
      // Show confirmation bottom sheet
      final shouldLogout = await showModalBottomSheet<bool>(
        context: context,
        backgroundColor: AppColors.colorBeige,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure you want to logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _logoutButton(
                      label: 'Cancel',
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      buttonColor: AppColors.colorGreen,
                    ),
                    _logoutButton(
                      label: 'Logout',
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      buttonColor: AppColors.colorGreen.withOpacity(0.6),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );

      if (shouldLogout == true) {
        // Show loading indicator
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorGreen),
              ),
            ),
          );
        }

        // Perform logout
        await AuthService().signOut();

        // Clear user data from provider
        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false).clearUser();
        }

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
              content: Text('Logged out successfully'),
              backgroundColor: AppColors.colorGreen,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Remove loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to logout: ${e.toString()}'),
            backgroundColor: AppColors.colorRed,
          ),
        );
      }
    }
  }

  Widget _logoutButton({
    required String label,
    required Function() onTap,
    required Color buttonColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        width: 100,
        height: 40,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyStyle
              .changeColor(AppColors.colorWhite)
              .changeSize(15)
              .changeFontWeight(FontWeight.w700),
        ),
      ),
    );
  }

  void _handleDeleteAccount(BuildContext context) async {
    try {
      // Show confirmation bottom sheet
      final password = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: AppColors.colorBeige,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return _showDeleteAccountConfirmation(context);
        },
      );

      if (password != null && password.isNotEmpty) {
        // Show loading indicator
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorGreen),
              ),
            ),
          );
        }

        // Perform account deletion
        final success = await AuthService().deleteAccount(password);

        if (success) {
          // Clear user data from provider
          if (context.mounted) {
            Provider.of<UserProvider>(context, listen: false).clearUser();
          }

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
                backgroundColor: AppColors.colorGreen,
              ),
            );
          }
        } else {
          if (context.mounted) {
            Navigator.pop(context); // Remove loading indicator
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to delete account. Please try again.'),
                backgroundColor: AppColors.colorRed,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Remove loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: ${e.toString()}'),
            backgroundColor: AppColors.colorRed,
          ),
        );
      }
    }
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
      child: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Delete Account',
              style: TextStyle(
                color: AppColors.colorBlack,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please enter your password to confirm account deletion. This action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.colorBlack,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
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
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.colorGray,
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
                _deleteAccountButton(
                  label: 'Cancel',
                  onTap: () {
                    Navigator.of(context).pop(null);
                  },
                  buttonColor: AppColors.colorGreen,
                ),
                _deleteAccountButton(
                  label: 'Delete',
                  onTap: () {
                    if (passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your password'),
                          backgroundColor: AppColors.colorRed,
                        ),
                      );
                      return;
                    }
                    Navigator.of(context).pop(passwordController.text);
                  },
                  buttonColor: AppColors.colorRed,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _deleteAccountButton({
    required String label,
    required Function() onTap,
    required Color buttonColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        width: 100,
        height: 40,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyStyle
              .changeColor(AppColors.colorWhite)
              .changeSize(15)
              .changeFontWeight(FontWeight.w700),
        ),
      ),
    );
  }
}
