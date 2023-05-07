import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/models/chat_user.dart';
import 'package:savia/repositories/dashboard_repo.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardRepository dashboardRepository;
  DashboardBloc({required this.dashboardRepository})
      : super(DashboardLoading()) {
    on<DashboardGetCurrentUserEvent>(_getCurrentUser);
    on<DashboardUpdateUserStatusEvent>(_updateUserStatus);
  }

  Future<void> _updateUserStatus(DashboardUpdateUserStatusEvent event,
      Emitter<DashboardState> emit) async {
    try {
      await dashboardRepository.updateUserStatus(status: event.status);
    } catch (e) {
      emit(DashboardError(error: e.toString()));
    }
  }

  Future<void> _getCurrentUser(
      DashboardGetCurrentUserEvent event, Emitter<DashboardState> emit) async {
    // emit(DashboardLoading());
    try {
      var user = await dashboardRepository.getCurrentUser();
      emit(DashboardGetCurrentUserSuccess(currentUser: user!));
    } catch (e) {
      emit(DashboardError(error: e.toString()));
    }
  }
}
