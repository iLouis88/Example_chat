part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoadChatUserSuccessed extends ChatState {
  final List<ChatUserModel> listChatUser;
  const ChatLoadChatUserSuccessed({required this.listChatUser});

  @override
  List<Object> get props => [listChatUser];
}

class ChatLoadLastMessageSuccessed extends ChatState {
  final List<MessageModel> listLastMessage;
  const ChatLoadLastMessageSuccessed({required this.listLastMessage});

  @override
  List<Object> get props => [listLastMessage];
}

class ChatError extends ChatState {
  final String error;

  const ChatError({required this.error});
  @override
  List<Object> get props => [error];
}
