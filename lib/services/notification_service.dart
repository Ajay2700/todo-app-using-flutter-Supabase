import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<void> initialize() async {
    // Request FCM permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Configure FCM message handling
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Get and save FCM token
    await _saveFCMToken();
  }

  static Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
    debugPrint("Handling background message: ${message.notification?.title}");
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    debugPrint("Handling foreground message: ${message.notification?.title}");
  }

  static void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint("Message opened app: ${message.notification?.title}");
    // Handle when app is opened from notification
  }

  static Future<void> _saveFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        final user = _supabase.auth.currentUser;
        if (user != null) {
          await _supabase.from('user_tokens').upsert({
            'user_id': user.id,
            'fcm_token': token,
            'updated_at': DateTime.now().toIso8601String(),
          });
        }
      }
    } catch (e) {
      debugPrint('Error saving FCM token: $e');
    }
  }

  static Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    required int todoId,
    Map<String, dynamic>? data,
  }) async {
    try {
      // For now, just log the notification
      // In production, you would implement proper scheduling via server
      debugPrint('Notification scheduled for: $scheduledTime');
      debugPrint('Title: $title, Body: $body, TodoId: $todoId');

      // Schedule server-side notification via Supabase Edge Function
      await _scheduleServerNotification(
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        todoId: todoId,
        data: data,
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  static Future<void> _scheduleServerNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    required int todoId,
    Map<String, dynamic>? data,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase.functions.invoke(
        'schedule-notification',
        body: {
          'title': title,
          'body': body,
          'scheduledTime': scheduledTime.toIso8601String(),
          'todoId': todoId,
          'userId': user.id,
          'data': data,
        },
      );
    } catch (e) {
      debugPrint('Error scheduling server notification: $e');
    }
  }
}
