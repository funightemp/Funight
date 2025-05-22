import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? photoBase64;

  final Color _backgroundColor = const Color(0xFF121212);
  final Color _textColor = Colors.white;
  final Color _primaryColor = const Color(0xFFBB86FC);

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        nameController.text = data['name'] ?? '';
        surnameController.text = data['surname'] ?? '';
        bioController.text = data['bio'] ?? '';
        emailController.text = user.email ?? '';
        photoBase64 = data['photoBase64'];
      });
    }
  }

  Uint8List? _safeDecodeBase64(String? base64String) {
    try {
      if (base64String != null && base64String.contains(',')) {
        final data = base64String.split(',').last;
        if (data.length % 4 == 0) {
          return base64Decode(data);
        }
      }
    } catch (e) {
      debugPrint('Erro ao decodificar imagem: $e');
    }
    return null;
  }

  Future<void> updateProfileData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'name': nameController.text,
      'surname': surnameController.text,
      'bio': bioController.text,
    });

    if (emailController.text != user.email && emailController.text.isNotEmpty) {
      await user.updateEmail(emailController.text);
    }

    if (passwordController.text.isNotEmpty) {
      await user.updatePassword(passwordController.text);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final decodedImage = _safeDecodeBase64(photoBase64);

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text("Editar Perfil", style: TextStyle(color: Colors.white)),
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
                    backgroundImage: decodedImage != null ? MemoryImage(decodedImage) : null,
                    child: decodedImage == null
                        ? Text(
                            "${nameController.text.isNotEmpty ? nameController.text[0] : ''}${surnameController.text.isNotEmpty ? surnameController.text[0] : ''}",
                            style: TextStyle(
                              color: _textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickAndSaveImage,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: _backgroundColor,
                        child: Icon(Icons.camera_alt, size: 18, color: _primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("Perfil de Utilizador"),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(child: _buildTextField("Nome", nameController)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField("Apelido", surnameController)),
                ],
              ),
            ),
            _buildTextField("Biografia", bioController, maxLines: 3),
            const SizedBox(height: 30),
            _buildSectionTitle("Informações da Conta"),
            _buildTextField("E-mail", emailController),
            _buildTextField("Nova Password", passwordController, obscureText: true),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: updateProfileData,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: _textColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Guardar Alterações", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _confirmDeleteAccount(context),
              label: const Text("Eliminar Conta"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: _textColor, fontSize: 14)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            obscureText: obscureText,
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

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Eliminar conta"),
        content: const Text("Tem a certeza que quer eliminar a sua conta? Esta ação é irreversível."),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
                await user.delete();
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndSaveImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      setState(() {
        photoBase64 = 'data:image/png;base64,$base64Image';
      });

      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'photoBase64': photoBase64,
        });
      }
    }
  }
}