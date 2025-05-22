import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String generateTicketId() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rand = Random.secure();
  return List.generate(10, (_) => chars[rand.nextInt(chars.length)]).join();
}

Future<void> saveTicketToFirestore({
  required String ticketId,
  required String qrCodeData,
  required String eventId,
  required String eventTitle,
  required String eventDate,
  required String eventLocation,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception("Utilizador não autenticado.");
  }

  final ticketData = {
    'ticketId': ticketId,
    'qrCodeData': qrCodeData,
    'eventId': eventId,
    'eventTitle': eventTitle,
    'eventDate': eventDate,
    'eventLocation': eventLocation,
    'createdAt': FieldValue.serverTimestamp(),
  };

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('tickets')
      .doc(ticketId)
      .set(ticketData);
}

Future<void> comprarBilhete({
  required BuildContext context,
  required String eventId,
  required String title,
  required String date,
  required String location,
}) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Utilizador não autenticado')),
      );
      return;
    }

    final ticketsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tickets');

    final existingTicket = await ticketsRef
        .where('eventId', isEqualTo: eventId)
        .get();

    if (existingTicket.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bilhete já comprado para este evento')),
      );
      return;
    }

    final ticketId = generateTicketId();
    final qrCodeData = 'ticket:$ticketId:user:${user.uid}';

    await ticketsRef.doc(ticketId).set({
      'ticketId': ticketId,
      'eventId': eventId,
      'eventTitle': title,
      'eventDate': date,
      'eventLocation': location,
      'qrCodeData': qrCodeData,
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bilhete comprado com sucesso!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao comprar bilhete: $e')),
    );
  }
}