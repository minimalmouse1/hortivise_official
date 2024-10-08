import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:horti_vige/data/enums/specialist_category.dart';
import 'package:horti_vige/providers/user_provider.dart';
import 'package:horti_vige/ui/items/item_consultant_home.dart';
import 'package:horti_vige/ui/screens/user/consultant_details_screen.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_horizontal_choise_chips.dart';
import 'package:horti_vige/core/utils/app_consts.dart';
import 'package:provider/provider.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          // TODO: Add actions
          actions: [
            IconButton(
              onPressed: () {
                // TODO: add navigation here
              },
              icon: const Icon(
                Icons.calendar_month,
                color: AppColors.colorGreen,
              ),
            ),
            IconButton(
              onPressed: () {
                // todo: add navigation here
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
          // Padding(
          //   padding: 12.horizontalPadding,
          //   child: AppHorizontalChoiceChips(
          //     chips: SpecialistCategory.values.map((e) => e.name).toList(),
          //     unSelectedLabelColor: const Color(0xff02010a).withOpacity(0.3),
          //     labelSize: 16,
          //     cornerRadius: 20,
          //     onSelected: (index) {
          //       userProvider.setCategory(
          //         SpecialistCategory.values.map((e) => e.name).toList()[index],
          //       );
          //     },
          //   ),
          // ),
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
