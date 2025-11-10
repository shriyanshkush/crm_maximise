import '../../models/lead_quality_model.dart';
import '../../models/lead_sources_model.dart';
import '../../models/daily_generation_model.dart';
import '../../models/integrations_status_model.dart';

abstract class DashboardRepository {
  Future<LeadQualityResponse> getLeadQuality();
  Future<LeadSourcesResponse> getLeadSources();
  Future<DailyGenerationResponse> getDailyLeadGeneration(String view);
  Future<IntegrationsStatusResponse> getIntegrationsStatus(String orgId);
  Future<Map<String, dynamic>> getTopPerformers();
}
