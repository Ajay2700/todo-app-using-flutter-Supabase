class Todo {
  final int id;
  final String title;
  final String? description;
  final DateTime deadline;
  final bool isCompleted;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notificationId;

  Todo({
    required this.id,
    required this.title,
    this.description,
    required this.deadline,
    required this.isCompleted,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.notificationId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      deadline: DateTime.parse(json['deadline'] as String),
      isCompleted: json['is_completed'] as bool? ?? false,
      userId: json['user_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      notificationId: json['notification_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'is_completed': isCompleted,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'notification_id': notificationId,
    };
  }

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? deadline,
    bool? isCompleted,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notificationId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notificationId: notificationId ?? this.notificationId,
    );
  }

  bool get isOverdue => !isCompleted && deadline.isBefore(DateTime.now());
  bool get isDueSoon =>
      !isCompleted &&
      deadline.difference(DateTime.now()).inHours <= 24 &&
      deadline.difference(DateTime.now()).inHours > 0;

  Duration get timeUntilDeadline => deadline.difference(DateTime.now());

  String get timeUntilDeadlineString {
    final duration = timeUntilDeadline;
    if (duration.isNegative) {
      return 'Overdue';
    } else if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h left';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m left';
    } else {
      return '${duration.inMinutes}m left';
    }
  }
}
