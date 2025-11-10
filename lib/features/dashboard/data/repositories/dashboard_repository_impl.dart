import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';
import '../../models/lead_quality_model.dart';
import '../../models/lead_sources_model.dart';
import '../../models/daily_generation_model.dart';
import '../../models/integrations_status_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remote;
  DashboardRepositoryImpl(this.remote);

  @override
  Future<LeadQualityResponse> getLeadQuality() => remote.getLeadQuality();

  @override
  Future<LeadSourcesResponse> getLeadSources() => remote.getLeadSources();

  @override
  Future<DailyGenerationResponse> getDailyLeadGeneration(String view) =>
      remote.getDailyLeadGeneration(view);

  @override
  Future<IntegrationsStatusResponse> getIntegrationsStatus(String orgId) =>
      remote.getIntegrationsStatus(orgId);

  @override
  Future<Map<String, dynamic>> getTopPerformers() => remote.getTopPerformers();
}
