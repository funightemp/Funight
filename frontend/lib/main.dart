import 'package:flutter/material.dart';
import 'package:frontend/core/theme.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/views/auth/auth_gate.dart';
import 'package:frontend/views/auth/complete_profile_screen.dart';
import 'package:frontend/views/auth/login_screen.dart';
import 'package:frontend/views/auth/register_screen.dart';
import 'package:frontend/views/home/start_page.dart';
import 'package:frontend/views/profile/profile_screen.dart';
import 'package:frontend/views/social/add_friend_screen.dart';
import 'views/home/main_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      title: 'Funight',
      home: const AuthGate(),
      routes: {
        '/start': (context) => const StartPage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const MainPage(),
        '/profile': (context) => const ProfileScreen(),
        '/complete_profile': (context) => const CompleteProfileScreen(),
        '/add_friend': (context) => const AddFriendScreen(),
      },
    );
  }
}
