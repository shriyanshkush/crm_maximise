class LeadSourceItem {
  final String displayName;
  final int count;
  final String color;

  LeadSourceItem({
    required this.displayName,
    required this.count,
    required this.color,
  });

  factory LeadSourceItem.fromJson(Map<String, dynamic> json) => LeadSourceItem(
    displayName: json['displayName'] ?? '',
    count: json['count'] ?? 0,
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
}
