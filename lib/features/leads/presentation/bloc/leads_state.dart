import 'package:equatable/equatable.dart';
import '../../models/lead_model.dart';
import '../../models/leads_stats_model.dart';

abstract class LeadsState extends Equatable {
  const LeadsState();
  @override
  List<Object?> get props => [];
}

class LeadsInitial extends LeadsState {}

class LeadsLoading extends LeadsState {}

class LeadsLoaded extends LeadsState {
  final List<LeadModel> leads;
  final Map<String, dynamic> pagination;
  final Map<String, dynamic> statistics;

  const LeadsLoaded({required this.leads, required this.pagination, required this.statistics});
  @override
  List<Object?> get props => [leads, pagination, statistics];
}

class LeadsError extends LeadsState {
  final String message;
  const LeadsError(this.message);
  @override
  List<Object?> get props => [message];
}

class LeadCreating extends LeadsState {}
class LeadCreated extends LeadsState {
  final LeadModel lead;
  const LeadCreated(this.lead);
  @override
  List<Object?> get props => [lead];
}

class CsvExported extends LeadsState {
  final String csvContent;
  const CsvExported(this.csvContent);
  @override
  List<Object?> get props => [csvContent];
}
