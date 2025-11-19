import 'package:crm_maximise/features/dashboard/models/daily_generation_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/safe_api_call.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../models/agent_performance_model.dart';
import '../../models/campaign_model.dart';
import '../../models/integrations_status_model.dart';
import '../../models/lead_quality_model.dart';
import '../../models/lead_sources_model.dart';
import '../../models/revenue_growth_model.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepositoryImpl repo;

  DashboardBloc(this.repo) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<LoadRevenueGrowthEvent>(_onLoadRevenueGrowth);
  }

  // ---------------------------------------------------------
  // 1️⃣ Load Full Dashboard (called on dashboard start)
  // ---------------------------------------------------------
  Future<void> _onLoadDashboard(
      LoadDashboardEvent event,
      Emitter<DashboardState> emit,
      ) async {
    emit(DashboardLoading());

    try {
      final result = await Future.wait([
        safeCall(() => repo.getLeadQuality(), LeadQualityResponse.empty()),
        safeCall(() => repo.getLeadSources(), LeadSourcesResponse.empty()),
        safeCall(() => repo.getDailyLeadGeneration(event.view), LeadAnalysisResponse.empty()),
        safeCall(() => repo.getIntegrationsStatus(event.organizationId), IntegrationsStatusResponse.empty()),
        safeCall(() => repo.getTopPerformers(), <String, dynamic>{}),
        safeCall(() => repo.getAgentPerformance(), AgentPerformanceResponse.empty()),
        safeCall(() => repo.getCampaignAnalytics(), CampaignResponse.empty()),
        safeCall(() => repo.getRevenueGrowth(event.view), RevenueGrowthResponse.empty()),
      ]);

      emit(DashboardLoaded(
        quality: result[0] as LeadQualityResponse,
        sources: result[1] as LeadSourcesResponse,
        daily: result[2] as LeadAnalysisResponse,
        integrations: result[3] as IntegrationsStatusResponse,
        topPerformers: result[4] as Map<String, dynamic>,
        performance: result[5] as AgentPerformanceResponse,
        campaigns: result[6] as CampaignResponse,
        revenueGrowth: result[7] as RevenueGrowthResponse,
      ));
    } catch (e) {
      emit(DashboardError("Failed to load dashboard"));
    }
  }


  // ---------------------------------------------------------
  // 3️⃣ Load Revenue Growth ONLY (weekly / monthly / yearly)
  // ---------------------------------------------------------
  Future<void> _onLoadRevenueGrowth(
      LoadRevenueGrowthEvent event,
      Emitter<DashboardState> emit,
      ) async {
    if (state is! DashboardLoaded) return;

    final current = state as DashboardLoaded;
    emit(DashboardLoading());

    try {
      final updatedGrowth = await repo.getRevenueGrowth(event.period);

      emit(
        DashboardLoaded(
          quality: current.quality,
          sources: current.sources,
          daily: current.daily,
          integrations: current.integrations,
          topPerformers: current.topPerformers,
          performance: current.performance,
          campaigns: current.campaigns,
          revenueGrowth: updatedGrowth,
        ),
      );
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
