import 'package:equatable/equatable.dart';
import '../../../models/lead_model.dart';

abstract class LeadDetailState extends Equatable {
  const LeadDetailState();

  @override
  List<Object?> get props => [];
}

class LeadDetailInitial extends LeadDetailState {}
class LeadDetailLoading extends LeadDetailState {}
class LeadDetailLoaded extends LeadDetailState {
  final LeadModel lead;
  const LeadDetailLoaded(this.lead);

  @override
  List<Object?> get props => [lead];
}
class LeadDetailError extends LeadDetailState {
  final String message;
  const LeadDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
class NoteAdded extends LeadDetailState {}
