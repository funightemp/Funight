import 'package:flutter/material.dart';
import 'package:frontend/views/auth/register_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/home/main_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => LoginScreen(),
    '/main': (context) => MainScreen(),
    '/register': (context) => RegisterScreen(),
  };
}