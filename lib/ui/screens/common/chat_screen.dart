// import 'package:flutter/material.dart';
// import 'package:horti_vige/providers/chat_provider.dart';
// import 'package:horti_vige/ui/items/item_chat.dart';
// import 'package:horti_vige/ui/screens/common/conversation_screen.dart';
// import 'package:horti_vige/ui/utils/colors/colors.dart';
// import 'package:horti_vige/ui/utils/extensions/extensions.dart';
// import 'package:horti_vige/ui/utils/styles/text_styles.dart';
// import 'package:horti_vige/ui/widgets/app_nav_drawer.dart';
// import 'package:horti_vige/ui/widgets/app_text_input.dart';
// import 'package:horti_vige/core/utils/app_consts.dart';
// import 'package:provider/provider.dart';

// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});
//   static const routeName = 'chat';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.colorBeige,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pushReplacementNamed(context, ZoomDrawerScreen.routeName);
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             size: 20,
//           ),
//         ),
//         title: Text(
//           'Chat',
//           style: AppTextStyles.titleStyle
//               .changeSize(24)
//               .changeFontWeight(FontWeight.w500),
//         ),
//       ),
//       backgroundColor: AppColors.colorBeige,
//       body: Column(
//         children: [
//           12.height,
//           Padding(
//             padding: 6.horizontalPadding,
//             child: AppTextInput(
//               hint: 'Search',
//               floatHint: false,
//               onUpdateInput: (text) {},
//               fieldHeight: 20,
//               icon: const Icon(Icons.search),
//               borderRadius: 16,
//             ),
//           ),
//           Expanded(
//             child: Consumer<ChatProvider>(
//               builder: (_, provider, __) => StreamBuilder(
//                 stream: provider.streamAllInboxes(),
//                 builder: (ctx, snapshots) {
//                   switch (snapshots.connectionState) {
//                     default:
//                       if (snapshots.hasError) {
//                         return const Center(
//                           child: Text(
//                             'Something went wrong when connecting to server, please try again later!',
//                           ),
//                         );
//                       } else {
//                         if (snapshots.data == null) {
//                           return Container();
//                         }
//                         final inboxes = snapshots.data!;
//                         return ListView.separated(
//                           shrinkWrap: true,
//                           itemBuilder: (ctx, index) {
//                             return ItemChat(
//                               inbox: inboxes[index],
//                               currentUserId: provider.getCurrentUserId(),
//                               onChatClick: (user) {
//                                 Navigator.pushNamed(
//                                   context,
//                                   ConversationScreen.routeName,
//                                   arguments: {
//                                     Constants.userModel: user,
//                                   },
//                                 );
//                               },
//                             );
//                           },
//                           separatorBuilder: (ctx, index) {
//                             return const Divider(
//                               height: 1.5,
//                               color: AppColors.colorWhite,
//                             );
//                           },
//                           itemCount: inboxes.length,
//                         );
//                       }
//                   }
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
