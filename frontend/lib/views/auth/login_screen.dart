import 'package:flutter/material.dart';
import 'package:frontend/views/home/events_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

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

          // Sombra para melhorar visibilidade do conteúdo
          Container(color: Colors.black.withOpacity(0.6)),

          // Conteúdo principal
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

                // Logo
                Image.asset(
                  'assets/logo_white_cropped.png',
                  width: 200,
                ),

                const SizedBox(height: 40),

                // Botões Sociais
                buildSocialButton('Login with Google', 'assets/google_icon.png'),
                const SizedBox(height: 10),
                buildSocialButton('Login with Facebook', 'assets/facebook_icon.png'),

                const SizedBox(height: 20),

                // Linha separadora "OR"
                buildDivider(),

                const SizedBox(height: 20),

                // Campo de E-mail
                buildTextField('E-mail', Icons.email_outlined, false),

                const SizedBox(height: 15),

                // Campo de Senha com ícone de visibilidade
                buildPasswordField(),

                const SizedBox(height: 30),

                // Botão de Login
                buildPrimaryButton('Login', () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const EventsScreen()),
                  );
                }),

                const SizedBox(height: 10),

                // Don´t have an account
                TextButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                  },
                  child: const Text(
                    'Don´t have an account? Create one now!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                  );
                  },
                  child: const Text(
                    'Forgot Your Password',
                    style: TextStyle(color: Colors.white),
                  ),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  // e-mail Textfield
  Widget buildTextField(String hint, IconData icon, bool obscure) {
  return TextField(
    obscureText: obscure,
    style: const TextStyle(color: Colors.white), // Torna o texto digitado branco
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70), // Deixa o hint text branco acinzentado
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

  // Password Textfield
  Widget buildPasswordField() {
    return TextField(
      obscureText: _obscurePassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Enter password',
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF9747FF)),
        ),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9747FF)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Color(0xFF9747FF),
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}