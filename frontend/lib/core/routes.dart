import 'package:flutter/material.dart';
import '../views/auth/login_screen.dart';
import '../views/home/home_screen.dart';
import '../views/profile/profile_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => LoginScreen(),
    '/home': (context) => HomeScreen(),
    '/profile': (context) => ProfileScreen(),
  };
}