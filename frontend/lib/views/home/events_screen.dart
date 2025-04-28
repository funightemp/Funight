import 'package:flutter/material.dart';
import 'package:frontend/views/events/event_card.dart'; // Importa o EventCard

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // Lista de eventos de exemplo (para visualização)
  final List<Map<String, dynamic>> _eventos = [
    {
      'title': 'Concerto de Rock',
      'imageUrl': 'https://via.placeholder.com/150', // URL de exemplo
      'date': '2024-07-20',
      'location': 'Estádio Nacional',
      'price': 25.00,
      'description': 'Um super concerto com as melhores bandas de rock!',
    },
    {
      'title': 'Festa Eletrónica',
      'imageUrl': 'https://via.placeholder.com/150', // URL de exemplo
      'date': '2024-07-25',
      'location': 'Club A',
      'price': 15.00,
      'description': 'A melhor festa de música eletrónica da cidade.',
    },
    {
      'title': 'Noite de Fado',
      'imageUrl': '', // Sem imagem
      'date': '2024-07-28',
      'location': 'Casa de Fados',
      'price': null, // Gratuito
      'description': 'Uma noite inesquecível com a alma do fado.',
    },
    {
      'title': 'Festival de Verão',
      'imageUrl': 'https://via.placeholder.com/150', // URL de exemplo
      'date': '2024-08-10',
      'location': 'Parque da Cidade',
      'price': 50.00,
      'description': 'O maior festival de verão com diversas atrações.',
    },
  ];

  // Cores consistentes com o tema (substitua com suas cores reais)
  final Color _backgroundColor = const Color(0xFF121212); // Cor de fundo escura
  final Color _primaryColor = const Color(0xFFBB86FC); // Cor primária (ex: roxo)
  final Color _textColor = Colors.white; // Cor do texto
  final Color _cardColor = const Color(0xFF1E1E1E); // Cor dos cards

  // Controlador para a barra de pesquisa
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor, // Aplica a cor de fundo
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: _textColor),
                    decoration: InputDecoration(
                      hintText: 'Pesquisar eventos ou localização...',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // TODO: Implementar a lógica para obter a localização do dispositivo
                    print('Obter localização do dispositivo');
                  },
                  icon: Icon(Icons.location_on, color: _primaryColor),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _eventos.length,
              itemBuilder: (context, index) {
                final evento = _eventos[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: EventCard( // Usa o EventCard
                    title: evento['title'],
                    imageUrl: evento['imageUrl'],
                    date: evento['date'],
                    location: evento['location'],
                    price: evento['price'],
                    description: evento['description'],
                    backgroundColor: _cardColor, // Passa a cor do card
                    textColor: _textColor,
                    primaryColor: _primaryColor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

