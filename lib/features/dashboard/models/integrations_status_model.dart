class IntegrationItem {
  final String platform;
  final String status;

  IntegrationItem({required this.platform, required this.status});

  factory IntegrationItem.fromJson(Map<String, dynamic> json) => IntegrationItem(
    platform: json['platform'] ?? '',
    status: json['status'] ?? '',
  );
}

class IntegrationsStatusResponse {
  final Map<String, IntegrationItem> integrations;

  IntegrationsStatusResponse({required this.integrations});

  factory IntegrationsStatusResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final items = <String, IntegrationItem>{};
    if (data['integrations'] != null) {
      (data['integrations'] as Map<String, dynamic>).forEach((key, value) {
        items[key] = IntegrationItem.fromJson(value);
      });
    }
    return IntegrationsStatusResponse(integrations: items);
  }
}
