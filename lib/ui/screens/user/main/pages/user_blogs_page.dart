import 'package:flutter/material.dart';
import 'package:horti_vige/providers/blogs_provider.dart';
import 'package:horti_vige/ui/items/item_blog.dart';
import 'package:horti_vige/ui/screens/common/blog_detail_screen.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/core/utils/app_consts.dart';
import 'package:provider/provider.dart';

class UserBlogsPage extends StatelessWidget {
  const UserBlogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBeige,
      appBar: AppBar(
        title: Text(
          'Blogs',
          style: AppTextStyles.titleStyle.changeSize(20),
        ),
        backgroundColor: AppColors.colorBeige,
        // TODO: add search
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.search,
        //       color: AppColors.colorGreen,
        //     ),
        //   ),
        // ],
      ),
      body: Padding(
        padding: 12.allPadding,
        child: Consumer<BlogsProvider>(
          builder: (_, provider, __) => FutureBuilder(
            future: provider.getAllBlogs(),
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
                    return const Center(
                      child: Text(
                        'Something went wrong when connecting to server, please try again later!',
                      ),
                    );
                  } else {
                    final blogs = snapshots.data!;
                    return ListView.separated(
                      itemBuilder: (ctx, index) {
                        return ItemBlog(
                          blogModel: blogs[index],
                          onBlogClick: (blog) {
                            Navigator.pushNamed(
                              context,
                              BlogDetailScreen.routeName,
                              arguments: {Constants.blogModel: blog},
                            );
                          },
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return 4.height;
                      },
                      itemCount: blogs.length,
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
