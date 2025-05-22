import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Importe o pacote para gerar QR Codes

class TicketCard extends StatelessWidget {
  final String title;
  final String eventDate;
  final String eventLocation;
  final String ticketNumber;
  final String? qrCodeData; // String para armazenar os dados do QR Code
  final Color backgroundColor;
  final Color textColor;
  final Color primaryColor;

  const TicketCard({
    super.key,
    required this.title,
    required this.eventDate,
    required this.eventLocation,
    required this.ticketNumber,
    this.qrCodeData, // Torna o qrCodeData opcional
    required this.backgroundColor,
    required this.textColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      color: backgroundColor, // Usa a cor de fundo do card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor, // Usa a cor do texto
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Data: ${formatDate(eventDate)}',
              style: TextStyle(
                fontSize: 14,
                color: textColor,
              ), // Usa a cor do texto
            ),
            const SizedBox(height: 8),
            Text(
              'Local: $eventLocation',
              style: TextStyle(
                fontSize: 14,
                color: textColor,
              ), // Usa a cor do texto
            ),
            const SizedBox(height: 8),
            Text(
              'Bilhete Nº: $ticketNumber',
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ), // Usa a cor do texto
            ),
            const SizedBox(height: 16),
            // Exibe o QR Code se os dados estiverem disponíveis
            if (qrCodeData != null && qrCodeData!.isNotEmpty)
              Center(
                child: QrImageView(
                  data: qrCodeData!, // Usa os dados do QR Code
                  version: QrVersions.auto,
                  size: 150,
                  foregroundColor:
                      textColor, // Usa a cor do texto para o QR Code
                  backgroundColor: backgroundColor,
                  errorCorrectionLevel: QrErrorCorrectLevel.L,
                ),
              )
            else
              const Center(
                child: Text(
                  'QR Code não disponível',
                  style: TextStyle(color: Colors.grey),
                ),
              ), // Mensagem caso não haja QR Code
          ],
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

// Novo componente para a tela de detalhes do Ticket
class TicketDetailsScreen extends StatelessWidget {
  final String title;
  final String eventDate;
  final String eventLocation;
  final String ticketNumber;
  final String? qrCodeData;
  final Color backgroundColor;
  final Color textColor;
  final Color primaryColor;

  const TicketDetailsScreen({
    super.key,
    required this.title,
    required this.eventDate,
    required this.eventLocation,
    required this.ticketNumber,
    this.qrCodeData,
    required this.backgroundColor,
    required this.textColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Detalhes do Bilhete', style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Data do Evento: ${formatDate(eventDate)}',
                style: TextStyle(fontSize: 18, color: textColor),
              ),
              const SizedBox(height: 10),
              Text(
                'Local do Evento: $eventLocation',
                style: TextStyle(fontSize: 18, color: textColor),
              ),
              const SizedBox(height: 10),
              Text(
                'Número do Bilhete: $ticketNumber',
                style: TextStyle(fontSize: 20, color: textColor),
              ),
              const SizedBox(height: 20),
              if (qrCodeData != null && qrCodeData!.isNotEmpty)
                Center(
                  child: QrImageView(
                    data: qrCodeData!,
                    version: QrVersions.auto,
                    size: 300,
                    foregroundColor: textColor,
                    backgroundColor: backgroundColor,
                    errorCorrectionLevel: QrErrorCorrectLevel.L,
                  ),
                )
              else
                const Center(
                  child: Text(
                    'QR Code não disponível',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ),
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
}
