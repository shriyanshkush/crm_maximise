class LeadSourceItem {
  final String source;
  final String displayName;
  final int count;
  final double percentage;
  final String color;

  LeadSourceItem({
    required this.source,
    required this.displayName,
    required this.count,
    required this.percentage,
    required this.color,
  });

  factory LeadSourceItem.fromJson(Map<String, dynamic> json) => LeadSourceItem(
    source: json['source'] ?? '',
    displayName: json['displayName'] ?? '',
    count: json['count'] ?? 0,
    percentage: (json['percentage'] ?? 0).toDouble(),
    color: json['color'] ?? '#000000',
  );
}

class LeadSourcesResponse {
  final List<LeadSourceItem> sources;
  final Map<String, dynamic> summary;

  LeadSourcesResponse({
    required this.sources,
    required this.summary,
  });

  factory LeadSourcesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return LeadSourcesResponse(
      sources: (data['sources'] as List<dynamic>? ?? [])
          .map((e) => LeadSourceItem.fromJson(e))
          .toList(),
      summary: data['summary'] ?? {},
    );
  }

  factory LeadSourcesResponse.empty() =>
      LeadSourcesResponse(summary: {}, sources: []);

}
