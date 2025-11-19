class IntegrationItem {
  final String platform;
  final String status;
  final bool isActive;

  IntegrationItem({
    required this.platform,
    required this.status,
    required this.isActive,
  });

  factory IntegrationItem.fromJson(Map<String, dynamic> json) {
    return IntegrationItem(
      platform: json['platform'] ?? '',
      status: json['status'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}

class IntegrationsStatusResponse {
  final List<IntegrationItem> integrations;

  IntegrationsStatusResponse({required this.integrations});

  factory IntegrationsStatusResponse.fromJson(Map<String, dynamic> json) {
    final integrationsMap = json['integrations'] as Map<String, dynamic>?;

    if (integrationsMap == null) {
      print("❌ integrations NULL from API");
      return IntegrationsStatusResponse(integrations: []);
    }

    print("✅ integrations received: ${integrationsMap.length}");

    return IntegrationsStatusResponse(
      integrations: integrationsMap.values
          .map((item) => IntegrationItem.fromJson(item))
          .toList(),
    );
  }

  factory IntegrationsStatusResponse.empty() =>
      IntegrationsStatusResponse(integrations: []);

}
