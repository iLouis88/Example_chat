import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/repositories/dashboard_repo.dart';
import 'package:savia/repositories/sign_up_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpRepository signUpRepository;
  DashboardRepository dashboardRepository;
  SignUpBloc(
      {required this.signUpRepository, required this.dashboardRepository})
      : super(UnSignedUp()) {
    on<SignUpWithEmailAndPasswordEvent>(_signUpWithEmailAndPassWord);
  }

  // sign Up with email and password
  Future<void> _signUpWithEmailAndPassWord(
      SignUpWithEmailAndPasswordEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      await signUpRepository.signUpWithEmailAndPassword(
          email: event.email, password: event.password);
      if (!(await dashboardRepository.checkUserExist())) {
        await dashboardRepository.createNewDataUser();
      }
      emit(SignedUp());
    } catch (e) {
      emit(SignUpError(error: e.toString()));
      emit(UnSignedUp());
    }
  }
}
