import 'package:flutter/material.dart';

class AddFriendScreen extends StatefulWidget {
  // Cores consistentes com o tema
  final Color _backgroundColor = const Color(0xFF121212);
  final Color _textColor = Colors.white;
  final Color _primaryColor = const Color(0xFFBB86FC);

  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  // Lista de usuários de exemplo (substitua com seus dados reais)
  final List<Map<String, dynamic>> _users = [
    {
      'id': 'user1',
      'username': 'Amigo1',
      'avatarUrl': 'https://via.placeholder.com/40',
      'bio': 'Fã de eventos desde sempre!',
    },
    {
      'id': 'user2',
      'username': 'Amigo2',
      'avatarUrl': 'https://via.placeholder.com/40',
      'bio': 'Adoro concertos e festivais.',
    },
    {
      'id': 'user3',
      'username': 'Maria3',
      'avatarUrl': 'https://via.placeholder.com/40',
      'bio': 'Apaixonada por música ao vivo.',
    },
    {
      'id': 'user4',
      'username': 'Carlos4',
      'avatarUrl': 'https://via.placeholder.com/40',
      'bio': 'Sempre à procura de novos eventos.',
    },
    {
      'id': 'user5',
      'username': 'Amigo5',
      'avatarUrl': 'https://via.placeholder.com/40',
      'bio': 'Gosto de todo o tipo de eventos.',
    },
  ];

  // Lista de usuários filtrados
  List<Map<String, dynamic>> _filteredUsers = [];

  // Controlador para o campo de pesquisa
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredUsers = List.from(_users); // Inicialmente, todos os usuários são exibidos
  }

  // Método para filtrar usuários com base no texto da pesquisa
  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = List.from(_users); // Se a pesquisa estiver vazia, mostra todos
      } else {
        _filteredUsers = _users.where((user) {
          return user['username'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget._backgroundColor,
      appBar: AppBar(
        title: Text('Adicionar Amigo', style: TextStyle(color: widget._textColor)),
        backgroundColor: widget._backgroundColor,
        iconTheme: IconThemeData(color: widget._textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              style: TextStyle(color: widget._textColor),
              decoration: InputDecoration(
                labelText: 'Pesquisar por nome',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: widget._primaryColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: _filterUsers, // Chama o método de filtragem ao digitar
            ),
            const SizedBox(height: 20.0),
            Expanded(
              // Use Expanded para que o ListView.builder ocupe o espaço restante
              child: _buildUserList(), // Exibe a lista de usuários filtrados
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir a lista de usuários
  Widget _buildUserList() {
  if (_filteredUsers.isEmpty) {
    return Center(
      child: Text(
        'Nenhum usuário encontrado.',
        style: TextStyle(color: widget._textColor),
      ),
    );
  }
    return ListView.builder(
      itemCount: _filteredUsers.length,
      itemBuilder: (context, index) {
        final user = _filteredUsers[index];
        return _buildUserCard(context, user);
      },
    );
  }

  // Método para construir o card de cada usuário
  Widget _buildUserCard(BuildContext context, Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      color: const Color(0xFF1E1E1E), // Cor dos cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user['avatarUrl']),
              radius: 25,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['username'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget._textColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user['bio'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget._primaryColor, // Cor de fundo do botão
                foregroundColor: widget._textColor, // Cor do texto do botão
              ),
              onPressed: () {
                // TODO: Implementar a lógica para adicionar amigo
                print('Adicionar amigo ${user['username']}');
                 showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pedido Enviado'),
                    content: Text('Pedido de amizade enviado para ${user['username']}!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                           Navigator.of(context).pop();
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}

