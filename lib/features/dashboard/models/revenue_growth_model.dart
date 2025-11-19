class RevenueGrowthItem {
  final String period;
  final double totalRevenue;

  RevenueGrowthItem({
    required this.period,
    required this.totalRevenue,
  });

  factory RevenueGrowthItem.fromJson(Map<String, dynamic> json) {
    return RevenueGrowthItem(
      period: json["period"] ?? "",
      totalRevenue: (json["totalRevenue"] ?? 0).toDouble(),
    );
  }
}

class RevenueGrowthResponse {
  final String period;
  final List<RevenueGrowthItem> data;

  RevenueGrowthResponse({
    required this.period,
    required this.data,
  });

  factory RevenueGrowthResponse.fromJson(Map<String, dynamic> json) {
    final d = json["data"] ?? {};

    return RevenueGrowthResponse(
      period: d["period"] ?? "",
      data: (d["data"] as List<dynamic>? ?? [])
          .map((e) => RevenueGrowthItem.fromJson(e))
          .toList(),
    );
  }

  factory RevenueGrowthResponse.empty() =>
      RevenueGrowthResponse(data: [], period: '');

}
