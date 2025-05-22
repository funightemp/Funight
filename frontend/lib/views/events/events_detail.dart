import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/views/tickets/ticket_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/services/ticket_service.dart';

class EventDetailsScreen extends StatefulWidget {
  final String title;
  final String eventId;
  final String? imageUrl;
  final String date;
  final String location;
  final double? price;
  final String? description;
  final double? latitude;
  final double? longitude;
  final Color backgroundColor;
  final Color textColor;
  final Color primaryColor;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.title,
    this.imageUrl,
    required this.date,
    required this.location,
    this.price,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.backgroundColor,
    required this.textColor,
    required this.primaryColor,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool _hasTicket = false;
  Map<String, dynamic>? _ticketData;

  @override
  void initState() {
    super.initState();
    _checkIfUserHasTicket();
  }

  Future<void> _checkIfUserHasTicket() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ticketsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tickets');

    final query = await ticketsRef
        .where('eventId', isEqualTo: widget.eventId)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      setState(() {
        _hasTicket = true;
        _ticketData = query.docs.first.data();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: widget.textColor)),
        backgroundColor: widget.backgroundColor,
        iconTheme: IconThemeData(color: widget.textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Imagem do evento
              _buildImage(),

              const SizedBox(height: 20),

              /// Título
              Text(widget.title,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor)),

              const SizedBox(height: 10),

              /// Data e Local
              Row(
                children: [
                  Icon(Icons.calendar_today, color: widget.textColor, size: 20),
                  const SizedBox(width: 6),
                  Text('Data: ${formatDate(widget.date)}',
                      style: TextStyle(color: widget.textColor)),
                  const SizedBox(width: 20),
                  Icon(Icons.location_on, color: widget.textColor, size: 20),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Local: ${widget.location}',
                      style: TextStyle(color: widget.textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// Preço
              Text(
                widget.price != null
                    ? 'Preço: ${widget.price!.toStringAsFixed(2)} €'
                    : 'Grátis',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500, color: Colors.green),
              ),

              const SizedBox(height: 20),

              /// Descrição
              Text(
                widget.description ?? 'Nenhuma descrição disponível.',
                style: TextStyle(fontSize: 16, color: widget.textColor),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 30),

              /// Botão principal
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_hasTicket && _ticketData != null) {
                      // Abrir bilhete existente
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketDetailsScreen(
                            title: widget.title,
                            eventDate: widget.date,
                            eventLocation: widget.location,
                            ticketNumber: _ticketData!['ticketId'],
                            qrCodeData: _ticketData!['qrCodeData'],
                            backgroundColor: widget.backgroundColor,
                            textColor: widget.textColor,
                            primaryColor: widget.primaryColor,
                          ),
                        ),
                      );
                    } else {
                      // Criar novo bilhete
                      final ticketId = generateTicketId();

                      await saveTicketToFirestore(
                        ticketId: ticketId,
                        qrCodeData: ticketId,
                        eventId: widget.eventId,
                        eventTitle: widget.title,
                        eventDate: widget.date,
                        eventLocation: widget.location,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketDetailsScreen(
                            title: widget.title,
                            eventDate: widget.date,
                            eventLocation: widget.location,
                            ticketNumber: ticketId,
                            qrCodeData: ticketId,
                            backgroundColor: widget.backgroundColor,
                            textColor: widget.textColor,
                            primaryColor: widget.primaryColor,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: widget.textColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(_hasTicket ? 'Ver Bilhete' : 'Comprar Bilhete'),
                ),
              ),

              const SizedBox(height: 16),

              /// Botão direções
              ElevatedButton.icon(
                icon: const Icon(Icons.directions),
                label: const Text("Obter Direções"),
                onPressed: () => _openMaps(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor,
                  foregroundColor: widget.textColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return const Image(
        image: AssetImage('assets/event_placeholder.png'),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      );
    }

    return FutureBuilder<Uint8List?>(
      future: _fetchImageWithAuth(widget.imageUrl!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return const SizedBox(
            height: 200,
            child: Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
          );
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          );
        }
      },
    );
  }

  String formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (_) {
      return isoDate;
    }
  }

  void _openMaps(BuildContext context) async {
    if (widget.latitude == null || widget.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Este evento não tem localização definida.")),
      );
      return;
    }

    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Não foi possível obter a sua localização.")),
      );
      return;
    }

    final origin = '${position.latitude},${position.longitude}';
    final destination = '${widget.latitude},${widget.longitude}';
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Não foi possível abrir o Google Maps.")),
      );
    }
  }

  Future<Uint8List?> _fetchImageWithAuth(String url) async {
    const username = 'webdav-user';
    const password = 'NOXtuga21!';
    final authHeader = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': authHeader},
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Erro ao buscar imagem: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro ao carregar imagem: $e');
      return null;
    }
  }
}