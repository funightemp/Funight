import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controladores
  final TextEditingController firstNameController = TextEditingController(text: "Dylan");
  final TextEditingController lastNameController = TextEditingController(text: "Thomas");
  final TextEditingController emailController = TextEditingController(text: "dylanthomas@server.com");
  final TextEditingController phoneController = TextEditingController();

  // Cores do tema
  final Color _backgroundColor = const Color(0xFF121212);
  final Color _textColor = Colors.white;
  final Color _primaryColor = const Color(0xFFBB86FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text("Perfil", style: TextStyle(color: Colors.white)),
        backgroundColor: _backgroundColor,
        iconTheme: IconThemeData(color: _textColor),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: _primaryColor,
                    child: Text(
                      "DT",
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: _backgroundColor,
                      child: Icon(Icons.camera_alt, size: 18, color: _primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("Informações Pessoais"),
            _buildTextField("Primeiro Nome", firstNameController),
            _buildTextField("Último Nome", lastNameController),
            _buildTextField("E-mail", emailController),

            const SizedBox(height: 20),
            _buildSectionTitle("Contacto"),
            Text(
              "Número de Telemóvel",
              style: TextStyle(color: _textColor, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: _primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/flag.png", width: 24),
                      const SizedBox(width: 5),
                      Text("+351", style: TextStyle(color: _textColor)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    style: TextStyle(color: _textColor),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Digite o número",
                      hintStyle: const TextStyle(color: Colors.white38),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                print("Nome: ${firstNameController.text} ${lastNameController.text}");
                print("Email: ${emailController.text}");
                print("Telefone: ${phoneController.text}");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: _textColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Atualizar Dados", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: _textColor, fontSize: 14)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            style: TextStyle(color: _textColor),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}