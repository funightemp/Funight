import 'package:flutter/material.dart';
import 'package:frontend/views/social/add_friend_screen.dart';

class FriendsScreen extends StatelessWidget {
  // Cores consistentes com o tema
  final Color _backgroundColor = const Color(0xFF121212);
  final Color _textColor = Colors.white;
  final Color _primaryColor = const Color(0xFFBB86FC);

  // Lista de amigos de exemplo
  final List<Map<String, String>> _friends = [
    {
      'id': '1',
      'username': 'Amigo1',
      'avatarUrl': 'https://via.placeholder.com/40',
    },
    {
      'id': '2',
      'username': 'Amigo2',
      'avatarUrl': 'https://via.placeholder.com/40',
    },
    {
      'id': '3',
      'username': 'Amigo3',
      'avatarUrl': 'https://via.placeholder.com/40',
    },
    {
      'id': '4',
      'username': 'Amigo4',
      'avatarUrl': 'https://via.placeholder.com/40',
    },
    {
      'id': '5',
      'username': 'Amigo5',
      'avatarUrl': 'https://via.placeholder.com/40',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text('Amigos', style: TextStyle(color: _textColor)),
        backgroundColor: _backgroundColor,
        iconTheme: IconThemeData(color: _textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white), // Ícone de adicionar amigo
            onPressed: () {
              // Navegar para a página de adicionar amigos (a ser criada)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFriendScreen()), // Use AddFriendScreen
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _friends.length,
        itemBuilder: (context, index) {
          final friend = _friends[index];
          return _buildFriendCard(context, friend);
        },
      ),
    );
  }

  Widget _buildFriendCard(BuildContext context, Map<String, String> friend) {
    return GestureDetector( // Envolve o Card com um GestureDetector
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FriendProfileScreen(friendId: friend['id'] ?? '1'), // Passa o ID do amigo
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        elevation: 3,
        color: const Color(0xFF1E1E1E), // Cor dos cards
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(friend['avatarUrl'] ?? 'https://via.placeholder.com/40'),
                radius: 25,
              ),
              const SizedBox(width: 10),
              Text(
                friend['username'] ?? 'Nome Desconhecido',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                  fontSize: 16,
                ),
              ),
              const Spacer(), // Adiciona espaço entre o nome e os botões
              // Removendo o ícone de chat
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () {
                  // TODO: Implementar a lógica para remover o amigo da lista
                  print('Remover amigo ${friend['username']}');
                  // Pode mostrar um diálogo de confirmação antes de remover
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Remover Amigo'),
                      content: Text('Tem certeza que deseja remover ${friend['username']} da sua lista de amigos?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(), // Fecha o diálogo
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Remover amigo da lista e atualizar a UI
                            // Você precisará ter acesso à lista de amigos aqui para fazer isso
                            // Por exemplo:
                            // setState(() {
                            //   _friends.removeWhere((f) => f['id'] == friend['id']);
                            // });
                            Navigator.of(context).pop(); // Fecha o diálogo
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('Remover'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendProfileScreen extends StatelessWidget {
  final String friendId;

  // Cores consistentes com o tema
  final Color _backgroundColor = const Color(0xFF121212);
  final Color _textColor = Colors.white;
  final Color _primaryColor = const Color(0xFFBB86FC);

  // Dados de amigos de exemplo (substitua com seus dados reais)
  final List<Map<String, dynamic>> _friends = [
    {
      'id': 'user1',
      'username': 'Amigo1',
      'avatarUrl': 'https://via.placeholder.com/100',
      'bio': 'Fã de eventos desde sempre!',
    },
    {
      'id': 'user2',
      'username': 'Amigo2',
      'avatarUrl': 'https://via.placeholder.com/100',
      'bio': 'Adoro concertos e festivais.',
    },
  ];

  // Dados de eventos de exemplo (substitua com seus dados reais)
  final List<Map<String, dynamic>> _events = [
    {
      'id': 'event1',
      'title': 'Concerto Rock',
      'date': '2024-07-20',
      'location': 'Estádio Nacional',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': 'event2',
      'title': 'Festa Eletrónica',
      'date': '2024-07-25',
      'location': 'Club A',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': 'event3',
      'title': 'Noite de Fado',
      'date': '2024-07-28',
      'location': 'Casa de Fados',
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];

  FriendProfileScreen({required this.friendId});

  @override
  Widget build(BuildContext context) {
    // Encontrar os dados do amigo com base no ID
    final friend = _friends.firstWhere((f) => f['id'] == friendId,
        orElse: () => {
              'id': 'unknown',
              'username': 'Utilizador Desconhecido',
              'avatarUrl': 'https://via.placeholder.com/100',
              'bio': 'Bio não disponível',
            });

    // Encontrar os eventos em que o amigo está confirmado
    final List<Map<String, dynamic>> friendEvents =
        _events.where((event) => event['id'] == 'event1').toList();

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(friend['username'], style: TextStyle(color: _textColor)),
        backgroundColor: _backgroundColor,
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seção de Perfil
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(friend['avatarUrl']),
                    radius: 50,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friend['username'],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          friend['bio'],
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              const SizedBox(height: 24),
              // Seção de Eventos Confirmados
              Text(
                'Próximos Eventos Confirmados:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 12),
              // Exibir a lista de eventos do amigo
              if (friendEvents.isNotEmpty)
                Column(
                  children: friendEvents.map((event) {
                    return _buildEventCard(context, event);
                  }).toList(),
                )
              else
                Text(
                  'Nenhum evento confirmado.',
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      color: const Color(0xFF1E1E1E), // Cor dos cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 100, // Largura fixa para a imagem
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  event['imageUrl'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Se a URL da imagem for inválida, mostra um ícone de erro
                    return Container(
                      color:
                          Colors.grey[800], // Cor de fundo escura para o container
                      child: const Center(
                          child: Icon(Icons.error_outline, color: Colors.grey)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Data: ${event['date']}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Local: ${event['location']}',
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
}


