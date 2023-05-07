part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardLoading extends DashboardState {}

class DashboardCreateNewDataUserSuccess extends DashboardState {}

class DashboardCreateNewDataUserFaild extends DashboardState {}

class DashboardError extends DashboardState {
  final String error;
  const DashboardError({required this.error});
  @override
  List<Object> get props => [error];
}

class DashboardGetCurrentUserSuccess extends DashboardState {
  final ChatUserModel currentUser;
  const DashboardGetCurrentUserSuccess({required this.currentUser});

  @override
  List<Object> get props => [currentUser];
}
