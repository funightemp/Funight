import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/views/auth/login_screen.dart';
import 'package:frontend/views/home/main_page.dart';
import 'package:frontend/views/home/main_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return const MainPage();
    } else {
      return const LoginScreen();
    }
  }
}