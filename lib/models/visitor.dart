class Visitor {
  final String id;
  final String name;
  final String reason;
  final DateTime timestamp;
  final String? photoUrl;
  final String userId;

  Visitor({
    required this.id,
    required this.name,
    required this.reason,
    required this.timestamp,
    this.photoUrl,
    required this.userId,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['id'] as String,
      name: json['name'] as String,
      reason: json['reason'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      photoUrl: json['photo_url'] as String?,
      userId: json['user_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'reason': reason,
      'timestamp': timestamp.toIso8601String(),
      'photo_url': photoUrl,
      'user_id': userId,
    };
  }

  Visitor copyWith({
    String? id,
    String? name,
    String? reason,
    DateTime? timestamp,
    String? photoUrl,
    String? userId,
  }) {
    return Visitor(
      id: id ?? this.id,
      name: name ?? this.name,
      reason: reason ?? this.reason,
      timestamp: timestamp ?? this.timestamp,
      photoUrl: photoUrl ?? this.photoUrl,
      userId: userId ?? this.userId,
    );
  }
}
