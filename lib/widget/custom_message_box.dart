import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:savia/blocs/message/message_bloc.dart';
import 'package:savia/constant/color_constant.dart';
import 'package:savia/constant/my_date_util.dart';
import 'package:savia/constant/size_constant.dart';
import 'package:savia/constant/text_style_constant.dart';
import 'package:savia/lay_out/responsive_layout.dart';
import 'package:savia/models/message.dart';

class CustomMessageCard extends StatefulWidget {
  final MessageModel messageModel;
  final bool isCurrentUser;

  const CustomMessageCard(
      {super.key, required this.messageModel, required this.isCurrentUser});

  @override
  State<CustomMessageCard> createState() => _CustomMessageCardState();
}

class _CustomMessageCardState extends State<CustomMessageCard> {
  final double borderRadiusCard = SizeConstant.borderRadisOfMessageCard;
  bool _showTime = false;
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: widget.isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          _boxMessage(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadiusCard),
                topRight: Radius.circular(borderRadiusCard),
                bottomRight: widget.isCurrentUser
                    ? const Radius.circular(0)
                    : Radius.circular(borderRadiusCard),
                bottomLeft: widget.isCurrentUser
                    ? Radius.circular(borderRadiusCard)
                    : const Radius.circular(0)),
            color: widget.isCurrentUser
                ? ColorConstant.currentMessage
                : ColorConstant.guestMessage,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: widget.isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: widget.messageModel.type == Type.text
                      ? const EdgeInsets.all(10)
                      : const EdgeInsets.all(0),
                  child: GestureDetector(
                    onLongPress: () {
                      _holdOnMessage(message: widget.messageModel);
                    },
                    onTap: () {
                      widget.messageModel.type != Type.text
                          ? _showSecondPage(context)
                          : setState(() {
                              _showTime = !_showTime;
                            });
                    },
                    child: widget.messageModel.type == Type.text
                        ? Text(
                            widget.messageModel.msg,
                            style: widget.isCurrentUser
                                ? (context.smallDevice()
                                    ? TextStyleConstant.currentMessageSmall
                                    : TextStyleConstant.currentMessage)
                                : (context.smallDevice()
                                    ? TextStyleConstant.guestMessageSmall
                                    : TextStyleConstant.guestMessage),
                            textAlign: TextAlign.start,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: context.sizeWidth(250),
                              height: context.sizeHeight(250),
                              imageUrl: widget.messageModel.msg,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.image, size: 70),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          _showTime
              ? Padding(
                  padding: EdgeInsets.only(
                      left: !widget.isCurrentUser ? 10 : 0,
                      right: widget.isCurrentUser ? 10 : 0,
                      bottom: 5),
                  child: Text(
                    textAlign: TextAlign.start,
                    (widget.messageModel.msg.length > 3)
                        ? MyDateUtil.getFormattedTime(
                            context: context, time: widget.messageModel.sent)
                        : '  ${MyDateUtil.getFormattedTime(context: context, time: widget.messageModel.sent)}',
                    style: TextStyle(
                        fontSize: context.smallDevice() ? 15 : 12,
                        color: Colors.black),
                  ),
                )
              : const SizedBox(
                  height: 10,
                ),
          // context.sizedBox(height: context.sizeHeight(10))
        ]);
  }

  Future<void> _holdOnMessage({required MessageModel message}) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.topSlide,
      headerAnimationLoop: true,
      body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Consider your options! 🤔')),
      btnOkIcon: Icons.copy_all_outlined,
      btnOkColor: Colors.blue,
      btnOkText: 'Copy',
      btnCancelText: 'Delete',
      btnCancelColor: const Color(0xFFFE4A49),
      btnCancelIcon: Icons.delete_forever_outlined,
      btnOkOnPress: () async {
        await _copyMessage(message);
      },
      btnCancelOnPress: () async {
        _deleteMessage(message);
      },
    ).show();
  }

  Future<void> _copyMessage(MessageModel message) async {
    await Clipboard.setData(ClipboardData(text: message.msg)).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(milliseconds: 500),
            backgroundColor: Colors.white,
            content: Center(
                child: Text(
              'Message copied',
              style: TextStyle(color: Colors.black, fontSize: 15),
            )))));
  }

  void _deleteMessage(MessageModel message) {
    BlocProvider.of<MessageBloc>(context)
        .add(MessageDeleteMessageEvent(message: message));
  }

  void _showSecondPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 30, color: Colors.white)),
              backgroundColor: Colors.black,
              title: Text(MyDateUtil.getFormattedTime(
                  context: context, time: widget.messageModel.sent))),
          body: PhotoView(
            imageProvider: NetworkImage(widget.messageModel.msg),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          ),
        ),
      ),
    );
  }

  Widget _boxMessage(
      {required Color color,
      required Widget child,
      required BorderRadius borderRadius}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
