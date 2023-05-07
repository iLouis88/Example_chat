import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/models/chat_user.dart';
import 'package:savia/models/message.dart';
import 'package:savia/repositories/chat_repo.dart';
import 'package:savia/repositories/commu_chat_message_repo.dart';
import 'package:savia/repositories/message_repo.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatRepository chatRepository;
  // CommunicationChatMessageRepository communicationChatMessageRepository;
  StreamSubscription<List<ChatUserModel>>? _subscriptionChatUsers;
  // StreamSubscription<List<MessageModel>>? _subscriptionLastMessages;

  ChatBloc({
    required this.chatRepository,
  }) : super(ChatLoading()) {
    on<ChatLoadChatUsersEvent>(_loadChatUser);
    on<ChatLoadLastMessageEvent>(_loadLastMessage);
    on<ChatAddChatUserEvent>(_addChatUser);
    on<ChatDeleteChatUserEvent>(_deleteChatUser);

    // listen changes on firebase to add event
    _subscriptionChatUsers = chatRepository.streamChatUsers.listen((event) {
      add(ChatLoadChatUsersEvent(listChatUser: event));
    });
    // _subscriptionLastMessages = communicationChatMessageRepository.streamLastMessage.listen((event) {
    //   add(ChatLoadLastMessageEvent(listLastMessages: event));
    // });
  }

  Future<void> _loadLastMessage(
      ChatLoadLastMessageEvent event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoadLastMessageSuccessed(
          listLastMessage: event.listLastMessages));
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }

  FutureOr<void> _loadChatUser(
      ChatLoadChatUsersEvent event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoadChatUserSuccessed(listChatUser: event.listChatUser));
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }

  Future<void> _addChatUser(
      ChatAddChatUserEvent event, Emitter<ChatState> emit) async {
    try {
      await chatRepository.addChatUser(event.checkId);
      //result ? emit(ChatAddChatUserSuccessed()) : null;
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }

  Future<void> _deleteChatUser(
      ChatDeleteChatUserEvent event, Emitter<ChatState> emit) async {
    try {
      await chatRepository.deleteChatUser(id: event.id);
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscriptionChatUsers?.cancel();
    chatRepository.close();
    return super.close();
  }
}
