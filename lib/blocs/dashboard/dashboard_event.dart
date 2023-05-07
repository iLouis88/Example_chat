part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardGetCurrentUserEvent extends DashboardEvent {}

class DashboardUpdateUserStatusEvent extends DashboardEvent {
  final bool status;

  const DashboardUpdateUserStatusEvent({required this.status});

  @override
  List<Object> get props => [status];
}
