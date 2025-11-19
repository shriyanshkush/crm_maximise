import '../../models/agent_performance_model.dart';
import '../../models/campaign_model.dart';
import '../../models/lead_quality_model.dart';
import '../../models/lead_sources_model.dart';
import '../../models/daily_generation_model.dart';
import '../../models/integrations_status_model.dart';
import '../../models/revenue_growth_model.dart';

abstract class DashboardRepository {
  Future<LeadQualityResponse> getLeadQuality();
  Future<LeadSourcesResponse> getLeadSources();
  Future<LeadAnalysisResponse> getDailyLeadGeneration(String view);
  Future<IntegrationsStatusResponse> getIntegrationsStatus(String orgId);
  Future<Map<String, dynamic>> getTopPerformers();
  Future<AgentPerformanceResponse> getAgentPerformance();
  Future<CampaignResponse> getCampaignAnalytics();
  Future<RevenueGrowthResponse> getRevenueGrowth(String period);
}
