import 'package:flutter/material.dart';
import 'package:horti_vige/ui/resources/app_icons_icons.dart';
import 'package:horti_vige/ui/items/item_calendar_event.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_calendar_view.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});
  static const String routeName = 'Calendar';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.colorGreen,
        body: SingleChildScrollView(
          child: SizedBox(
            width: context.width,
            height: context.safeHeight,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Calendar',
                          style: AppTextStyles.bodyStyleMedium
                              .changeColor(AppColors.colorWhite)
                              .changeSize(22),
                        ),
                        RawMaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          elevation: 0.20,
                          constraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                            maxWidth: 24,
                            maxHeight: 24,
                          ),
                          fillColor: AppColors.colorWhite.withAlpha(90),
                          shape: const CircleBorder(),
                          child: const Icon(
                            AppIcons.ic_cross,
                            size: 10,
                            color: AppColors.colorWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  top: 35,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      height: 350,
                      child: AppCalendarView(
                        showHeader: true,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 420,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      color: AppColors.colorBeige,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'On this day',
                            style: AppTextStyles.titleStyle.changeSize(18),
                          ),
                          5.height,
                          ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return const ItemCalendarEvent();
                            },
                            separatorBuilder: (ctx, index) {
                              return const Divider();
                            },
                            itemCount: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
