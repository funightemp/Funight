import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController firstNameController = TextEditingController(
    text: "Dylan",
  );
  final TextEditingController lastNameController = TextEditingController(
    text: "Thomas",
  );
  final TextEditingController emailController = TextEditingController(
    text: "dylanthomas@server.com",
  );
  final TextEditingController countryController = TextEditingController(
    text: "United States",
  );
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Aqui você pode adicionar a lógica para salvar os dados
            },
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Color(0xFF9747FF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
                    backgroundColor: Color(0xFF9747FF),
                    child: Text(
                      "DT",
                      style: TextStyle(
                        color: Colors.white,
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
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        color: Color(0xFF9747FF),
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
            _buildTextField("Country", countryController),

            // Campo de telefone com bandeira
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Phone Number",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF9747FF)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/flag.png",
                        width: 24,
                      ), // Adicione a imagem da bandeira aqui
                      const SizedBox(width: 5),
                      const Text("+91", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Enter phone number",
                      hintStyle: TextStyle(color: Colors.white38),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9747FF)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9747FF)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Color(0xFF9747FF),
        unselectedItemColor: Colors.white70,
        currentIndex: 4,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Create Event",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
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
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF9747FF)),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF9747FF)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
