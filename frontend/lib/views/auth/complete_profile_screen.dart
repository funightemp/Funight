import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'login_screen.dart';
import 'dart:convert';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _bioController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<String?> _convertImageToBase64(File image) async {
    try {
      final bytes = await image.readAsBytes();
      final base64Str = base64Encode(bytes);
      final mimeType = image.path.endsWith('.png') ? 'image/png' : 'image/jpeg';
      return 'data:$mimeType;base64,$base64Str';
    } catch (e) {
      print('Erro ao converter imagem: $e');
      return null;
    }
  }

  Future<void> _submitProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    String? base64Image;
    if (_imageFile != null) {
      base64Image = await _convertImageToBase64(_imageFile!);
    }

    await _firestore.collection("users").doc(user.uid).update({
      "bio": _bioController.text.trim(),
      "photoBase64": base64Image ?? "",
    });

    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      Image.asset('assets/logo_white_cropped.png', width: 200),
                      const SizedBox(height: 20),

                      const Text(
                        '👋 Completa o teu perfil',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Adiciona uma foto e escreve algo sobre ti (opcional)',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: const Color(0xFF9747FF),
                              backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                              child: _imageFile == null
                                  ? const Icon(Icons.camera_alt, size: 32, color: Colors.white)
                                  : null,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                      buildBioField(),
                      const SizedBox(height: 30),
                      buildPrimaryButton("Guardar", _submitProfile),
                      const SizedBox(height: 10),
                      buildSecondaryButton("Ignorar", () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      }),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildSecondaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white70),
          foregroundColor: Colors.white70,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text),
      ),
    );
  }

  Widget buildBioField() {
    return TextField(
      controller: _bioController,
      maxLines: 4,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Escreve algo sobre ti...',
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF9747FF)),
        ),
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