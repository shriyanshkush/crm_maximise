import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/leads_repository_impl.dart';
import 'leads_event.dart';
import 'leads_state.dart';

class LeadsBloc extends Bloc<LeadsEvent, LeadsState> {
  final LeadsRepositoryImpl repo;

  LeadsBloc(this.repo) : super(LeadsInitial()) {
    on<LoadLeadsEvent>(_onLoadLeads);
    on<CreateLeadEvent>(_onCreateLead);
    on<RefreshLeadsEvent>((e, emit) async {
      add(const LoadLeadsEvent());
    });
    on<ExportCsvEvent>(_onExportCsv);
  }

  Future<void> _onLoadLeads(LoadLeadsEvent event, Emitter<LeadsState> emit) async {
    emit(LeadsLoading());
    try {
      final res = await repo.getLeads(
        page: event.page,
        limit: event.limit,
        status: event.status,
        source: event.source,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(LeadsLoaded(leads: res.data, pagination: res.pagination, statistics: res.statistics));
    } catch (e) {
      print('❌ LeadsBloc Load Error: $e');
      emit(LeadsError(e.toString()));
    }
  }

  Future<void> _onCreateLead(CreateLeadEvent event, Emitter<LeadsState> emit) async {
    emit(LeadCreating());
    try {
      final lead = await repo.createLead(name: event.name, email: event.email, phone: event.phone, source: event.source);
      emit(LeadCreated(lead));
      // reload leads
      add(const LoadLeadsEvent());
    } catch (e) {
      print('❌ LeadsBloc Create Error: $e');
      emit(LeadsError(e.toString()));
    }
  }

  Future<void> _onExportCsv(ExportCsvEvent event, Emitter<LeadsState> emit) async {
    emit(LeadsLoading());
    try {
      final csv = await repo.exportCsv(startDate: event.startDate, endDate: event.endDate, status: event.status, source: event.source);
      emit(CsvExported(csv));
      // Optionally go back to loaded state
      add(const LoadLeadsEvent());
    } catch (e) {
      print('❌ LeadsBloc Export Error: $e');
      emit(LeadsError(e.toString()));
    }
  }
}
