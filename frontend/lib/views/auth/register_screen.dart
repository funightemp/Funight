import 'package:flutter/material.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;

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

                Image.asset('assets/logo_white_cropped.png', width: 200),

                const SizedBox(height: 40),

                buildSocialButton(
                  'Sign up with Google',
                  'assets/google_icon.png',
                ),
                const SizedBox(height: 10),
                buildSocialButton(
                  'Sign up with Facebook',
                  'assets/facebook_icon.png',
                ),

                const SizedBox(height: 20),
                buildDivider(),
                const SizedBox(height: 20),

                buildTextField('Name', Icons.person, false),
                const SizedBox(height: 15),
                buildTextField('E-mail', Icons.email_outlined, false),
                const SizedBox(height: 15),
                buildPasswordField(),

                const SizedBox(height: 30),
                buildPrimaryButton('Create Account', () {}),

                const SizedBox(height: 10),
                Text(
                  'By creating your account, you agree to the Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSocialButton(String text, String iconPath) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Image.asset(iconPath, width: 24),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF9747FF)),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Row(
      children: const [
        Expanded(child: Divider(color: Colors.white70)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("OR", style: TextStyle(color: Colors.white70)),
        ),
        Expanded(child: Divider(color: Colors.white70)),
      ],
    );
  }

  Widget buildTextField(String hint, IconData icon, bool obscure) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
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

  Widget buildPasswordField() {
    return buildTextField('Enter password', Icons.lock_outline, true);
  }

  Widget buildPrimaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF9747FF),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
