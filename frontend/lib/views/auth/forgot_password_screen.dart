 import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fundo da tela
          Image.asset('assets/funight_bg.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Seta para voltar
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Logo
                Image.asset('assets/logo_white_cropped.png', width: 200),
                const SizedBox(height: 40),

                // Texto explicativo
                const Text(
                  "Enter your e-mail to reset your password",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Campo de e-mail
                buildTextField('E-mail', Icons.email_outlined, false),

                const SizedBox(height: 30),

                // Botão para enviar o reset de senha
                buildPrimaryButton('Reset Password', () {
                  // Aqui você pode adicionar a lógica para enviar o e-mail de reset de senha
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password reset link sent to your email")),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TextField genérico
  Widget buildTextField(String hint, IconData icon, bool obscure) {
    return TextField(
      controller: _emailController,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white), // Texto branco
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF9747FF)),
        ),
        prefixIcon: Icon(icon, color: Color(0xFF9747FF)),
      ),
    );
  }

  // Botão principal
  Widget buildPrimaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF9747FF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}