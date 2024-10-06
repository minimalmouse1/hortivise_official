import 'package:flutter/material.dart';
import 'package:horti_vige/data/models/chat/chat_model.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/core/utils/app_date_utils.dart';

class ItemConversation extends StatelessWidget {
  const ItemConversation({
    super.key,
    required this.isMine,
    required this.chat,
  });
  final bool isMine;
  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment:
              isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          //this will determine if the message should be displayed left or right
          children: [
            Flexible(
              //Wrapping the container with flexible widget
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * .70,
                ),
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isMine ? AppColors.colorWhite : AppColors.colorGreen,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      //We only want to wrap the text message with flexible widget
                      child: Text(
                        chat.message,
                        style: AppTextStyles.bodyStyle
                            .changeColor(
                              isMine
                                  ? AppColors.colorBlack
                                  : AppColors.colorWhite,
                            )
                            .changeSize(14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(right: 12, left: 12, bottom: 12),
            child: Text(
              AppDateUtils.getTimeAgoFromMilliseconds(chat.time),
              style: AppTextStyles.bodyStyle
                  .changeColor(AppColors.colorGray)
                  .changeSize(9),
            ),
          ),
        ),
        5.height,
      ],
    );
  }
}
