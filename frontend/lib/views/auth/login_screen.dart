import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'package:frontend/views/home/events_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _signInWithEmailAndPassword() async {
  setState(() => _isLoading = true);
  print("Sign in started");

  try {
  await _auth.signInWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  );
  print('✅ Login feito com sucesso');

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const EventsScreen()),
  );
} on FirebaseAuthException catch (e) {
  print('❌ Erro no login: ${e.message}');
  _showError(e.message ?? "Login failed");
}
}

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      _saveUserToFirestore(userCredential.user);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EventsScreen()),
      );
    } catch (e) {
      _showError("Google login failed");
    }
  }

  void _saveUserToFirestore(User? user) {
    if (user != null) {
      FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "email": user.email,
        "name": user.displayName ?? "User",
      }, SetOptions(merge: true));
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/funight_bg.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Image.asset('assets/logo_white_cropped.png', width: 200),
                const SizedBox(height: 40),

                // Login Google
                buildSocialButton('Login with Google', 'assets/google_icon.png', _signInWithGoogle),

                const SizedBox(height: 20),
                buildTextField(_emailController, 'E-mail', Icons.email_outlined, false),
                const SizedBox(height: 15),
                buildTextField(_passwordController, 'Password', Icons.lock_outline, true),

                const SizedBox(height: 30),
                buildPrimaryButton('Login', _signInWithEmailAndPassword),

                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                  child: const Text('Don´t have an account? Create one now!', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen())),
                  child: const Text('Forgot Your Password', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSocialButton(String text, String iconPath, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(iconPath, width: 24),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF9747FF)),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
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
        child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text(text),
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