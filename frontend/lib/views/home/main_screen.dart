import 'package:flutter/material.dart';
import 'package:frontend/views/auth/register_screen.dart';
import 'package:frontend/views/auth/login_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/funight_bg.png',
            fit: BoxFit.cover,
          ),

          // Shadow
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Page Content
          Column(
            children: [
              const SizedBox(height: 80), 

              // App Logo
              Image.asset(
                'assets/logo_white_cropped.png',
                width: 250,
              ),

              const Spacer(),

              // Login and Register Buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 50), // Espaço na parte inferior
                child: Column(
                  children: [
                    buildLoginButton(context),
                    const SizedBox(height: 15),
                    buildRegisterButton(context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Login Button
  Widget buildLoginButton(BuildContext context) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        child: const Text('Login'),
      ),
    );
  }

  // Register Button
  Widget buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: 250,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        },
        child: const Text('Registar'),
      ),
    );
  }
}