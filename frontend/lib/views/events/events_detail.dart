import 'package:flutter/material.dart';
import 'package:frontend/views/tickets/ticket_qr_code_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:frontend/services/ticket_service.dart';

class EventDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem do evento
              SizedBox(
                width: double.infinity,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      imageUrl != null && imageUrl!.isNotEmpty
                          ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                          : const Image(
                            image: AssetImage('assets/event_placeholder.png'),
                            fit: BoxFit.cover,
                          ),
                ),
              ),
              const SizedBox(height: 20),
              // Título
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              // Data e Localização
              Row(
                children: [
                  Icon(Icons.calendar_today, color: textColor, size: 20),
                  const SizedBox(width: 6),
                  Text('Data: $date', style: TextStyle(color: textColor)),
                  const SizedBox(width: 20),
                  Icon(Icons.location_on, color: textColor, size: 20),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Local: $location',
                      style: TextStyle(color: textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Preço
              Text(
                price != null
                    ? 'Preço: ${price!.toStringAsFixed(2)} €'
                    : 'Grátis',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              // Descrição
              Text(
                description ?? 'Nenhuma descrição disponível.',
                style: TextStyle(fontSize: 16, color: textColor),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 30),
              // Botão de Compra
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final ticketId = generateTicketId();

                    await saveTicketToFirestore(
                      ticketId: ticketId,
                      qrCodeData: ticketId,
                      eventId: eventId,
                      eventTitle: title,
                      eventDate: date,
                      eventLocation: location,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketQRCodeScreen(ticketId: ticketId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: textColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Comprar Bilhete'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.directions),
                  label: const Text("Obter Direções"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: textColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _openMaps(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMaps(BuildContext context) async {
    print("Latitude: $latitude, Longitude: $longitude");
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Este evento não tem localização definida."),
        ),
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
        const SnackBar(
          content: Text("Não foi possível obter a sua localização."),
        ),
      );
      return;
    }

    final origin = '${position.latitude},${position.longitude}';
    final destination = '$latitude,$longitude';

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

}
