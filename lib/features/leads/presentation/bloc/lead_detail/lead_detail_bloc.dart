import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/leads_repository_impl.dart';
import 'lead_detail_event.dart';
import 'lead_detail_state.dart';

class LeadDetailBloc extends Bloc<LeadDetailEvent, LeadDetailState> {
  final LeadsRepositoryImpl repo;

  LeadDetailBloc(this.repo) : super(LeadDetailInitial()) {
    on<LoadLeadDetailEvent>(_onLoadLeadDetail);
    on<AddNoteEvent>(_onAddNote);
  }

  Future<void> _onLoadLeadDetail(
      LoadLeadDetailEvent event, Emitter<LeadDetailState> emit) async {
    emit(LeadDetailLoading());
    try {
      final lead = await repo.getLeadById(event.leadId);
      emit(LeadDetailLoaded(lead));
    } catch (e) {
      emit(LeadDetailError(e.toString()));
    }
  }

  Future<void> _onAddNote(
      AddNoteEvent event, Emitter<LeadDetailState> emit) async {
    try {
      // Step 1: Send note to server
      await repo.addNoteToLead(event.leadId, event.note);

      // Step 2: Immediately fetch updated lead details
      final updatedLead = await repo.getLeadById(event.leadId);

      // Step 3: Update UI
      emit(LeadDetailLoaded(updatedLead));

    } catch (e) {
      emit(LeadDetailError('Failed to add note: ${e.toString()}'));
    }
  }
}
