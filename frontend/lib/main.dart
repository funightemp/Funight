import 'package:flutter/material.dart';
import 'core/routes.dart';

void main() {
  runApp(const FunightApp());
}

class FunightApp extends StatelessWidget {
  const FunightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Funight',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/login',
      routes: AppRoutes.routes,
    );
  }
}