import '../../domain/repositories/leads_repository.dart';
import '../datasources/leads_remote_data_source.dart';
import '../../models/leads_response_model.dart';
import '../../models/leads_stats_model.dart';
import '../../models/lead_model.dart';

class LeadsRepositoryImpl implements LeadsRepository {
  final LeadsRemoteDataSource remote;
  LeadsRepositoryImpl(this.remote);

  @override
  Future<LeadsResponse> getLeads({int page = 1, int limit = 20, String? status, String? source, String? startDate, String? endDate}) =>
      remote.getLeads(page: page, limit: limit, status: status, source: source, startDate: startDate, endDate: endDate);

  @override
  Future<LeadsStatsResponse> getStats({String? organizationId, String? status, String? source}) =>
      remote.getStats(organizationId: organizationId, status: status, source: source);

  @override
  Future<LeadModel> createLead({required String name, required String email, required String phone, required String source}) =>
      remote.createLead(name: name, email: email, phone: phone, source: source);

  @override
  Future<String> exportCsv({String? startDate, String? endDate, String? status, String? source}) =>
      remote.exportCsv(startDate: startDate, endDate: endDate, status: status, source: source);

  @override
  Future<LeadModel> getLeadById(String id) => remote.getLeadById(id);

  @override
  Future<Map<String, dynamic>> addNoteToLead(String id, String note) =>
      remote.addNoteToLead(id, note);


}
