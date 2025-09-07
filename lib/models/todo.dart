class Todo {
  final int id;
  final String userId;
  final String title;
  final String? description;
  final DateTime deadline;
  final String? notificationId;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.userId,
    required this.title,
  this.description,
    required this.deadline,
  this.notificationId,
    this.isCompleted = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
    userId: json['user_id'] as String? ?? '',
    title: json['title'] as String,
    description: json['description'] as String?,
    deadline: json['deadline'] is String
      ? DateTime.parse(json['deadline'] as String)
      : DateTime.parse((json['deadline'] as DateTime).toIso8601String()),
    notificationId: json['notification_id'] as String?,
    isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
  'user_id': userId,
  'title': title,
  'description': description,
  'deadline': deadline.toIso8601String(),
  'notification_id': notificationId,
  'is_completed': isCompleted,
    };
  }

  Todo copyWith({
    int? id,
    String? userId,
    String? title,
    String? description,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
