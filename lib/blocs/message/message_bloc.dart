import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/models/chat_user.dart';
import 'package:savia/models/message.dart';
import 'package:savia/repositories/message_repo.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageRepository messageRepository;
  StreamSubscription<List<MessageModel>>? _subscriptionMessage;
  MessageBloc({required this.messageRepository})
      : super(const MessageState(
            listMessage: [], status: MessageStatus.initial)) {
    ////
    on<MessageSendFirstMessageEvent>(_sendFirstMessage);
    on<MessageSendMessageEvent>(_sendMessage);
    on<MessageLoadMessageEvent>(_loadMessage);
    on<MessageSendImageMessageEvent>(_sendImageMessage);
    on<MessageDeleteMessageEvent>(_deleteMessage);

    // listen message from firebase
    _subscriptionMessage = messageRepository.streamMessage.listen((event) {
      add(MessageLoadMessageEvent(listMessage: event));
    });
  }

  // send image message
  Future<void> _sendImageMessage(
      MessageSendImageMessageEvent event, Emitter<MessageState> emit) async {
    try {
      emit(MessageState(
          status: MessageStatus.imageLoading, listMessage: state.listMessage));
      await messageRepository.sendImageMessage(
          guestUser: event.guestUser,
          currentUser: event.currentUser,
          file: event.file);

      emit(MessageState(
          status: MessageStatus.imageSuccess, listMessage: state.listMessage));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _deleteMessage(
      MessageDeleteMessageEvent event, Emitter<MessageState> emit) async {
    try {
      await messageRepository.deleteMessage(event.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  FutureOr<void> _loadMessage(
      MessageLoadMessageEvent event, Emitter<MessageState> emit) async {
    try {
      emit(const MessageState(status: MessageStatus.loading, listMessage: []));
      emit(MessageState(
          status: MessageStatus.success, listMessage: event.listMessage));
    } catch (e) {
      emit(MessageState(
          status: MessageStatus.failure, listMessage: event.listMessage));
    }
  }

  Future<void> _sendFirstMessage(
      MessageSendFirstMessageEvent event, Emitter<MessageState> emit) async {
    try {
      await messageRepository.sendFirstMessage(
          guestUser: event.guestUser,
          currentUser: event.currentUser,
          msg: event.msg,
          type: event.type);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _sendMessage(
      MessageSendMessageEvent event, Emitter<MessageState> emit) async {
    try {
      await messageRepository.sendMessage(
          guestUser: event.guestUser,
          currentUser: event.currentUser,
          msg: event.msg,
          type: event.type);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> close() {
    _subscriptionMessage?.cancel();
    messageRepository.close();
    return super.close();
  }
}
