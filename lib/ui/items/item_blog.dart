import 'package:flutter/material.dart';
import 'package:horti_vige/data/models/blog/blog_model.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/core/utils/app_date_utils.dart';

class ItemBlog extends StatelessWidget {
  const ItemBlog({
    super.key,
    required this.onBlogClick,
    required this.blogModel,
  });
  final BlogModel blogModel;
  final Function(BlogModel blogModel) onBlogClick;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      elevation: 0,
      surfaceTintColor: AppColors.colorWhite,
      color: AppColors.colorWhite,
      child: InkWell(
        onTap: () {
          onBlogClick(blogModel);
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.network(
                blogModel.imageUrl,
                width: 150,
                height: 105,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Padding(
                padding: 5.allPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blogModel.title,
                      style: AppTextStyles.bodyStyleMedium
                          .changeSize(12)
                          .changeFontWeight(FontWeight.w500),
                    ),
                    Text(
                      blogModel.description,
                      maxLines: 2,
                      style: AppTextStyles.bodyStyleMedium
                          .changeSize(9)
                          .changeFontWeight(FontWeight.w300),
                    ),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage:
                                      NetworkImage(blogModel.senderProfileUrl),
                                ),
                              ),
                              TextSpan(
                                text: '  ',
                                style: AppTextStyles.titleStyle
                                    .changeSize(10)
                                    .changeColor(AppColors.appGrayMaterial),
                              ),
                              TextSpan(
                                text: blogModel.senderName,
                                style: AppTextStyles.titleStyle
                                    .changeSize(10)
                                    .changeColor(AppColors.appGrayMaterial),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          AppDateUtils.getTimeAgoFromMilliseconds(
                            blogModel.time,
                          ),
                          style: AppTextStyles.bodyStyle
                              .changeColor(AppColors.colorGrayLight)
                              .changeSize(9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      //   ListTile(
      //   contentPadding: 0.allPadding,
      //   leading: ClipRRect(
      //     borderRadius: BorderRadius.circular(2),
      //     child: Image.network(
      //       "https://media.cntraveler.com/photos/5ea9df878abbf81d02aeae0b/1:1/w_4016,h_4016,c_limit/Kawachi-Fuji-Garden-wisteria-GettyImages-684691336.jpg",
      //       width: 150,
      //       fit: BoxFit.fill,
      //       height: 200,
      //     ),
      //   ),
      //   title: Column(children: [
      //     Text("Why do humans love flowers?",
      //       style: AppTextStyles.bodyStyleMedium.changeSize(12).changeFontWeight(
      //           FontWeight.w500),),
      //     Text(
      //       "Lorem ipsem dolor sit amet, consetetus sadipscing eltir, sed diam nounrmy wola krat grta s...",
      //       style: AppTextStyles.bodyStyleMedium.changeSize(10).changeFontWeight(
      //           FontWeight.w300),),
      //
      //   ],),
    );
  }
}
