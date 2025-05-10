import 'package:flutter/material.dart';
import 'package:horti_vige/Services/consultant_side_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:horti_vige/core/utils/helpers/preference_manager.dart';
import 'package:horti_vige/data/enums/enums.dart';
import 'package:horti_vige/providers/notifications_provider.dart';
import 'package:horti_vige/ui/resources/app_icons_icons.dart';
import 'package:horti_vige/ui/screens/consultant/main/pages/consultant_home_page.dart';
import 'package:horti_vige/ui/screens/user/main/pages/my_wallet.dart';
import 'package:horti_vige/ui/screens/user/main/pages/user_blogs_page.dart';
import 'package:horti_vige/ui/screens/user/main/pages/user_consultants_page.dart';
import 'package:horti_vige/ui/screens/user/main/pages/user_notifications_page.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/exit_bottom_sheet.dart';
import 'package:provider/provider.dart';

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
    // MyWallet(),
    UserNotificationsPage(),
    UserBlogsPage(),
  ];

  int _index = 0;
  int _pendingConsultationsCount = 0;
  int _unreadNotificationsCount = 0;
  late Stream<QuerySnapshot> _consultationsStream;

  @override
  void initState() {
    super.initState();
    // ConsultantSideNotificationService().startConsultantSideService();
    _setupConsultationsStream();
    _setupNotificationsStream();
  }

  void _setupConsultationsStream() {
    final currentUserId =
        PreferenceManager.getInstance().getCurrentUser()?.id ?? '';

    _consultationsStream = FirebaseFirestore.instance
        .collection('Consultations')
        .where(
          Filter.or(
            Filter(
              FieldPath(const ['customer', 'id']),
              isEqualTo: currentUserId,
            ),
            Filter(
              FieldPath(const ['specialist', 'id']),
              isEqualTo: currentUserId,
            ),
          ),
        )
        .where('status', isEqualTo: ConsultationStatus.pending.name)
        .snapshots();

    _consultationsStream.listen((snapshot) {
      setState(() {
        _pendingConsultationsCount = snapshot.docs.length;
      });
    });
  }

  void _setupNotificationsStream() {
    final notificationsProvider =
        Provider.of<NotificationsProvider>(context, listen: false);
    notificationsProvider.streamUnreadNotificationsCount().listen((count) {
      setState(() {
        _unreadNotificationsCount = count;
      });
    });
  }

  @override
  void dispose() {
    //_pages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_index == 0) {
          showModalBottomSheet(
            context: context,
            backgroundColor: AppColors.colorBeige,
            builder: (context) {
              return const ExitBottomSheet();
            },
          );
        } else {
          setState(() {
            _index = 0;
          });
        }
        return false;
      },
      child: Scaffold(
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
            items: [
              const BottomNavigationBarItem(
                icon: Icon(AppIcons.home_outlined),
                activeIcon: Icon(AppIcons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(AppIcons.consultations_outlined),
                    if (_pendingConsultationsCount > 0)
                      Positioned(
                        right: 2,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            _pendingConsultationsCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                activeIcon: Stack(
                  children: [
                    const Icon(AppIcons.consultations_filled),
                    if (_pendingConsultationsCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            _pendingConsultationsCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Consultation',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(AppIcons.wallet_outlined),
              //   activeIcon: Icon(AppIcons.wallet_filled),
              //   label: 'Wallet',
              // ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(AppIcons.notifications_outlined),
                    if (_unreadNotificationsCount > 0)
                      Positioned(
                        right: 2,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            _unreadNotificationsCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                activeIcon: Stack(
                  children: [
                    const Icon(AppIcons.notificatins_filled),
                    if (_unreadNotificationsCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            _unreadNotificationsCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Notifications',
              ),
              const BottomNavigationBarItem(
                icon: Icon(AppIcons.blog_outlined),
                activeIcon: Icon(AppIcons.blog_filled),
                label: 'Blogs',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
