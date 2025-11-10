import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardEvent extends DashboardEvent {
  final String organizationId;
  final String view; // "weekly" or "monthly"

  const LoadDashboardEvent(this.organizationId, {this.view = "weekly"});

  @override
  List<Object?> get props => [organizationId, view];
}
