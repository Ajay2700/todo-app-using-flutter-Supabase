import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/screens/auth_screen.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/themes/app_theme.dart';
import 'package:todo_app/utils/init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app dependencies
  await AppInitializer.initialize();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://dbbizyarzydhgtfgvanj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRiYml6eWFyenlkaGd0Zmd2YW5qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcwMDc2ODcsImV4cCI6MjA3MjU4MzY4N30.XKhgQgUWJyzMSJQW-0BnuMVIEgMaTBTpySXLyX9HsPU',
  );

  // Initialize notification service
  await NotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Todo Reminder',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Bypass authentication and directly show HomeScreen
    return const HomeScreen();
  }
}
