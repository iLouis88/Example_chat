import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/repositories/dashboard_repo.dart';
import 'package:savia/repositories/sign_in_repository.dart';
part 'sign_in_event.dart';
part 'sign_in_state.dart';

//TODO: clean archi =>
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInRepository signInRepository;
  DashboardRepository dashboardRepository;

  SignInBloc(
      {required this.signInRepository, required this.dashboardRepository})
      : super(UnSignedIn()) {
    on<SignInWithEmailAndPasswordEvent>(_signInWithEmailAndPassWord);
    on<SignInWithGoogleEvent>(_signInWithGoogle);
    on<SignInResetPasswordEvent>(_resetPasswordEmail);
  }

  // sign In with email and password
  Future<void> _signInWithEmailAndPassWord(
      SignInWithEmailAndPasswordEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      await signInRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(SignedIn());
    } catch (e) {
      emit(SignInError(error: e.toString()));
      emit(UnSignedIn());
    }
  }

  // sign in with google
  Future<void> _signInWithGoogle(
      SignInWithGoogleEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      await signInRepository.signInWithGoogle();
      if (!(await dashboardRepository.checkUserExist())) {
        await dashboardRepository.createNewDataUser();
      }
      emit(SignedIn());
    } catch (e) {
      emit(SignInError(error: e.toString()));
      emit(UnSignedIn());
    }
  }

  // reset password for email account
  Future<void> _resetPasswordEmail(
      SignInResetPasswordEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      await signInRepository.resetPasswordWithGmailAndPassword(
          email: event.email);
    } catch (e) {
      emit(SignInError(error: e.toString()));
    } finally {
      emit(UnSignedIn());
    }
  }
}
