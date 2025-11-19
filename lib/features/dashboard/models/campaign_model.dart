class CampaignItem {
  final String source;
  final String campaignName;
  final String displayName;
  final int count;
  final String color;

  CampaignItem({
    required this.source,
    required this.campaignName,
    required this.displayName,
    required this.count,
    required this.color,
  });

  factory CampaignItem.fromJson(Map<String, dynamic> json) {
    return CampaignItem(
      source: json['source'] ?? '',
      campaignName: json['campaignName'] ?? '',
      displayName: json['displayName'] ?? '',
      count: json['count'] ?? 0,
      color: json['color'] ?? '#000000',
    );
  }
}

class CampaignResponse {
  final List<CampaignItem> campaigns;
  final Map<String, dynamic> summary;

  CampaignResponse({
    required this.campaigns,
    required this.summary,
  });

  factory CampaignResponse.fromJson(Map<String, dynamic> json) {
    final d = json['data'] ?? {};
    return CampaignResponse(
      campaigns: (d['campaigns'] as List? ?? [])
          .map((e) => CampaignItem.fromJson(e))
          .toList(),
      summary: d['summary'] ?? {},
    );
  }

  factory CampaignResponse.empty() =>
      CampaignResponse(summary: {}, campaigns: []);

}
