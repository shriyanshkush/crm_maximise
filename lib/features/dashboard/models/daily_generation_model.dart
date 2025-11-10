class DailyDataItem {
  final String period;
  final int count;

  DailyDataItem({
    required this.period,
    required this.count,
  });

  factory DailyDataItem.fromJson(Map<String, dynamic> json) => DailyDataItem(
    period: json['period'] ?? '',
    count: json['count'] ?? 0,
  );
}

class DailyGenerationResponse {
  final List<DailyDataItem> data;
  final Map<String, dynamic> summary;

  DailyGenerationResponse({
    required this.data,
    required this.summary,
  });

  factory DailyGenerationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return DailyGenerationResponse(
      data: (data['data'] as List<dynamic>? ?? [])
          .map((e) => DailyDataItem.fromJson(e))
          .toList(),
      summary: data['summary'] ?? {},
    );
  }
}
