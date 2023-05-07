import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:savia/blocs/chat/chat_bloc.dart';
import 'package:savia/models/chat_user.dart';
import 'package:savia/models/message.dart';
import 'package:savia/repositories/chat_repo.dart';
import 'package:savia/repositories/commu_chat_message_repo.dart';
import 'package:savia/view/chat/build_widgets/build_online_cirle.dart';
import 'package:savia/widget/build_loading_circle.dart';
import 'package:savia/widget/custom_chat_card.dart';
import 'package:savia/widget/custom_text_form_field.dart';

class ChatPage extends StatefulWidget {
  final ChatUserModel currentUser;
  const ChatPage({super.key, required this.currentUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUserModel>? _listChatUser;
  List<MessageModel>? _listMessage;
  final String _notiWhenNoChatuser = 'Search your friends ID and chat now 😍';
  //List<ChatUserModel>? _listOnlineChatUser;
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        floatingActionButton: _floatingButton(),
        body: BlocProvider(
          create: (context) => ChatBloc(chatRepository: ChatRepository()),
          child: BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {},
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                // listen the change of firebase to load chat user
                if (state is ChatLoadChatUserSuccessed) {
                  _listChatUser = state.listChatUser;

                  return (_listChatUser!.isEmpty)
                      ? Center(
                          child: Text(_notiWhenNoChatuser,
                              textAlign: TextAlign.center, maxLines: 2))
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: AnimationLimiter(
                            child: ListView.builder(
                                shrinkWrap: true,
                                reverse: true,
                                itemCount: _listChatUser!.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                      position: index,
                                      delay: const Duration(milliseconds: 100),
                                      child: SlideAnimation(
                                          duration: const Duration(
                                              milliseconds: 2500),
                                          curve: Curves.fastLinearToSlowEaseIn,
                                          child: FadeInAnimation(
                                              curve:
                                                  Curves.fastLinearToSlowEaseIn,
                                              duration: const Duration(
                                                  milliseconds: 2500),
                                              child: CustomChatCard(
                                                onPressed: (context) {
                                                  _deleteChatUser(
                                                      id: _listChatUser![index]
                                                          .id);
                                                },
                                                // online icon
                                                trailing: _listChatUser![index]
                                                        .isOnline
                                                    ? const BuildOnlineCircle()
                                                    : const Text(''),
                                                subTitle: Text(
                                                  _listChatUser![index].checkId,
                                                  maxLines: 1,
                                                ),
                                                isChatPage: true,
                                                guestUser:
                                                    _listChatUser![index],
                                                currentUser: widget.currentUser,
                                              ))));
                                }),
                          ),
                        );
                }
                return const Center(
                    child: BuildLoadingCircle(
                  height: 80,
                  width: 80,
                ));
              },
            ),
          ),
        ));
  }

  Widget _floatingButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FloatingActionButton(
          onPressed: () {
            _addChatUserDialog();
          },
          child: const Icon(Icons.add_comment_rounded, size: 30)),
    );
  }

  void _deleteChatUser({required String id}) async {
    AwesomeDialog(
      dialogType: DialogType.question,
      animType: AnimType.topSlide,
      headerAnimationLoop: true,
      body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Click Delete to delete this chat!')),
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.blue,
      btnOkText: 'Cencel',
      btnCancelText: 'Delete',
      btnCancelColor: const Color(0xFFFE4A49),
      btnCancelIcon: Icons.check,
      btnOkOnPress: () {},
      btnCancelOnPress: () async {
        context.read<ChatBloc>().add(ChatDeleteChatUserEvent(id: id));
      },
      context: context,
    ).show();
  }

  void _addChatUser({required BuildContext context, required String checkId}) {
    context.read<ChatBloc>().add(ChatAddChatUserEvent(checkId: checkId));
  }

  void _addChatUserDialog() {
    String input = '';

    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.topSlide,
      headerAnimationLoop: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomTextFormField(
          maxLines: 1,
          onChanged: (value) => input = value,
          controller: null,
          hintText: 'ID of the person looking for',
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.code_sharp, color: Colors.blue),
        ),
      ),
      btnOkIcon: Icons.check,
      btnOkColor: Colors.blue,
      btnOkOnPress: () async {
        if (input.isNotEmpty) {
          _addChatUser(checkId: input, context: context);
        }
      },
    ).show();
  }
}
