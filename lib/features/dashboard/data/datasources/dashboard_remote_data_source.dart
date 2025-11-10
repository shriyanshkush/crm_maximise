import 'package:dio/dio.dart';
import '../../models/lead_quality_model.dart';
import '../../models/lead_sources_model.dart';
import '../../models/daily_generation_model.dart';
import '../../models/integrations_status_model.dart';

abstract class DashboardRemoteDataSource {
  Future<LeadQualityResponse> getLeadQuality();
  Future<LeadSourcesResponse> getLeadSources();
  Future<DailyGenerationResponse> getDailyLeadGeneration(String view);
  Future<IntegrationsStatusResponse> getIntegrationsStatus(String orgId);
  Future<Map<String, dynamic>> getTopPerformers();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;
  DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<LeadQualityResponse> getLeadQuality() async {
    try {
      final res = await dio.get('/leads/api/analytics/lead-quality');
      print('📨 [lead-quality] Response: ${res.data}');
      return LeadQualityResponse.fromJson(res.data);
    } on DioException catch (e) {
      print('❌ [lead-quality] DioError: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

  @override
  Future<LeadSourcesResponse> getLeadSources() async {
    try {
      final res = await dio.get('/leads/api/analytics/lead-sources');
      print('📨 [lead-sources] Response: ${res.data}');
      return LeadSourcesResponse.fromJson(res.data);
    } on DioException catch (e) {
      print('❌ [lead-sources] DioError: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

  @override
  Future<DailyGenerationResponse> getDailyLeadGeneration(String view) async {
    try {
      final res = await dio.get(
        '/leads/api/analytics/daily-lead-generation',
        queryParameters: {'view': view},
      );
      print('📨 [daily-lead-generation] Response: ${res.data}');
      return DailyGenerationResponse.fromJson(res.data);
    } on DioException catch (e) {
      print('❌ [daily-lead-generation] DioError: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

  @override
  Future<IntegrationsStatusResponse> getIntegrationsStatus(String orgId) async {
    try {
      final res = await dio.get(
        '/integrations/api/integrations/analytics/status',
        queryParameters: {'organizationId': orgId},
      );
      print('📨 [integrations-status] Response: ${res.data}');
      return IntegrationsStatusResponse.fromJson(res.data);
    } on DioException catch (e) {
      print('❌ [integrations-status] DioError: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getTopPerformers() async {
    try {
      final res = await dio.get('/auth/api/dashboard/top-performers');
      print('📨 [top-performers] Response: ${res.data}');
      return res.data;
    } on DioException catch (e) {
      print('❌ [top-performers] DioError: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }
}
