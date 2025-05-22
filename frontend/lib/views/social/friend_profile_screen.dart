import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FriendProfileScreen extends StatefulWidget {
  final String friendId;

  const FriendProfileScreen({super.key, required this.friendId});

  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  Map<String, dynamic>? friendData;
  List<Map<String, dynamic>> futureEvents = [];
  bool isLoading = true;

  final Color _backgroundColor = const Color(0xFF121212);
  final Color _textColor = Colors.white;
  final Color _primaryColor = const Color(0xFFBB86FC);

  @override
  void initState() {
    super.initState();
    _loadFriendProfile();
  }

  Future<void> _loadFriendProfile() async {
    final friendDoc = await FirebaseFirestore.instance.collection('users').doc(widget.friendId).get();

    if (friendDoc.exists) {
      final data = friendDoc.data()!;
      final ticketsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.friendId)
          .collection('tickets')
          .get();

      final now = DateTime.now();

      final events = ticketsSnapshot.docs
          .map((doc) => doc.data())
          .where((ticket) {
            final date = DateTime.tryParse(ticket['eventDate'] ?? '');
            return date != null && date.isAfter(now);
          })
          .toList();

      setState(() {
        friendData = data;
        futureEvents = events;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || friendData == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(friendData!['name'] ?? 'Perfil', style: TextStyle(color: _textColor)),
        backgroundColor: _backgroundColor,
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Perfil
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: _primaryColor,
                    backgroundImage: friendData!['photoBase64'] != null &&
                            friendData!['photoBase64'].toString().isNotEmpty
                        ? MemoryImage(base64Decode(friendData!['photoBase64'].split(',').last))
                        : null,
                    child: (friendData!['photoBase64'] == null || friendData!['photoBase64'].isEmpty)
                        ? Text(
                            "${friendData!['name']?[0] ?? ''}${friendData!['surname']?[0] ?? ''}",
                            style: TextStyle(
                              fontSize: 24,
                              color: _textColor,
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
                          "${friendData!['name'] ?? ''} ${friendData!['surname'] ?? ''}",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _textColor),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          friendData!['bio'] ?? '',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(color: Colors.grey),
              const SizedBox(height: 24),

              /// Eventos Confirmados
              Text(
                'Próximos Eventos Confirmados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor),
              ),
              const SizedBox(height: 12),
              if (futureEvents.isNotEmpty)
                Column(
                  children: futureEvents.map((event) => _buildEventCard(event)).toList(),
                )
              else
                const Text('Nenhum evento confirmado.', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: event['imageUrl'] != null && event['imageUrl'].isNotEmpty
                    ? Image.network(
                        event['imageUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error_outline, color: Colors.grey),
                      )
                    : const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['eventTitle'] ?? 'Evento sem título',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Data: ${_formatDate(event['eventDate'])}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Local: ${event['eventLocation'] ?? 'Desconhecido'}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dateTime = DateTime.parse(iso);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (_) {
      return iso;
    }
  }
}