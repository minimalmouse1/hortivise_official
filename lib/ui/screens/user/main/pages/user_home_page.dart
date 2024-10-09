import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:horti_vige/core/utils/helpers/preference_manager.dart';
import 'package:horti_vige/data/enums/specialist_category.dart';
import 'package:horti_vige/providers/user_provider.dart';
import 'package:horti_vige/ui/items/item_consultant_home.dart';
import 'package:horti_vige/ui/screens/user/consultant_details_screen.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/core/utils/app_consts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({
    super.key,
  });

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Map<DateTime, List<dynamic>> _consultationDates = {};
  DateTime _focusedDay = DateTime.now();
  final currentUserId =
      PreferenceManager.getInstance().getCurrentUser()?.id ?? '';

  Future<void> _fetchConsultationDates() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Consultations')
        .where('customer.id', isEqualTo: currentUserId)
        .get();

    final Map<DateTime, List<dynamic>> consultationMap = {};

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final DateTime consultationDate = DateTime.parse(data['startTime']);

      final DateTime dateOnly = DateTime(
          consultationDate.year, consultationDate.month, consultationDate.day);

      // Add consultation date to the map
      if (consultationMap.containsKey(dateOnly)) {
        consultationMap[dateOnly]?.add(data);
      } else {
        consultationMap[dateOnly] = [data];
      }
    }

    setState(() {
      _consultationDates = consultationMap;
    });
    debugPrint('collection of dates:$_consultationDates');
  }

  @override
  void initState() {
    super.initState();
    _fetchConsultationDates();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> _getEventsForDay(DateTime day) {
      DateTime normalizedDay = DateTime(day.year, day.month, day.day);

      debugPrint(
          '_consultationDates[normalizedDay]:${_consultationDates[normalizedDay]}');

      return _consultationDates[normalizedDay] ?? [];
    }

    void _showCalendar(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ColoredBox(
            color: AppColors.colorBeige,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Small dot indicates the appointment date',
                    style: AppTextStyles.titleStyle.changeSize(16),
                  ),
                  TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay:
                        _focusedDay, // Default focus is today's date, but events are still highlighted
                    eventLoader: _getEventsForDay,
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: AppColors.colorGreen,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: AppColors.colorGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onDaySelected: (selectedDay, focusedDay) {},
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.colorBeige,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 6),
        child: AppBar(
          leading: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () => ZoomDrawer.of(context)?.toggle(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: userProvider.getCurrentUser() != null &&
                            userProvider
                                .getCurrentUser()!
                                .profileUrl
                                .startsWith('http')
                        ? NetworkImage(
                            userProvider.getCurrentUser()!.profileUrl,
                          )
                        : null,
                  ),
                ),
              );
            },
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              Text(
                'Welcome',
                style: AppTextStyles.bodyStyle
                    .changeFontWeight(FontWeight.w500)
                    .copyWith(
                      height: 0.3,
                    ),
              ),
              Text(
                userProvider.getCurrentUser()?.userName ?? '',
                style: AppTextStyles.titleStyle
                    .changeSize(16)
                    .changeFontWeight(FontWeight.w800)
                    .copyWith(
                      color: AppColors.colorBlack,
                    ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                _showCalendar(context);
              },
              icon: const Icon(
                Icons.calendar_month,
                color: AppColors.colorGreen,
              ),
            ),
            IconButton(
              onPressed: () {
                // Add search functionality here if needed
              },
              icon: const Icon(
                Icons.search,
                color: AppColors.colorGreen,
              ),
            )
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Add choice chips or other functionality if needed
          Expanded(
            child: Padding(
              padding: 12.allPadding,
              child: Consumer<UserProvider>(
                builder: (_, provider, __) => FutureBuilder(
                  future: provider.getAllSpecialistUsers(),
                  builder: (ctx, snapshots) {
                    switch (snapshots.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: AppColors.colorGreen,
                            backgroundColor: AppColors.colorGrayLight,
                          ),
                        );
                      default:
                        if (snapshots.hasError) {
                          return Center(
                            child: Text(
                              'Something went wrong when connecting to server, please try again later! ${snapshots.error}',
                            ),
                          );
                        } else {
                          final specialUsers = userProvider.getSpecialistsByCat(
                            catName: userProvider.getSelectedCat(),
                          );

                          return MasonryGridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            itemCount: specialUsers.length,
                            crossAxisSpacing: 8,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return ItemConsultantHome(
                                user: specialUsers[index],
                                imageHeight: index % 2 != 0 ? 180 : 280,
                                onConsultantClick: () {
                                  Navigator.pushNamed(
                                    context,
                                    ConsultantDetailsScreen.routeName,
                                    arguments: {
                                      Constants.userModel: specialUsers[index],
                                    },
                                  );
                                },
                              );
                            },
                          );
                        }
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
