import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/tickets/ticket_card.dart';
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

  List<Map<String, dynamic>> _ticketsFuturos = [];
  List<Map<String, dynamic>> _ticketsPassados = [];
  List<Map<String, dynamic>> _ticketsDecorrer = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchUserTickets(); // chama a função aqui
  }

  Future<void> _fetchUserTickets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tickets')
        .get();

    final List<Map<String, dynamic>> futuros = [];
    final List<Map<String, dynamic>> passados = [];
    final List<Map<String, dynamic>> aDecorrer = [];

    final now = DateTime.now();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final dateStr = data['eventDate'] ?? '';
      final eventDate = DateTime.tryParse(dateStr);

      if (eventDate == null) continue;

      final ticket = {
        'id': doc.id,
        'title': data['eventTitle'],
        'date': dateStr,
        'location': data['eventLocation'],
        'ticketNumber': data['ticketId'],
        'qrCodeData': data['qrCodeData'],
      };

      if (eventDate.isAfter(now)) {
        futuros.add(ticket);
      } else if (eventDate.year == now.year &&
          eventDate.month == now.month &&
          eventDate.day == now.day) {
        aDecorrer.add(ticket);
      } else {
        passados.add(ticket);
      }
    }

    setState(() {
      _ticketsFuturos = futuros;
      _ticketsDecorrer = aDecorrer;
      _ticketsPassados = passados;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showTicketDetails(BuildContext context, Map<String, dynamic> ticket) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => TicketDetailsScreen(
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
        return GestureDetector(
          // Envolva o TicketCard com um GestureDetector
          onTap: () {
            _showTicketDetails(
              context,
              ticket,
            ); // Navega para a tela de detalhes
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: TicketCard(
              // Use o TicketCard
              title: ticket['title'],
              eventDate: ticket['date'],
              eventLocation: ticket['location'],
              ticketNumber: ticket['ticketNumber'],
              qrCodeData: ticket['qrCodeData'],
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
