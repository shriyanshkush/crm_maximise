class LeadQualityItem {
  final String name;
  final String displayName;
  final int count;
  final String color;
  final double avgScore;
  final double totalRevenue;
  final double avgRevenue;
  final int leadsWithRevenue;

  LeadQualityItem({
    required this.name,
    required this.displayName,
    required this.count,
    required this.color,
    required this.avgScore,
    required this.totalRevenue,
    required this.avgRevenue,
    required this.leadsWithRevenue,
  });

  factory LeadQualityItem.fromJson(Map<String, dynamic> json) {
    return LeadQualityItem(
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? '',
      count: json['count'] ?? 0,
      color: json['color'] ?? '#6c757d',
      avgScore: (json['avgScore'] ?? 0).toDouble(),
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      avgRevenue: (json['avgRevenue'] ?? 0).toDouble(),
      leadsWithRevenue: json['leadsWithRevenue'] ?? 0,
    );
  }
}


class LeadQualityResponse {
  final List<LeadQualityItem> quality;
  final Map<String, dynamic> summary;

  LeadQualityResponse({
    required this.quality,
    required this.summary,
  });

  factory LeadQualityResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return LeadQualityResponse(
      quality: (data['quality'] as List<dynamic>? ?? [])
          .map((e) => LeadQualityItem.fromJson(e))
          .toList(),
      summary: data['summary'] ?? {},
    );
  }

  factory LeadQualityResponse.empty() =>
      LeadQualityResponse(quality: [], summary: {});

}
