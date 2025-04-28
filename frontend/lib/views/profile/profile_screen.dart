import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controladores para os campos de texto
  final TextEditingController firstNameController = TextEditingController(
    text: "Dylan",
  );
  final TextEditingController lastNameController = TextEditingController(
    text: "Thomas",
  );
  final TextEditingController emailController = TextEditingController(
    text: "dylanthomas@server.com",
  );
  final TextEditingController phoneController = TextEditingController();

  // Cores consistentes com o tema
  final Color _backgroundColor = const Color(0xFF121212); // Cor de fundo ajustada para corresponder
  final Color _textColor = Colors.white;
  final Color _primaryColor = const Color(0xFF9747FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor, // Aplica a cor de fundo
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: null, // Remove o título do AppBar
        elevation: 0, // Remove a sombra do AppBar para combinar com o fundo preto
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar de perfil
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: _primaryColor, // Usa a cor primária
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
                    bottom: 5,
                    right: 5,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: _backgroundColor, // Cor de fundo do Scaffold
                      child: Icon(
                        Icons.camera_alt,
                        color: _primaryColor, // Usa a cor primária
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Campos de edição do perfil
            _buildTextField("First Name", firstNameController),
            _buildTextField("Last Name", lastNameController),
            _buildTextField("E-mail", emailController),
            // _buildTextField("Country", countryController), // Remove o campo Country

            // Campo de telefone com bandeira
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Phone Number",
                style: TextStyle(color: _textColor, fontSize: 14),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: _primaryColor), // Usa a cor primária
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/flag.png",
                        width: 24,
                      ),
                      const SizedBox(width: 5),
                      Text("+91", style: TextStyle(color: _textColor)),
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
                      hintText: "Enter phone number",
                      hintStyle: const TextStyle(color: Colors.white38),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor), // Usa a cor primária
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor), // Usa a cor primária
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Botão "Atualizar Dados"
            ElevatedButton(
              onPressed: () {
                // TODO: Implementar a lógica para atualizar os dados do perfil
                // Você pode usar os controladores (firstNameController, lastNameController, etc.)
                // para obter os valores dos campos e enviá-los para o servidor.
                print("firstName: ${firstNameController.text}");
                print("lastName: ${lastNameController.text}");
                print("email: ${emailController.text}");
                // print("country: ${countryController.text}"); // Removido do print
                print("phone: ${phoneController.text}");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor, // Usa a cor primária
                foregroundColor: _textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text(
                "Atualizar Dados",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para criar os campos de input
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: _textColor, fontSize: 14),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            style: TextStyle(color: _textColor),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _primaryColor), // Usa a cor primária
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _primaryColor), // Usa a cor primária
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

