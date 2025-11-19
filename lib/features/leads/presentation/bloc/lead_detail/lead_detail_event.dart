import 'package:equatable/equatable.dart';

abstract class LeadDetailEvent extends Equatable {
  const LeadDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadLeadDetailEvent extends LeadDetailEvent {
  final String leadId;
  const LoadLeadDetailEvent(this.leadId);

  @override
  List<Object?> get props => [leadId];
}

class AddNoteEvent extends LeadDetailEvent {
  final String leadId;
  final String note;
  const AddNoteEvent(this.leadId, this.note);

  @override
  List<Object?> get props => [leadId, note];
}
