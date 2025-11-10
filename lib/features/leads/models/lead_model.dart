class LeadModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String source;
  final String status;
  final bool isDuplicate;
  final String createdAt;

  LeadModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.source,
    required this.status,
    required this.isDuplicate,
    required this.createdAt,
  });

  factory LeadModel.fromJson(Map<String, dynamic> j) => LeadModel(
    id: j['id'] ?? j['_id'] ?? '',
    name: j['name'] ?? '',
    email: j['email'] ?? '',
    phone: j['phone'] ?? '',
    source: j['source'] ?? '',
    status: j['status'] ?? '',
    isDuplicate: j['isDuplicate'] ?? false,
    createdAt: j['createdAt'] ?? '',
  );
}
