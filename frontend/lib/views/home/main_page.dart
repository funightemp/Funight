import 'package:flutter/material.dart';
import 'package:frontend/views/events/events_screen.dart';
import 'package:frontend/views/tickets/tickets_screen.dart';
import 'package:frontend/views/social/social_screen.dart';
import 'package:frontend/views/profile/profile_screen.dart';
import 'package:frontend/views/home/settings_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final Color _backgroundColor = const Color(0xFF121212);

  static final List<Widget> _widgetOptions = <Widget>[
    EventsScreen(),
    TicketScreen(),
    SocialScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        // Evita que conteúdo fique debaixo da barra de status / notch
        top: true,
        bottom: false,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: const Border(
            top: BorderSide(color: Colors.grey, width: 0.2),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: _backgroundColor,
          selectedItemColor: const Color(0xFF9747FF),
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Eventos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: 'Bilhetes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Social',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Definições',
            ),
          ],
        ),
      ),
    );
  }
}