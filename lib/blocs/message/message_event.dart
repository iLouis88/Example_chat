part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class MessageSendFirstMessageEvent extends MessageEvent {
  final ChatUserModel guestUser;
  final ChatUserModel currentUser;
  final String msg;
  final Type type;

  const MessageSendFirstMessageEvent(
      this.guestUser, this.currentUser, this.msg, this.type);
  @override
  List<Object> get props => [guestUser, currentUser, msg, type];
}

class MessageSendMessageEvent extends MessageEvent {
  final ChatUserModel guestUser;
  final ChatUserModel currentUser;
  final String msg;
  final Type type;

  const MessageSendMessageEvent(
      this.guestUser, this.currentUser, this.msg, this.type);
  @override
  List<Object> get props => [guestUser, currentUser, msg, type];
}

class MessageLoadMessageEvent extends MessageEvent {
  final List<MessageModel> listMessage;

  const MessageLoadMessageEvent({required this.listMessage});
}

class MessageSendImageMessageEvent extends MessageEvent {
  final ChatUserModel guestUser;
  final ChatUserModel currentUser;
  final File file;

  const MessageSendImageMessageEvent(
      {required this.currentUser, required this.guestUser, required this.file});
  @override
  List<Object> get props => [guestUser, currentUser, file];
}

class MessageDeleteMessageEvent extends MessageEvent {
  final MessageModel message;

  const MessageDeleteMessageEvent({required this.message});

  @override
  List<Object> get props => [message];
}
