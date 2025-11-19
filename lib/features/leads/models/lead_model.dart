// class LeadModel {
//   final String id;
//   final String name;
//   final String email;
//   final String phone;
//   final String source;
//   final String status;
//   final bool isDuplicate;
//   final String createdAt;
//
//   LeadModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.source,
//     required this.status,
//     required this.isDuplicate,
//     required this.createdAt,
//   });
//
//   factory LeadModel.fromJson(Map<String, dynamic> j) => LeadModel(
//     id: j['id'] ?? j['_id'] ?? '',
//     name: j['name'] ?? '',
//     email: j['email'] ?? '',
//     phone: j['phone'] ?? '',
//     source: j['source'] ?? '',
//     status: j['status'] ?? '',
//     isDuplicate: j['isDuplicate'] ?? false,
//     createdAt: j['createdAt'] ?? '',
//   );
// }

class LeadModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String source;
  final String status;
  final bool isDuplicate;
  final String createdAt;

  // optional extra data
  final List<dynamic> notes;
  final List<Map<String, dynamic>> timeline;

  LeadModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.source,
    required this.status,
    required this.isDuplicate,
    required this.createdAt,
    this.notes = const [],
    this.timeline = const [],
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: (json['id'] ?? json['_id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phone: (json['phone'] ?? '') as String,
      source: (json['source'] ?? '') as String,
      status: (json['status'] ?? '') as String,
      isDuplicate: (json['isDuplicate'] ?? false) as bool,
      createdAt: (json['createdAt'] ?? '') as String,

      // ✅ Defensive null handling
      notes: (json['notes'] is List)
          ? List<Map<String, dynamic>>.from(
          (json['notes'] as List).map((e) =>
          e is Map<String, dynamic> ? e : {'content': e.toString()}))
          : [],

      timeline: (json['timeline'] is List)
          ? List<Map<String, dynamic>>.from(
          (json['timeline'] as List).map((e) =>
          e is Map<String, dynamic> ? e : {'value': e.toString()}))
          : [],
    );
  }

  LeadModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? source,
    String? status,
    bool? isDuplicate,
    String? createdAt,
    List<dynamic>? notes,
    List<Map<String, dynamic>>? timeline,
  }) {
    return LeadModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      source: source ?? this.source,
      status: status ?? this.status,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      timeline: timeline ?? this.timeline,
    );
  }

}
