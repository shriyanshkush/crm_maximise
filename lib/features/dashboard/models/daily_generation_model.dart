class LeadAnalysisItem {
  final String period;   // Fri, Sat OR 14:00 OR Jan
  final int count;

  LeadAnalysisItem({
    required this.period,
    required this.count,
  });

  factory LeadAnalysisItem.fromJson(Map<String, dynamic> json) {
    return LeadAnalysisItem(
      period: json['period']?.toString() ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class LeadAnalysisResponse {
  final List<LeadAnalysisItem> data;
  final Map<String, dynamic> summary;
  final String view;         // daily / weekly / monthly
  final String periodUnit;   // hour / day / month

  LeadAnalysisResponse({
    required this.data,
    required this.summary,
    required this.view,
    required this.periodUnit,
  });

  factory LeadAnalysisResponse.fromJson(Map<String, dynamic> json) {
    final d = json['data'] ?? {};

    return LeadAnalysisResponse(
      data: (d['data'] as List? ?? [])
          .map((e) => LeadAnalysisItem.fromJson(e))
          .toList(),
      summary: d['summary'] ?? {},
      view: d['view'] ?? "weekly",
      periodUnit: d['periodUnit'] ?? "",
    );
  }

  factory LeadAnalysisResponse.empty() =>
      LeadAnalysisResponse(data: [], summary: {}, view: '', periodUnit: '');

}
