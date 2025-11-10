import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepositoryImpl repo;

  DashboardBloc(this.repo) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
      LoadDashboardEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final quality = await repo.getLeadQuality();
      final sources = await repo.getLeadSources();
      final daily = await repo.getDailyLeadGeneration(event.view);
      final integrations = await repo.getIntegrationsStatus(event.organizationId);
      final top = await repo.getTopPerformers();

      emit(DashboardLoaded(
        quality: quality,
        sources: sources,
        daily: daily,
        integrations: integrations,
        topPerformers: top,
      ));
    } catch (e) {
      print('❌ DashboardBloc Error: $e');
      emit(DashboardError(e.toString()));
    }
  }
}
