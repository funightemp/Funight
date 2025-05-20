import 'package:flutter/material.dart';
import 'package:frontend/models/event.dart';
import 'package:frontend/services/ticket_service.dart';
import 'package:frontend/views/events/events_detail.dart';
import 'package:frontend/views/tickets/ticket_card.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final Color backgroundColor;
  final Color textColor;
  final Color primaryColor;
  final bool showTicketOwned;

  const EventCard({
    super.key,
    required this.event,
    required this.backgroundColor,
    required this.textColor,
    required this.primaryColor,
    required this.showTicketOwned,
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
                  child: event.imageUrl.isNotEmpty
                      ? Image.network(
                          event.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error_outline, color: Colors.grey),
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
                      'Data: ${event.date}',
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Local: ${event.location}',
                      style: TextStyle(fontSize: 14, color: textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      showTicketOwned
                          ? 'Bilhete já comprado'
                          : (event.price != null
                              ? 'Preço: ${event.price!.toStringAsFixed(2)} €'
                              : 'Grátis'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: showTicketOwned ? Colors.orange : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              // Botão de compra de bilhete
              if (!showTicketOwned)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      final ticketId = generateTicketId();
                      final qrCodeData = 'ticket:$ticketId:user:${event.userId}'; // opcional

                      await saveTicketToFirestore(
                        ticketId: ticketId,
                        qrCodeData: qrCodeData,
                        eventId: event.eventId,
                        eventTitle: event.title,
                        eventDate: event.date,
                        eventLocation: event.location,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketDetailsScreen(
                            title: event.title,
                            eventDate: event.date,
                            eventLocation: event.location,
                            ticketNumber: ticketId,
                            qrCodeData: qrCodeData,
                            backgroundColor: backgroundColor,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Bilhete'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEventDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(
          eventId: event.eventId,
          title: event.title,
          imageUrl: event.imageUrl,
          date: event.date,
          location: event.location,
          price: event.price,
          description: event.description,
          latitude: event.latitude,
          longitude: event.longitude,
          backgroundColor: backgroundColor,
          textColor: textColor,
          primaryColor: primaryColor,
        ),
      ),
    );
  }
}