import 'lead_model.dart';

class LeadsResponse {
  final List<LeadModel> data;
  final Map<String, dynamic> pagination;
  final Map<String, dynamic> statistics;

  LeadsResponse({
    required this.data,
    required this.pagination,
    required this.statistics,
  });

  factory LeadsResponse.fromJson(Map<String, dynamic> j) {
    return LeadsResponse(
      data: (j['data'] as List<dynamic>? ?? []).map((e) => LeadModel.fromJson(e as Map<String, dynamic>)).toList(),
      pagination: j['pagination'] ?? {},
      statistics: j['statistics'] ?? {},
    );
  }
}
