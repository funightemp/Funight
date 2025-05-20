import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQRCodeScreen extends StatelessWidget {
  final String ticketId;

  const TicketQRCodeScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bilhete Gerado"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: ticketId,
              version: QrVersions.auto,
              size: 250.0,
            ),
            const SizedBox(height: 20),
            Text("Ticket ID:", style: TextStyle(fontSize: 16)),
            Text(ticketId,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}