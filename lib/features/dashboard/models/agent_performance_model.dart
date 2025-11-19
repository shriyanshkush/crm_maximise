class AgentUser {
  final String userId;
  final String name;
  final List<String> roles;
  final int leadCount;
  final int qualified;
  final int converted;
  final double totalRevenue;
  final double performanceScore;
  final String? avatar;
  final String initials;
  final double revenuePerLead;
  final double revenueGrowth;

  AgentUser({
    required this.userId,
    required this.name,
    required this.roles,
    required this.leadCount,
    required this.qualified,
    required this.converted,
    required this.totalRevenue,
    required this.performanceScore,
    required this.initials,
    this.avatar,
    this.revenuePerLead = 0,
    this.revenueGrowth = 0,
  });

  factory AgentUser.fromJson(Map<String, dynamic> json) {
    return AgentUser(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      leadCount: json['leadCount'] ?? 0,
      qualified: json['qualified'] ?? 0,
      converted: json['converted'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      performanceScore: (json['performanceScore'] ?? 0).toDouble(),
      avatar: json['avatar'],
      initials: json['initials'] ?? '',
      revenuePerLead: (json['revenuePerLead'] ?? 0).toDouble(),
      revenueGrowth: (json['revenueGrowth'] ?? 0).toDouble(),
    );
  }
}

class AgentPerformanceResponse {
  final List<AgentUser> users;
  final Map<String, dynamic> organizationTotals;

  AgentPerformanceResponse({
    required this.users,
    required this.organizationTotals,
  });

  factory AgentPerformanceResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return AgentPerformanceResponse(
      users: (data['users'] as List<dynamic>? ?? [])
          .map((e) => AgentUser.fromJson(e))
          .toList(),
      organizationTotals: data['organizationTotals'] ?? {},
    );
  }

  factory AgentPerformanceResponse.empty() =>
      AgentPerformanceResponse(users: [], organizationTotals: {});

}
