part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatLoadLastMessageEvent extends ChatEvent {
  final List<MessageModel> listLastMessages;
  const ChatLoadLastMessageEvent({required this.listLastMessages});
  @override
  List<Object> get props => [listLastMessages];
}

class ChatLoadChatUsersEvent extends ChatEvent {
  final List<ChatUserModel> listChatUser;

  const ChatLoadChatUsersEvent({required this.listChatUser});
  @override
  List<Object> get props => [listChatUser];
}

class ChatAddChatUserEvent extends ChatEvent {
  final String checkId;

  const ChatAddChatUserEvent({required this.checkId});
  @override
  List<Object> get props => [checkId];
}

class ChatDeleteChatUserEvent extends ChatEvent {
  final String id;
  const ChatDeleteChatUserEvent({required this.id});

  @override
  List<Object> get props => [id];
}
