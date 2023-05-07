import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:savia/constant/size_constant.dart';
import 'package:savia/constant/switch_screen_constant.dart';
import 'package:savia/lay_out/responsive_layout.dart';
import 'package:savia/models/chat_user.dart';
import 'package:savia/repositories/message_repo.dart';
import 'package:savia/view/message/message_page.dart';
import 'package:savia/view/profile/profile_page.dart';

class CustomChatCard extends StatelessWidget {
  final ChatUserModel guestUser;
  final ChatUserModel currentUser;
  final Widget? trailing;
  final Widget? subTitle;
  final bool isChatPage;
  final void Function(BuildContext)? onPressed;

  const CustomChatCard(
      {super.key,
      required this.guestUser,
      required this.currentUser,
      this.trailing,
      this.subTitle,
      required this.isChatPage,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              autoClose: true,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              onPressed: onPressed,
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: _card(context: context, size: size));
  }

  Widget _card({required BuildContext context, required Size size}) {
    return Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
            onTap: () {
              // get the id of guestUser
              // because conversationId need a guestUser's id
              // when listen using contructor i can't set the guestUser to contructor
              MessageRepository.conversationId = guestUser.id;

              isChatPage
                  ? SwitchScreenConstant.nextScreen(
                      context,
                      MessagePage(
                        currentUser: currentUser,
                        guestUser: guestUser,
                      ))
                  : () {};
            },
            child: ListTile(
              subtitle: subTitle,
              // show name of chat user
              title: Text(
                guestUser.name,
                style: const TextStyle(fontSize: 20),
                maxLines: 1,
              ),
              trailing: trailing,
              leading: InkWell(
                // show profile page of chat user
                onTap: () => showDialog(
                    context: context,
                    builder: (_) => ProfilePage(currentUser: guestUser)),

                // show avatar
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size.height * .05),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: context.sizeWidth(SizeConstant.widthHeightAvatar),
                    height: context.sizeWidth(SizeConstant.widthHeightAvatar),
                    imageUrl: guestUser.image!,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),
            )));
  }
}
