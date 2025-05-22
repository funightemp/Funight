import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/events/event_card.dart';
import 'package:frontend/views/profile/profile_edit_screen.dart'; // importa o ConfirmedEventCard

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? name;
  String? surname;
  String? bio;
  String? photoBase64;

  List<Map<String, dynamic>> _confirmedEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchConfirmedEvents();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        name = data['name'] ?? '';
        surname = data['surname'] ?? '';
        bio = data['bio'] ?? '';
        photoBase64 = data['photoBase64'];
      });
    }
  }

  Future<void> _fetchConfirmedEvents() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tickets')
        .get();

    final now = DateTime.now();

    final events = snapshot.docs
        .map((doc) => doc.data())
        .where((ticket) {
          final dateStr = ticket['eventDate'];
          final eventDate = DateTime.tryParse(dateStr ?? '');
          return eventDate != null && eventDate.isAfter(now);
        })
        .toList();

    setState(() {
      _confirmedEvents = events;
      isLoading = false;
    });
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Terminar sessão"),
        content: const Text("Tens a certeza que queres terminar sessão?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text("Sair"),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF121212);
    const textColor = Colors.white;
    const primaryColor = Color(0xFFBB86FC);

    final decodedImage = _safeDecodeBase64(photoBase64);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Perfil", style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar Perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Terminar Sessão',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: primaryColor,
                          backgroundImage: decodedImage != null ? MemoryImage(decodedImage) : null,
                          child: decodedImage == null
                              ? Text(
                                  (name != null && surname != null)
                                      ? "${name![0]}${surname![0]}"
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$name $surname',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                bio ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text(
                      'Próximos Eventos Confirmados:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// Lista de eventos confirmados
                    if (_confirmedEvents.isNotEmpty)
                      Column(
                        children: _confirmedEvents.map((event) {
                          return ConfirmedEventCard(
                            title: event['eventTitle'] ?? '',
                            date: event['eventDate'] ?? '',
                            location: event['eventLocation'] ?? '',
                            backgroundColor: const Color(0xFF1E1E1E),
                            textColor: textColor,
                          );
                        }).toList(),
                      )
                    else
                      const Text(
                        'Nenhum evento confirmado.',
                        style: TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}