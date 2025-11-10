class LeadsStatsResponse {
  final Map<String, dynamic> overview;
  final List<dynamic> sources;
  final List<dynamic> statuses;

  LeadsStatsResponse({
    required this.overview,
    required this.sources,
    required this.statuses,
  });

  factory LeadsStatsResponse.fromJson(Map<String, dynamic> j) {
    final d = j['data'] ?? {};
    return LeadsStatsResponse(
      overview: d['overview'] ?? {},
      sources: d['sources'] ?? [],
      statuses: d['statuses'] ?? [],
    );
  }
}
