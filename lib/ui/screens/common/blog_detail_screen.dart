// Developed By Muhammad Waleed.. Senior Android and Flutter developer..
// waleedkalyar48@gmail.com/

import 'package:flutter/material.dart';
import 'package:horti_vige/data/models/blog/blog_model.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/core/utils/app_consts.dart';
import 'package:horti_vige/core/utils/app_date_utils.dart';

class BlogDetailScreen extends StatelessWidget {
  const BlogDetailScreen({super.key});
  static const routeName = 'BlogDetail';

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final blog = arguments[Constants.blogModel] as BlogModel;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Image.network(
                blog.imageUrl,
                height: 300,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              left: 8,
              top: 2,
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                elevation: 1,
                constraints: const BoxConstraints(
                  minWidth: 26,
                  minHeight: 26,
                  maxWidth: 26,
                  maxHeight: 26,
                ),
                fillColor: Colors.white,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 270,
              bottom: 0,
              child: Container(
                padding: 16.allPadding,
                decoration: const BoxDecoration(
                  color: AppColors.colorWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.title,
                      style: AppTextStyles.titleStyle.changeSize(14),
                    ),
                    2.height,
                    Text(
                      AppDateUtils.getTimeAgoFromMilliseconds(blog.time),
                      style: AppTextStyles.bodyStyle.changeSize(9),
                    ),
                    12.height,
                    Text(
                      blog.description,
                      style: AppTextStyles.bodyStyle
                          .changeSize(11)
                          .changeColor(AppColors.colorGray),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
