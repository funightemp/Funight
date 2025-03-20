import 'package:flutter/material.dart';
import 'package:frontend/core/theme.dart';
import 'views/home/main_screen.dart';

void main() {
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
      home: const MainScreen(),
    );
  }
}