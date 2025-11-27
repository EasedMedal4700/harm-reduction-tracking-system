/// Represents a daily check-in entry
class DailyCheckin {
  final String? id;
  final String userId;
  final DateTime checkinDate;
  final String mood; // Great, Good, Okay, Struggling, etc.
  final List<String> emotions;
  final String timeOfDay; // morning, afternoon, evening
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DailyCheckin({
    this.id,
    required this.userId,
    required this.checkinDate,
    required this.mood,
    required this.emotions,
    required this.timeOfDay,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  /// Creates a DailyCheckin from JSON data
  factory DailyCheckin.fromJson(Map<String, dynamic> json) {
    return DailyCheckin(
      id: json['id']?.toString(),
      userId: json['uuid_user_id']?.toString() ?? '',
      checkinDate: json['checkin_date'] is String
          ? DateTime.parse(json['checkin_date'])
          : json['checkin_date'] as DateTime,
      mood: json['mood']?.toString() ?? '',
      emotions: json['emotions'] is List
          ? (json['emotions'] as List).map((e) => e.toString()).toList()
          : [],
      timeOfDay: json['time_of_day']?.toString() ?? '',
      notes: json['notes']?.toString(),
      createdAt: json['created_at'] != null
          ? (json['created_at'] is String
              ? DateTime.parse(json['created_at'])
              : json['created_at'] as DateTime)
          : null,
      updatedAt: json['updated_at'] != null
          ? (json['updated_at'] is String
              ? DateTime.parse(json['updated_at'])
              : json['updated_at'] as DateTime)
          : null,
    );
  }

  /// Converts this DailyCheckin to JSON data
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uuid_user_id': userId,
      'checkin_date': checkinDate.toIso8601String().split('T')[0], // Date only
      'mood': mood,
      'emotions': emotions,
      'time_of_day': timeOfDay,
      'notes': notes,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// Creates a copy of this DailyCheckin with optional field overrides
  DailyCheckin copyWith({
    String? id,
    String? userId,
    DateTime? checkinDate,
    String? mood,
    List<String>? emotions,
    String? timeOfDay,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyCheckin(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      checkinDate: checkinDate ?? this.checkinDate,
      mood: mood ?? this.mood,
      emotions: emotions ?? this.emotions,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
