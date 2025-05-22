import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/social/friend_profile_screen.dart';
import 'package:frontend/views/social/friend_profile_screen.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _nonFriends = [];

  @override
  void initState() {
    super.initState();
    _loadNonFriends();
  }

  Future<void> _loadNonFriends() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final allUsersSnapshot = await _firestore.collection('users').get();
    final friendsSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('friends')
        .get();

    final friendIds = friendsSnapshot.docs.map((doc) => doc.id).toSet();

    final nonFriends = allUsersSnapshot.docs
        .where((doc) => doc.id != user.uid && !friendIds.contains(doc.id))
        .map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'username': data['name'] ?? 'Sem nome',
        'avatarUrl': data['photoUrl'] ?? '',
      };
    }).toList();

    setState(() => _nonFriends = nonFriends);
  }

  Future<void> _addFriend(String friendId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final alreadyFriend = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('friends')
          .doc(friendId)
          .get();

      if (alreadyFriend.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Já são amigos.')),
        );
        return;
      }

      // Adiciona nas duas direções
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('friends')
          .doc(friendId)
          .set({});
      await _firestore
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(user.uid)
          .set({});

      // Cria notificação
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();
      final fromUserName = userData?['name'] ?? 'Utilizador';

      await _firestore
          .collection('users')
          .doc(friendId)
          .collection('notifications')
          .add({
        'type': 'follow',
        'fromUserId': user.uid,
        'fromUserName': fromUserName,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'read': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amigo adicionado!')),
      );

      Navigator.pop(context, true); // Sinaliza sucesso

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar: $e')),
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
        title: const Text('Adicionar Amigo', style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _nonFriends.isEmpty
            ? const Center(
                child: Text(
                  'Sem utilizadores disponíveis para adicionar.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: _nonFriends.length,
                itemBuilder: (context, index) {
                  final user = _nonFriends[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FriendProfileScreen(friendId: user['id']),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: user['avatarUrl'].isNotEmpty
                          ? NetworkImage(user['avatarUrl'])
                          : null,
                      child: user['avatarUrl'].isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(user['username'], style: const TextStyle(color: textColor)),
                    trailing: IconButton(
                      icon: const Icon(Icons.person_add, color: Colors.green),
                      onPressed: () async {
                        await _addFriend(user['id']);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}