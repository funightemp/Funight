import 'package:flutter/material.dart';
import 'package:frontend/views/tickets/ticket_card.dart'; // Importe o TicketCard

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Cores consistentes com o tema
  final Color _backgroundColor = const Color(0xFF121212);
  final Color _primaryColor = const Color(0xFFBB86FC);
  final Color _textColor = Colors.white;
  final Color _accentColor = const Color(0xFF03DAC6); // Cor de destaque

  // Lista de tickets de exemplo (substitua com seus dados reais)
  final List<Map<String, dynamic>> _ticketsFuturos = [
    {
      'id': '1',
      'title': 'Concerto de Rock Futuro',
      'date': '2024-08-15',
      'location': 'Estádio da Luz',
      'ticketNumber': '12345',
      'qrCodeData': 'https://example.com/ticket/12345', // Adicione dados do QR Code
    },
    {
      'id': '2',
      'title': 'Peça de Teatro Futura',
      'date': '2024-09-20',
      'location': 'Teatro Nacional',
      'ticketNumber': '67890',
      'qrCodeData': 'https://example.com/ticket/67890',
    },
  ];

  final List<Map<String, dynamic>> _ticketsPassados = [
    {
      'id': '3',
      'title': 'Concerto de Rock Passado',
      'date': '2024-07-10',
      'location': 'Coliseu',
      'ticketNumber': '24680',
      'qrCodeData': 'https://example.com/ticket/24680',
    },
    {
      'id': '4',
      'title': 'Exposição de Arte Passada',
      'date': '2024-06-01',
      'location': 'Museu Nacional',
      'ticketNumber': '13579',
      'qrCodeData': 'https://example.com/ticket/13579',
    },
  ];

  final List<Map<String, dynamic>> _ticketsDecorrer = [
    {
      'id': '5',
      'title': 'Festival de Verão',
      'date': '2024-07-28', // Data de hoje
      'location': 'Parque da Cidade',
      'ticketNumber': '98765',
      'qrCodeData': 'https://example.com/ticket/98765',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showTicketDetails(BuildContext context, Map<String, dynamic> ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketDetailsScreen(
          title: ticket['title'],
          eventDate: ticket['date'],
          eventLocation: ticket['location'],
          ticketNumber: ticket['ticketNumber'],
          qrCodeData: ticket['qrCodeData'],
          backgroundColor: _backgroundColor,
          textColor: _textColor,
          primaryColor: _primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: Text('Meus Bilhetes', style: TextStyle(color: _textColor)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _accentColor,
          labelColor: _textColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Futuros'),
            Tab(text: 'A Decorrer'),
            Tab(text: 'Passados'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Bilhetes Futuros
          _buildTicketList(_ticketsFuturos),
          // Bilhetes A Decorrer
          _buildTicketList(_ticketsDecorrer),
          // Bilhetes Passados
          _buildTicketList(_ticketsPassados),
        ],
      ),
    );
  }

  // Widget para construir a lista de tickets
  Widget _buildTicketList(List<Map<String, dynamic>> tickets) {
    if (tickets.isEmpty) {
      return Center(
        child: Text(
          'Não há bilhetes para exibir nesta secção.',
          style: TextStyle(color: _textColor),
        ),
      );
    }
    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return GestureDetector( // Envolva o TicketCard com um GestureDetector
          onTap: () {
            _showTicketDetails(context, ticket); // Navega para a tela de detalhes
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: TicketCard( // Use o TicketCard
              title: ticket['title'],
              eventDate: ticket['date'],
              eventLocation: ticket['location'],
              ticketNumber: ticket['ticketNumber'],
              qrCodeData: ticket['qrCodeData'], // Passe os dados do QR Code
              backgroundColor: const Color(0xFF1E1E1E),
              textColor: _textColor,
              primaryColor: _primaryColor,
            ),
          ),
        );
      },
    );
  }
}

