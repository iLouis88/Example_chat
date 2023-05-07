part of 'profile_editting_bloc.dart';

abstract class ProfileEdittingState extends Equatable {
  const ProfileEdittingState();

  @override
  List<Object> get props => [];
}

class ProfileEdittingGetCurrentUserSuccessed extends ProfileEdittingState {
  final ChatUserModel currentUser;

  const ProfileEdittingGetCurrentUserSuccessed({required this.currentUser});
  @override
  List<Object> get props => [currentUser];
}

class ProfileEdittingInit extends ProfileEdittingState {}

class ProfileEdittingLoading extends ProfileEdittingState {}

class ProfileEdittingError extends ProfileEdittingState {
  final String error;

  const ProfileEdittingError({required this.error});
  @override
  List<Object> get props => [error];
}

class ProfileEdittingUpdatedProfile extends ProfileEdittingState {}
