import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/social/friend_profile_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('friends')
        .get();

    final friends = await Future.wait(snapshot.docs.map((doc) async {
      final friendDoc = await _firestore.collection('users').doc(doc.id).get();
      if (friendDoc.exists) {
        final data = friendDoc.data()!;
        return {
          'id': doc.id,
          'username': data['name'] ?? 'Sem nome',
          'photoBase64': data['photoBase64'] ?? '',
        };
      } else {
        return null;
      }
    }));

    setState(() => _friends = friends.whereType<Map<String, dynamic>>().toList());
  }

  Future<void> _removeFriend(String friendId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).collection('friends').doc(friendId).delete();
    await _firestore.collection('users').doc(friendId).collection('friends').doc(user.uid).delete();
    _loadFriends();
  }

  Widget _buildAvatar(String base64) {
    if (base64.isEmpty) {
      return const CircleAvatar(
        radius: 24,
        child: Icon(Icons.person, color: Colors.white),
        backgroundColor: Color(0xFF2A2A2A),
      );
    }

    try {
      final decoded = base64Decode(base64.split(',').last);
      return CircleAvatar(
        radius: 24,
        backgroundImage: MemoryImage(decoded),
        backgroundColor: const Color(0xFF2A2A2A),
      );
    } catch (_) {
      return const CircleAvatar(
        radius: 24,
        child: Icon(Icons.person, color: Colors.white),
        backgroundColor: Color(0xFF2A2A2A),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF121212);
    const textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Amigos', style: TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/add_friend');
              if (result == true) {
                _loadFriends(); // Atualiza se alguém for adicionado
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _friends.isEmpty
            ? const Center(
                child: Text(
                  'Ainda não tens amigos adicionados.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: _friends.length,
                itemBuilder: (context, index) =>
                    _buildFriendCard(_friends[index]),
              ),
      ),
    );
  }

  Widget _buildFriendCard(Map<String, dynamic> friend) {
    final String photoBase64 = friend['photoBase64'];

    return ListTile(
      leading: _buildAvatar(photoBase64),
      title: Text(friend['username'], style: const TextStyle(color: Colors.white)),
      trailing: IconButton(
        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
        onPressed: () => _removeFriend(friend['id']),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FriendProfileScreen(friendId: friend['id']),
        ),
      ),
    );
  }
}