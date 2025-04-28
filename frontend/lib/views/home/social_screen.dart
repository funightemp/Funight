import 'package:flutter/material.dart';

class SocialScreen extends StatelessWidget {
  // Cores consistentes com o tema
  final Color _backgroundColor = const Color(0xFF121212);
  final Color _textColor = Colors.white;
  final Color _primaryColor = const Color(0xFFBB86FC);

  // Lista de amigos de exemplo
  final List<Map<String, dynamic>> _friends = [
    {'id': 'user1', 'username': 'Amigo1', 'avatarUrl': 'https://via.placeholder.com/40'},
    {'id': 'user2', 'username': 'Amigo2', 'avatarUrl': 'https://via.placeholder.com/40'},
  ];

  // Lista de eventos de exemplo com amigos que vão participar
  final List<Map<String, dynamic>> _eventosAmigos = [
    {
      'id': 'event1',
      'title': 'Concerto Rock dos Amigos',
      'date': '2024-08-01',
      'location': 'Estádio Local',
      'friends': ['user1', 'user2'], // IDs dos amigos que vão
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': 'event2',
      'title': 'Festa Eletrónica Amigos',
      'date': '2024-08-10',
      'location': 'Club X',
      'friends': ['user2'],
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];

  // Lista de publicações de exemplo (agora filtrada por amigos e eventos)
  final List<Map<String, dynamic>> _posts = [
    {
      'id': '1',
      'username': 'Amigo1',
      'avatarUrl': 'https://via.placeholder.com/40',
      'content': 'A ver o concerto Rock dia 1!',
      'imageUrl': 'https://via.placeholder.com/300',
      'likes': 10,
      'comments': 2,
      'timestamp': 'Há 2 horas',
      'eventId': 'event1', // Adicionado ID do evento associado
    },
    {
      'id': '2',
      'username': 'Amigo2',
      'avatarUrl': 'https://via.placeholder.com/40',
      'content': 'Preparado para a festa eletrónica do dia 10!',
      'imageUrl': null,
      'likes': 5,
      'comments': 1,
      'timestamp': 'Há 1 dia',
      'eventId': 'event2',
    },
  ];

  // Controlador para a barra de pesquisa
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: TextStyle(color: _textColor),
          decoration: InputDecoration(
            hintText: 'Pesquisar utilizador...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none, // Remove a borda
            prefixIcon: Icon(Icons.search, color: Colors.grey),
          ),
          onChanged: (value) {
            //TODO: Implementar a lógica de pesquisa de utilizadores
            print('Pesquisar utilizador: $value');
          },
        ),
        backgroundColor: _backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              // TODO: Implementar a lógica para ir para a tela de notificações
              print('Ir para notificações');
            },
          ),
          IconButton(
            icon: const Icon(Icons.people, color: Colors.white),
            onPressed: () {
              // TODO: Implementar a lógica para ir para a tela de amigos
              print('Ir para amigos');
            },
          ),
        ],
      ),
      body: _buildEventosAmigosList(), // Mostra a lista de eventos com amigos
    );
  }

  // Método para construir a lista de eventos com amigos
  Widget _buildEventosAmigosList() {
    // Filtra os eventos com base nos amigos do utilizador
    final List<Map<String, dynamic>> eventosAmigosFiltrados = _eventosAmigos.where((evento) {
      return evento['friends'].any((friendId) => _friends.any((friend) => friend['id'] == friendId));
    }).toList();

    if (eventosAmigosFiltrados.isEmpty) {
      return Center(
        child: Text(
          'Nenhum amigo marcou presença em eventos futuros.',
          style: TextStyle(color: _textColor),
        ),
      );
    }

    return ListView.builder(
      itemCount: eventosAmigosFiltrados.length,
      itemBuilder: (context, index) {
        final evento = eventosAmigosFiltrados[index];
        // Obtém os nomes dos amigos que vão ao evento
        final List<String> amigosNoEvento = _getFriendNames(evento['friends']);

        return _buildEventoAmigosCard(context, evento, amigosNoEvento);
      },
    );
  }

  // Função auxiliar para obter os nomes dos amigos a partir dos IDs
  List<String> _getFriendNames(List<String> friendIds) {
    List<String> names = [];
    for (String id in friendIds) {
      for (var friend in _friends) {
        if (friend['id'] == id) {
          names.add(friend['username']);
          break; // Importante: sai do loop interno após encontrar o amigo
        }
      }
    }
    return names;
  }

  Widget _buildEventoAmigosCard(BuildContext context, Map<String, dynamic> evento, List<String> amigosNoEvento) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 3,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evento['title'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Data: ${evento['date']}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Local: ${evento['location']}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              'Amigos a ir: ${amigosNoEvento.join(', ')}', // Lista de amigos
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _primaryColor,
              ),
            ),
            if (evento['imageUrl'] != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  evento['imageUrl'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

