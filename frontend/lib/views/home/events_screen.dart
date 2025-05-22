import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/event.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/views/events/event_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Event> _eventos = [];
  bool _isLoading = true;

  // Cores do tema
  final Color _backgroundColor = const Color(0xFF121212);
  final Color _primaryColor = const Color(0xFFBB86FC);
  final Color _textColor = Colors.white;
  final Color _cardColor = const Color(0xFF1E1E1E);

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEventos();
  }

  Future<void> fetchEventos() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/eventos'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final eventos = data.map((e) => Event.fromJson(e)).toList();

        // Obter os eventIds dos bilhetes do utilizador autenticado
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          print('Utilizador não autenticado.');
          setState(() {
            _eventos = eventos;
            _isLoading = false;
          });
          return;
        }

        final ticketSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('tickets')
            .get();

        final Set<String> userTicketEventIds = ticketSnapshot.docs
            .map((doc) => doc['eventId'].toString())
            .toSet();

        // Atualizar eventos com base na posse de bilhete
        final eventosComBilhete = eventos.map((event) {
          final hasTicket = userTicketEventIds.contains(event.id.toString());
          return event.copyWith(hasTicket: hasTicket);
        }).toList();

        setState(() {
          _eventos = eventosComBilhete;
          _isLoading = false;
        });
      } else {
        print('Erro ao carregar eventos: ${response.statusCode}');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Erro na requisição: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<Set<String>> _getUserTicketEventIds() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tickets')
        .get();

    return snapshot.docs.map((doc) => doc['eventId'].toString()).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          // Barra de pesquisa e localização
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
                    // lógica de localização
                    print('Obter localização do dispositivo');
                  },
                  icon: Icon(Icons.location_on, color: _primaryColor),
                ),
              ],
            ),
          ),

          // Lista de eventos
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _eventos.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhum evento encontrado.',
                          style: TextStyle(color: _textColor),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _eventos.length,
                        itemBuilder: (context, index) {
                          final evento = _eventos[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: EventCard(
                              event: evento,
                              backgroundColor: _cardColor,
                              textColor: _textColor,
                              primaryColor: _primaryColor,
                              hasTicket: evento.hasTicket,
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