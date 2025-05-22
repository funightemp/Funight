import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/views/social/friends_screen.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final Color _backgroundColor = const Color(0xFF121212);
  final Color _textColor = Colors.white;
  final Color _primaryColor = const Color(0xFFBB86FC);

  List<Map<String, dynamic>> _eventosAmigos = [];
  List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEventosDeAmigos();
    _loadNotifications();
  }

  Future<void> _fetchEventosDeAmigos() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final friendsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('friends')
        .get();

    final List<String> friendIds = friendsSnapshot.docs.map((doc) => doc.id).toList();

    List<Map<String, dynamic>> eventos = [];

    for (final friendId in friendIds) {
      final ticketsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .collection('tickets')
          .get();

      for (final ticket in ticketsSnapshot.docs) {
        final data = ticket.data();
 
        final friendDoc = await FirebaseFirestore.instance.collection('users').doc(friendId).get();
        final friendData = friendDoc.data();

        if (friendData == null) continue;

        eventos.add({
          'eventId': data['eventId'],
          'title': data['eventTitle'],
          'date': data['eventDate'],
          'location': data['eventLocation'],
          'imageUrl': data['imageUrl'],
          'friendId': friendId,
          'friendName': friendData['name'] ?? 'Amigo',
          'friendPhotoBase64': friendData['photoBase64'] ?? '',
        });
      }
    }

    final Map<String, Map<String, dynamic>> agrupados = {};

    for (final e in eventos) {
      final id = e['eventId'];
      if (!agrupados.containsKey(id)) {
        agrupados[id] = {
          'eventId': id,
          'title': e['title'],
          'date': e['date'],
          'location': e['location'],
          'imageUrl': e['imageUrl'],
          'friends': <Map<String, dynamic>>[],
        };
      }

      agrupados[id]!['friends'].add({
        'name': e['friendName'],
        'photoBase64': e['friendPhotoBase64'],
      });
    }

    setState(() {
      _eventosAmigos = agrupados.values.toList();
      _isLoading = false;
    });
  }

  Future<void> _loadNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .get();

    final all = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'type': data['type'],
        'fromUserName': data['fromUserName'],
        'read': data['read'] ?? false,
      };
    }).toList();

    final unread = all.where((n) => n['read'] == false).length;

    setState(() {
      _notifications = all;
      _unreadCount = unread;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Social", style: TextStyle(color: _textColor)),
        backgroundColor: _backgroundColor,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () => _showNotifications(context),
              ),
              if (_unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text('$_unreadCount', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.people, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FriendsScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _eventosAmigos.isEmpty
              ? Center(
                  child: Text(
                    'Nenhum amigo confirmou presença em eventos futuros.',
                    style: TextStyle(color: _textColor),
                  ),
                )
              : ListView.builder(
                  itemCount: _eventosAmigos.length,
                  itemBuilder: (context, index) => _buildEventoAmigoCard(_eventosAmigos[index]),
                ),
    );
  }

  Widget _buildEventoAmigoCard(Map<String, dynamic> evento) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(evento['title'] ?? 'Evento Sem Título',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor)),
            const SizedBox(height: 8),
            Text('Data: ${_formatDate(evento['date'])}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text('Local: ${evento['location'] ?? 'Não especificado'}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            if (evento['imageUrl'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  evento['imageUrl'],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            Text('Amigos a ir:', style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: List<Widget>.from(evento['friends'].map<Widget>((friend) {
                return Chip(
                  label: Text(friend['name'], style: const TextStyle(color: Colors.white)),
                  avatar: friend['photoBase64'] != null && friend['photoBase64'].toString().isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(base64Decode(friend['photoBase64'].split(',').last)))
                    : const CircleAvatar(child: Icon(Icons.person)),
                  backgroundColor: const Color(0xFF2A2A2A),
                );
              })),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNotifications(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Marcar como lidas
    final batch = FirebaseFirestore.instance.batch();
    for (var n in _notifications.where((n) => n['read'] == false)) {
      final ref = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(n['id']);
      batch.update(ref, {'read': true});
    }
    await batch.commit();
    _loadNotifications();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Notificações', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: _notifications.isEmpty
              ? const Text('Sem notificações.', style: TextStyle(color: Colors.grey))
              : ListView(
                  shrinkWrap: true,
                  children: _notifications.map((n) {
                    return ListTile(
                      leading: Icon(Icons.person, color: n['read'] ? Colors.grey : Colors.white),
                      title: Text(
                        '${n['fromUserName']} começou a seguir-te.',
                        style: TextStyle(
                          color: n['read'] ? Colors.grey : Colors.white,
                          fontWeight: n['read'] ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final notifRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('notifications');
              final snapshot = await notifRef.get();
              for (var doc in snapshot.docs) {
                await doc.reference.delete();
              }
              Navigator.of(context).pop();
              _loadNotifications();
            },
            child: const Text('Limpar todas', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return 'Desconhecida';
    try {
      final parsedDate = DateTime.parse(isoDate);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (_) {
      return isoDate;
    }
  }
}