import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/events/event_card.dart';
import 'package:frontend/models/event.dart';
import 'package:geolocator/geolocator.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final Color _backgroundColor = const Color(0xFF121212);
  final Color _primaryColor = const Color(0xFFBB86FC);
  final Color _textColor = Colors.white;
  final Color _cardColor = const Color(0xFF1E1E1E);

  final TextEditingController _searchController = TextEditingController();

  late List<Map<String, dynamic>> _eventos;
  late List<Map<String, dynamic>> _todosOsEventos;

  Set<String> _eventosComBilhete = {};
  Position? _userPosition;

  @override
  void initState() {
    super.initState();

    _todosOsEventos = [
      {
        'eventId': 'evt_rock',
        'title': 'Concerto de Rock',
        'imageUrl': 'https://via.placeholder.com/150',
        'date': '2024-07-20',
        'location': 'Estádio Nacional',
        'price': 25.00,
        'description': 'Um super concerto com as melhores bandas de rock!',
        'latitude': 38.7071,
        'longitude': -9.1974,
      },
      {
        'eventId': 'evt_eletro',
        'title': 'Festa Eletrónica',
        'imageUrl': 'https://via.placeholder.com/150',
        'date': '2024-07-25',
        'location': 'Club A',
        'price': 15.00,
        'description': 'A melhor festa de música eletrónica da cidade.',
        'latitude': 38.7169,
        'longitude': -9.1399,
      },
      {
        'eventId': 'evt_fado',
        'title': 'Noite de Fado',
        'imageUrl': '',
        'date': '2024-07-28',
        'location': 'Casa de Fados',
        'price': null,
        'description': 'Uma noite inesquecível com a alma do fado.',
        'latitude': 38.7253,
        'longitude': -9.1500,
      },
      {
        'eventId': 'evt_festival',
        'title': 'Festival de Verão',
        'imageUrl': 'https://via.placeholder.com/150',
        'date': '2024-08-10',
        'location': 'Parque da Cidade',
        'price': 50.00,
        'description': 'O maior festival de verão com diversas atrações.',
        'latitude': 38.7369,
        'longitude': -9.1426,
      },
    ];

    _eventos = List<Map<String, dynamic>>.from(_todosOsEventos);
    _searchController.addListener(_applySearchFilter);
    _fetchUserTickets(); // 👈 chama a função ao iniciar
  }

  Future<void> _fetchUserTickets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('tickets')
        .where('userId', isEqualTo: user.uid)
        .get();

    setState(() {
      _eventosComBilhete = snapshot.docs
          .map((doc) => doc['eventId'] as String)
          .toSet();
    });
  }

  void _applySearchFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _eventos = _todosOsEventos.where((evento) {
        final title = evento['title']?.toLowerCase() ?? '';
        final location = evento['location']?.toLowerCase() ?? '';
        return title.contains(query) || location.contains(query);
      }).toList();
    });
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  List<Map<String, dynamic>> _filterEventsNearby(Position userPosition) {
    return _todosOsEventos.where((event) {
      final double? lat = event['latitude'];
      final double? lon = event['longitude'];
      if (lat == null || lon == null) return false;

      final distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        lat,
        lon,
      );

      return distance <= 20000;
    }).toList();
  }

  double? _calculateDistanceTo(Position user, Map<String, dynamic> event) {
    final double? lat = event['latitude'];
    final double? lon = event['longitude'];
    if (lat == null || lon == null) return null;

    return Geolocator.distanceBetween(user.latitude, user.longitude, lat, lon) /
        1000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
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
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () async {
                    final pos = await _getCurrentLocation();
                    if (pos != null) {
                      final eventosFiltrados = _filterEventsNearby(pos);
                      setState(() {
                        _userPosition = pos;
                        _eventos = eventosFiltrados;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Não foi possível obter a localização"),
                        ),
                      );
                    }
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
                final alreadyBought = _eventosComBilhete.contains(evento['eventId']);
                final event = Event(
                  eventId: evento['eventId'],
                  title: evento['title'],
                  date: evento['date'],
                  location: evento['location'],
                  imageUrl: evento['imageUrl'],
                  price: evento['price'],
                  description: evento['description'],
                  latitude: evento['latitude'],
                  longitude: evento['longitude'],
                  userId: evento['userId'],
                );

                double? distanceKm = _userPosition != null
                    ? _calculateDistanceTo(_userPosition!, evento)
                    : null;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Stack(
                    children: [
                      EventCard(
                        event: event,
                        backgroundColor: _cardColor,
                        textColor: _textColor,
                        primaryColor: _primaryColor,
                        showTicketOwned: alreadyBought, // 👈 novo parâmetro
                      ),
                      if (distanceKm != null)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${distanceKm.toStringAsFixed(1)} km",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
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
