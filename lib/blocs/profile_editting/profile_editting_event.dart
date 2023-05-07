part of 'profile_editting_bloc.dart';

abstract class ProfileEdittingEvent extends Equatable {
  const ProfileEdittingEvent();

  @override
  List<Object> get props => [];
}

class ProfileEdittingGetCurrentUserEvent extends ProfileEdittingEvent {}

class ProfileEdittingUpdateProfileEvent extends ProfileEdittingEvent {
  final String name;
  final String about;
  final String email;
  final String phoneNumber;

  const ProfileEdittingUpdateProfileEvent(
      {required this.name,
      required this.about,
      required this.email,
      required this.phoneNumber});
  @override
  List<Object> get props => [name, about, email, phoneNumber];
}

class ProfileEdittingUpdateAvatarEvent extends ProfileEdittingEvent {
  final File file;

  const ProfileEdittingUpdateAvatarEvent(this.file);
  @override
  List<Object> get props => [file];
}
