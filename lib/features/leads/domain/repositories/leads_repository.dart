import '../../models/lead_model.dart';
import '../../models/leads_response_model.dart';
import '../../models/leads_stats_model.dart';

abstract class LeadsRepository {
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

  /// ✅ Added for lead details
  Future<LeadModel> getLeadById(String id);

  /// ✅ Added for notes
  Future<Map<String, dynamic>> addNoteToLead(String id, String note);


}
