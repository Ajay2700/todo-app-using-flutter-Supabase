import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo_model.dart';

class TodoService {
  // Using admin client to bypass RLS during development
  final SupabaseClient _supabase = SupabaseClient(
    'https://dbbizyarzydhgtfgvanj.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRiYml6eWFyenlkaGd0Zmd2YW5qIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NzAwNzY4NywiZXhwIjoyMDcyNTgzNjg3fQ.SvHuE1kaQ_qKRkquKb2iq5E8ZbWJQbNvJfYuDkC-eIU',
  );

  Future<List<Todo>> getTodos(String userId) async {
    try {
      final response = await _supabase
          .from('todos')
          .select()
          .eq('user_id', userId)
          .order('deadline');

      return response.map<Todo>((todo) => Todo.fromJson(todo)).toList();
    } catch (e) {
      throw Exception('Failed to fetch todos: $e');
    }
  }

  Future<Todo> addTodo({
    required String title,
    String? description,
    required DateTime deadline,
    required String userId,
    String? notificationId,
  }) async {
    try {
      final response = await _supabase
          .from('todos')
          .insert({
            'title': title,
            'description': description,
            'deadline': deadline.toIso8601String(),
            'user_id': userId,
            'is_completed': false,
            'notification_id': notificationId,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return Todo.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add todo: $e');
    }
  }

  Future<Todo> updateTodo({
    required int id,
    String? title,
    String? description,
    DateTime? deadline,
    bool? isCompleted,
    String? notificationId,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (deadline != null) updateData['deadline'] = deadline.toIso8601String();
      if (isCompleted != null) updateData['is_completed'] = isCompleted;
      if (notificationId != null)
        updateData['notification_id'] = notificationId;

      final response = await _supabase
          .from('todos')
          .update(updateData)
          .eq('id', id)
          .select()
          .single();

      return Todo.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  Future<void> updateTodoStatus(int id, bool isCompleted) async {
    try {
      await _supabase.from('todos').update({
        'is_completed': isCompleted,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update todo status: $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _supabase.from('todos').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }

  Future<List<Todo>> getOverdueTodos(String userId) async {
    try {
      final response = await _supabase
          .from('todos')
          .select()
          .eq('user_id', userId)
          .eq('is_completed', false)
          .lt('deadline', DateTime.now().toIso8601String())
          .order('deadline');

      return response.map<Todo>((todo) => Todo.fromJson(todo)).toList();
    } catch (e) {
      throw Exception('Failed to fetch overdue todos: $e');
    }
  }

  Future<List<Todo>> getDueSoonTodos(String userId) async {
    try {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(hours: 24));

      final response = await _supabase
          .from('todos')
          .select()
          .eq('user_id', userId)
          .eq('is_completed', false)
          .gte('deadline', now.toIso8601String())
          .lte('deadline', tomorrow.toIso8601String())
          .order('deadline');

      return response.map<Todo>((todo) => Todo.fromJson(todo)).toList();
    } catch (e) {
      throw Exception('Failed to fetch due soon todos: $e');
    }
  }

  Stream<List<Todo>> watchTodos(String userId) {
    return _supabase
        .from('todos')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('deadline')
        .map((data) => data.map<Todo>((todo) => Todo.fromJson(todo)).toList());
  }
}
