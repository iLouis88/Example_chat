import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:savia/blocs/message/message_bloc.dart';
import 'package:savia/constant/color_constant.dart';
import 'package:savia/constant/image_constant.dart';
import 'package:savia/constant/switch_screen_constant.dart';
import 'package:savia/constant/text_style_constant.dart';
import 'package:savia/lay_out/responsive_layout.dart';
import 'package:savia/models/chat_user.dart';
import 'package:savia/models/message.dart';
import 'package:savia/repositories/message_repo.dart';
import 'package:savia/view/dashboard.dart';
import 'package:savia/view/message/widgets/build_message_input.dart';
import 'package:savia/view/profile/profile_page.dart';
import 'package:savia/view/call/video_call_page.dart';
import 'package:savia/widget/custom_message_box.dart';

class MessagePage extends StatefulWidget {
  final ChatUserModel guestUser;
  final ChatUserModel currentUser;

  const MessagePage(
      {super.key, required this.currentUser, required this.guestUser});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final _messageController = TextEditingController();
  List<MessageModel>? _listMessage;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: _appbar(size, context),
        body: BlocProvider(
          create: (context) =>
              MessageBloc(messageRepository: MessageRepository()),
          child: BlocListener<MessageBloc, MessageState>(
            listener: (context, state) {
              if (state.status == MessageStatus.loading) {
                const Center(child: CircularProgressIndicator());
              }
            },
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state.listMessage != []) {
                  _listMessage = state.listMessage;
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AnimationLimiter(
                            child: ListView.builder(
                                shrinkWrap: true,
                                reverse: true,
                                itemCount: _listMessage!.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  // list animation
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    delay: const Duration(milliseconds: 100),
                                    child: SlideAnimation(
                                      duration:
                                      const Duration(milliseconds: 2500),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: FadeInAnimation(
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        duration:
                                        const Duration(milliseconds: 2500),
                                        child: CustomMessageCard(
                                            messageModel: _listMessage![index],
                                            isCurrentUser: (widget
                                                .currentUser.id ==
                                                _listMessage![index].fromId)),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        // check process when send image
                        (state.status == MessageStatus.imageLoading)
                            ? Lottie.asset(ImageConstant.imageLoading,
                            width: 55, height: 55)
                            : Container(),
                        const SizedBox(height: 10),
                        // message input
                        BuildMessageInput(
                          currentUser: widget.currentUser,
                          guestUser: widget.guestUser,
                          listMessage: _listMessage!,
                          messageController: _messageController,
                        ),
                        const SizedBox(height: 10),
                      ]);
                } else {
                  return const Center(child: Text('Say hello ✌️'));
                }
              },
            ),
          ),
        ));
  }

  AppBar _appbar(Size size, BuildContext context) {
    return AppBar(
      actionsIconTheme: const IconThemeData(color: Colors.black, size: 40),
      toolbarHeight: 60,
      actions: [
        IconButton(
            onPressed: () async {
              SwitchScreenConstant.nextScreen(
                  context,
                  VideoCallPage(
                      guestUser: widget.guestUser,
                      currentUser: widget.currentUser,
                      isVideoCall: false));
            },
            icon: Icon(Icons.call,
                color: ColorConstant.currentMessage, size: 35)),
        IconButton(
            onPressed: () {
              SwitchScreenConstant.nextScreen(
                  context,
                  VideoCallPage(
                      guestUser: widget.guestUser,
                      currentUser: widget.currentUser,
                      isVideoCall: true));
            },
            icon: Icon(Icons.video_call_rounded,
                color: ColorConstant.currentMessage, size: 50)),
        const SizedBox(width: 10)
      ],
      leading: IconButton(
          onPressed: () {
            SwitchScreenConstant.nextScreenReplace(context, const DashBoard());
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 30, color: Colors.black)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      leadingWidth: 50,
      title: InkWell(
        onTap: () {
          SwitchScreenConstant.nextScreen(
              context, ProfilePage(currentUser: widget.guestUser));
        },
        child: Row(children: [
          Container(
            width: context.sizeWidth(45),
            height: context.sizeWidth(45),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.guestUser.image!,
                  errorWidget: (context, url, error) => CircleAvatar(
                      child:
                      Image(image: AssetImage(ImageConstant.cameraIcon)))),
            ),
          ),
          const SizedBox(width: 10),
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // name guest user
                Text(_getTheLastName(widget.guestUser.name),
                    style: TextStyleConstant.nameOfUserMessagePage),

                // online or offline status
                widget.guestUser.isOnline
                    ? Text(
                  'online',
                  style: TextStyle(
                      color: ColorConstant.onlineStatus, fontSize: 10),
                )
                    : Text(
                  'offline',
                  style: TextStyle(
                      color: ColorConstant.offlineStatus, fontSize: 10),
                ),
              ]),
        ]),
      ),
    );
  }

  String _getTheLastName(String fullName) {
    if (!fullName.contains(' ')) {
      return _getNameInLimit(fullName);
    } else {
      List<String> cacTu = fullName.split(' '); // Tách chuỗi thành các từ
      String lastName = cacTu.sublist(cacTu.length - 2).join(' ');
      return _getNameInLimit(lastName);
    }
  }

  String _getNameInLimit(String name) {
    if (name.length > 7) {
      return '${name.substring(0, 7)}...';
    } else {
      return name;
    }
  }
}

