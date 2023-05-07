part of 'contact_bloc.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoadChatUserSuccessed extends ContactState {
  final List<ChatUserModel> listContactUser;
  const ContactLoadChatUserSuccessed({required this.listContactUser});

  @override
  List<Object> get props => [listContactUser];
}

class ContactError extends ContactState {
  final String error;

  const ContactError({required this.error});
  @override
  List<Object> get props => [error];
}
