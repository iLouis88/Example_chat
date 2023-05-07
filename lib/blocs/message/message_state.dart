part of 'message_bloc.dart';

enum MessageStatus {
  initial,
  loading,
  success,
  failure,
  imageLoading,
  imageSuccess,
  imageFailure
}

class MessageState extends Equatable {
  final MessageStatus status;
  final List<MessageModel> listMessage;
  const MessageState({required this.status, required this.listMessage});

  @override
  List<Object> get props => [status, listMessage];
}

// class MessageInitial extends MessageState {}

// class MessageLoading extends MessageState {}

// class MessageSendingMessage extends MessageState {}

// class MessageSentImageMessage extends MessageState {}

// class MessageLoadMessageSuccessed extends MessageState {
//   final List<MessageModel> listMessage;

//   const MessageLoadMessageSuccessed({required this.listMessage});
//   @override
//   List<Object> get props => [listMessage];
// }

// class MessageError extends MessageState {
//   final String error;
//   const MessageError({required this.error});
//   @override
//   List<Object> get props => [error];
// }
