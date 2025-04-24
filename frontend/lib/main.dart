import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme.dart';
import 'views/home/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Testa ligação
  try {
    final doc = await FirebaseFirestore.instance.collection("test").doc("ping").get();
    print("🔥 Ligado ao Firestore! Documento existe: ${doc.exists}");
  } catch (e) {
    print("❌ Erro na ligação ao Firestore: $e");
  }

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
