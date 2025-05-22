import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'complete_profile_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _registerUser() async {
    if (_nameController.text.isEmpty ||
        _surnameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showError("Por favor preencha todos os campos.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "name": _nameController.text.trim(),
        "surname": _surnameController.text.trim(),
        "email": _emailController.text.trim(),
        "createdAt": DateTime.now(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CompleteProfileScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Erro ao registar.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          //Background
          Image.asset('assets/funight_bg.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),

          // Seta no topo esquerdo
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Image.asset('assets/logo_white_cropped.png', width: 200),
                const SizedBox(height: 40),

                /// Nome e Apelido lado a lado
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(_nameController, 'Nome', Icons.person, false),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: buildTextField(_surnameController, 'Apelido', Icons.person_2_outlined, false),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                buildTextField(_emailController, 'E-mail', Icons.email_outlined, false),
                const SizedBox(height: 15),
                buildTextField(_passwordController, 'Password', Icons.lock_outline, true),

                const SizedBox(height: 30),
                buildPrimaryButton('Criar Conta', _registerUser),

                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Já tens conta? Inicia sessão', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hint, IconData icon, bool obscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
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

  Widget buildPrimaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9747FF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(text),
      ),
    );
  }
}