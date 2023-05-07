import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:savia/blocs/message/message_bloc.dart';
import 'package:savia/constant/dialog_constant.dart';
import 'package:savia/constant/image_constant.dart';
import 'package:savia/models/chat_user.dart';
import 'package:savia/models/message.dart';
import 'package:savia/widget/custom_text_form_field.dart';

class BuildMessageInput extends StatefulWidget {
  final TextEditingController messageController;
  final ChatUserModel currentUser;
  final ChatUserModel guestUser;
  final List<MessageModel> listMessage;
  const BuildMessageInput(
      {super.key,
      required this.messageController,
      required this.currentUser,
      required this.guestUser,
      required this.listMessage});

  @override
  State<BuildMessageInput> createState() => _BuildMessageInputState();
}

class _BuildMessageInputState extends State<BuildMessageInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            _getImageFromDeviceNoti(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Lottie.asset(ImageConstant.gallery,
                  fit: BoxFit.cover, width: 55, height: 55),
            ),
          ),
        ),
        Expanded(
          child: CustomTextFormField(
              controller: widget.messageController,
              keyboardType: TextInputType.multiline,
              hintText: ''),
        ),
        InkWell(
          onTap: () {
            if (widget.messageController.text.isNotEmpty) {
              (widget.listMessage.isEmpty)
                  ? _sendFirstMessage(
                      currentUser: widget.currentUser,
                      guestUser: widget.guestUser,
                      msg: widget.messageController.text.trim(),
                      type: Type.text)
                  : _sendMessage(
                      currentUser: widget.currentUser,
                      guestUser: widget.guestUser,
                      msg: widget.messageController.text.trim(),
                      type: Type.text);
            }
            widget.messageController.text = '';
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Lottie.asset(ImageConstant.send,
                fit: BoxFit.cover, width: 55, height: 55),
          ),
        ),
      ],
    );
  }

  void _getImageFromDeviceNoti(BuildContext context) {
    DialogConstant.showBothOkAndCancel(
        body: 'Select a photo in',
        cancelIcon: Icons.camera,
        cancelText: 'Camera',
        context: context,
        okIcon: Icons.image,
        okText: 'Gallery',
        okOnPress: () {
          _getImageFromGallery();
        },
        cancelOnPress: () {
          _getImageFromCamera();
        });
  }

  void _getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    _sendImageMessage(
        guestUser: widget.guestUser,
        currentUser: widget.currentUser,
        file: File(image!.path));
  }

  void _getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 100);
    for (var i in images) {
      _sendImageMessage(
          currentUser: widget.currentUser,
          guestUser: widget.guestUser,
          file: File(i.path));
    }
  }

  void _sendImageMessage(
      {required ChatUserModel guestUser,
      required ChatUserModel currentUser,
      required File file}) async {
    context.read<MessageBloc>().add(MessageSendImageMessageEvent(
        currentUser: currentUser, guestUser: guestUser, file: file));
  }

  void _sendFirstMessage(
      {required ChatUserModel guestUser,
      required ChatUserModel currentUser,
      required String msg,
      required Type type}) async {
    context
        .read<MessageBloc>()
        .add(MessageSendFirstMessageEvent(guestUser, currentUser, msg, type));
  }

  void _sendMessage(
      {required ChatUserModel guestUser,
      required ChatUserModel currentUser,
      required String msg,
      required Type type}) async {
    context
        .read<MessageBloc>()
        .add(MessageSendMessageEvent(guestUser, currentUser, msg, type));
  }
}
