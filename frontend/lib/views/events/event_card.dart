import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontend/models/event.dart';
import 'package:frontend/services/ticket_service.dart';
import 'package:frontend/views/events/events_detail.dart';
import 'package:frontend/views/tickets/ticket_card.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final Color backgroundColor;
  final Color textColor;
  final Color primaryColor;
  final bool hasTicket;

  const EventCard({
    super.key,
    required this.event,
    required this.backgroundColor,
    required this.textColor,
    required this.primaryColor,
    required this.hasTicket,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showEventDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Imagem do evento
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      event.imageUrl?.isNotEmpty == true
                          ? FutureBuilder<Uint8List?>(
                              future: _fetchImageWithAuth(event.imageUrl!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError || snapshot.data == null) {
                                  return const Icon(Icons.error_outline, color: Colors.grey);
                                } else {
                                  return Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                  );
                                }
                              },
                            )
                          : const Image(
                            image: AssetImage('assets/event_placeholder.png'),
                            fit: BoxFit.cover,
                          ),
                ),
              ),
              const SizedBox(width: 10),

              // Informações do evento
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Data: ${formatDate(event.date)}',
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Local: ${event.location ?? "Não especificado"}',
                      style: TextStyle(fontSize: 14, color: textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      hasTicket
                          ? 'Bilhete já comprado'
                          : (event.price != null
                              ? 'Preço: ${event.price!.toStringAsFixed(2)} €'
                              : 'Grátis'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: hasTicket ? Colors.orange : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              // Botão de compra de bilhete
              if (!hasTicket)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (hasTicket) {
                        // Ver bilhete
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicketDetailsScreen(
                              title: event.title,
                              eventDate: formatDate(event.date),
                              eventLocation: event.location ?? '',
                              ticketNumber: 'N/A',
                              qrCodeData: 'ticket:${event.id}',
                              backgroundColor: backgroundColor,
                              textColor: textColor,
                              primaryColor: primaryColor,
                            ),
                          ),
                        );
                      } else {
                        // Ver evento
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailsScreen(
                              eventId: event.id.toString(),
                              title: event.title,
                              imageUrl: event.imageUrl ?? '',
                              date: event.date,
                              location: event.location ?? '',
                              price: event.price,
                              description: event.description ?? '',
                              latitude: event.latitude,
                              longitude: event.longitude,
                              backgroundColor: backgroundColor,
                              textColor: textColor,
                              primaryColor: primaryColor,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(hasTicket ? 'Ver Bilhete' : 'Ver Evento'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List?> _fetchImageWithAuth(String url) async {
    const username = 'webdav-user';
    const password = 'NOXtuga21!';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': basicAuth},
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Erro ao carregar imagem: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar imagem: $e');
      return null;
    }
  }

  void _showEventDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EventDetailsScreen(
              eventId: event.id.toString(),
              title: event.title,
              imageUrl: event.imageUrl ?? '',
              date: event.date,
              location: event.location ?? '',
              price: event.price,
              description: event.description ?? '',
              latitude: event.latitude,
              longitude: event.longitude,
              backgroundColor: backgroundColor,
              textColor: textColor,
              primaryColor: primaryColor,
            ),
      ),
    );
  }

  String formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }

}


class ConfirmedEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final Color backgroundColor;
  final Color textColor;

  const ConfirmedEventCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.backgroundColor,
    required this.textColor,
  });

  String formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
            const SizedBox(height: 8),
            Text('Data: ${formatDate(date)}',
                style: TextStyle(color: textColor)),
            const SizedBox(height: 4),
            Text('Local: $location', style: TextStyle(color: textColor)),
          ],
        ),
      ),
    );
  }
}