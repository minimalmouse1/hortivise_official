import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

class ItemCalendarEvent extends StatelessWidget {
  const ItemCalendarEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(
          'https://lh3.googleusercontent.com/7K5BkEX8HqQShfGMFH3NuzAgOgIxdzBASWwsBW1FenQPy1cW5alzsLtQirKzLC4ces7_1GXnMNeOso6RYz1-A8hWPXZismqXm0pMl7UWH1ObjQlsZQ=w1440-v1-e30',
        ),
      ),
      title: const Text(
        'Meeting with Jane',
        style: AppTextStyles.bodyStyleMedium,
      ),
      subtitle: Text(
        'Introduction to plants',
        style: AppTextStyles.bodyStyle.changeSize(11),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '06:30 PM',
            style: AppTextStyles.bodyStyleMedium
                .changeSize(12)
                .changeColor(AppColors.colorGreen),
          ),
          Text(
            '30 Minutes',
            style: AppTextStyles.bodyStyle.changeSize(10),
          ),
        ],
      ),
    );
  }
}
