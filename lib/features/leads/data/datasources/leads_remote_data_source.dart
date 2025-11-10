import 'package:dio/dio.dart';
import '../../models/leads_response_model.dart';
import '../../models/leads_stats_model.dart';
import '../../models/lead_model.dart';

abstract class LeadsRemoteDataSource {
  Future<LeadsResponse> getLeads({
    int page = 1,
    int limit = 20,
    String? status,
    String? source,
    String? startDate,
    String? endDate,
  });

  Future<LeadsStatsResponse> getStats({
    String? organizationId,
    String? status,
    String? source,
  });

  Future<LeadModel> createLead({
    required String name,
    required String email,
    required String phone,
    required String source,
  });

  Future<String> exportCsv({
    String? startDate,
    String? endDate,
    String? status,
    String? source,
  });
}

class LeadsRemoteDataSourceImpl implements LeadsRemoteDataSource {
  final Dio dio;
  LeadsRemoteDataSourceImpl(this.dio);

  @override
  Future<LeadsResponse> getLeads({
    int page = 1,
    int limit = 20,
    String? status,
    String? source,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final qp = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (status != null) qp['status'] = status;
      if (source != null) qp['source'] = source;
      if (startDate != null) qp['startDate'] = startDate;
      if (endDate != null) qp['endDate'] = endDate;

      print('📤 [leads] GET /leads/api/leads qp: $qp');

      final res = await dio.get('/leads/api/leads', queryParameters: qp);
      print('📨 [leads] Response: ${res.data}');
      return LeadsResponse.fromJson(res.data);
    } on DioException catch (e) {
      print('❌ [leads] DioError: ${e.response?.data ?? e.message}');
      rethrow;
    } catch (e) {
      print('❌ [leads] Error: $e');
      rethrow;
    }
  }

  @override
  Future<LeadsStatsResponse> getStats({
    String? organizationId,
    String? status,
    String? source,
  }) async {
    try {
      final qp = <String, dynamic>{};
      if (organizationId != null) qp['organizationId'] = organizationId;
      if (status != null) qp['status'] = status;
      if (source != null) qp['source'] = source;

      print('📤 [leads/stats] GET /leads/api/leads/stats qp: $qp');

      final res = await dio.get('/leads/api/leads/stats', queryParameters: qp);
      print('📨 [leads/stats] Response: ${res.data}');
      return LeadsStatsResponse.fromJson(res.data);
    } on DioException catch (e) {
      print('❌ [leads/stats] DioError: ${e.response?.data ?? e.message}');
      rethrow;
    } catch (e) {
      print('❌ [leads/stats] Error: $e');
      rethrow;
    }
  }

  @override
  Future<LeadModel> createLead({
    required String name,
    required String email,
    required String phone,
    required String source,
  }) async {
    try {
      final body = {
        'name': name,
        'email': email,
        'phone': phone,
        'source': source,
      };
      print('📤 [leads] POST /leads/api/leads body: $body');
      final res = await dio.post('/leads/api/leads', data: body);
      print('📨 [leads:create] Response: ${res.data}');
      return LeadModel.fromJson(res.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      print('❌ [leads:create] DioError: ${e.response?.data ?? e.message}');
      rethrow;
    } catch (e) {
      print('❌ [leads:create] Error: $e');
      rethrow;
    }
  }

  @override
  Future<String> exportCsv({
    String? startDate,
    String? endDate,
    String? status,
    String? source,
  }) async {
    try {
      final qp = <String, dynamic>{};
      if (startDate != null) qp['startDate'] = startDate;
      if (endDate != null) qp['endDate'] = endDate;
      if (status != null) qp['status'] = status;
      if (source != null) qp['source'] = source;

      print('📤 [leads/export] GET /leads/api/import-export/export-csv qp: $qp');

      final res = await dio.get('/leads/api/import-export/export-csv', queryParameters: qp,
          options: Options(responseType: ResponseType.plain)); // csv text
      print('📨 [leads/export] Response (csv length): ${res.data.toString().length}');
      return res.data.toString();
    } on DioException catch (e) {
      print('❌ [leads/export] DioError: ${e.response?.data ?? e.message}');
      rethrow;
    } catch (e) {
      print('❌ [leads/export] Error: $e');
      rethrow;
    }
  }
}
