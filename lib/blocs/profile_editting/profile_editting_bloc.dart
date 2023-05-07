import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/repositories/profile_editting_repo.dart';

import '../../models/chat_user.dart';

part 'profile_editting_event.dart';
part 'profile_editting_state.dart';

class ProfileEdittingBloc
    extends Bloc<ProfileEdittingEvent, ProfileEdittingState> {
  ProfileEdittingRepository profileEdittingRepository;

  ProfileEdittingBloc({required this.profileEdittingRepository})
      : super(ProfileEdittingInit()) {
    on<ProfileEdittingGetCurrentUserEvent>(_getCurrentUser);
    on<ProfileEdittingUpdateAvatarEvent>(_updateAvatar);
    on<ProfileEdittingUpdateProfileEvent>(_updateProfile);
  }

  Future<void> _getCurrentUser(ProfileEdittingGetCurrentUserEvent event,
      Emitter<ProfileEdittingState> emit) async {
    emit(ProfileEdittingLoading());
    try {
      var user = await profileEdittingRepository.getCurrentUser();
      emit(ProfileEdittingGetCurrentUserSuccessed(currentUser: user!));
    } catch (e) {
      emit(ProfileEdittingError(error: e.toString()));
    }
  }

  Future<void> _updateAvatar(ProfileEdittingUpdateAvatarEvent event,
      Emitter<ProfileEdittingState> emit) async {
    emit(ProfileEdittingLoading());
    try {
      await profileEdittingRepository.updateAvatar(event.file);
    } catch (e) {
      emit(ProfileEdittingError(error: e.toString()));
    }
  }

  Future<void> _updateProfile(ProfileEdittingUpdateProfileEvent event,
      Emitter<ProfileEdittingState> emit) async {
    emit(ProfileEdittingLoading());
    try {
      await profileEdittingRepository.updateProfile(
          about: event.about,
          email: event.email,
          name: event.name,
          phoneNumber: event.phoneNumber);
      emit(ProfileEdittingUpdatedProfile());
    } catch (e) {
      emit(ProfileEdittingError(error: e.toString()));
    }
  }
}
