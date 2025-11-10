class LeadQualityItem {
  final String name;
  final String displayName;
  final int count;
  final String color;

  LeadQualityItem({
    required this.name,
    required this.displayName,
    required this.count,
    required this.color,
  });

  factory LeadQualityItem.fromJson(Map<String, dynamic> json) => LeadQualityItem(
    name: json['name'] ?? '',
    displayName: json['displayName'] ?? '',
    count: json['count'] ?? 0,
    color: json['color'] ?? '#000000',
  );
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
}
