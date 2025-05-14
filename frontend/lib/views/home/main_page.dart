import 'package:flutter/material.dart';
import 'package:frontend/views/home/events_screen.dart';
import 'package:frontend/views/tickets/tickets_screen.dart';
import 'package:frontend/views/social/social_screen.dart'; // Importa a tela social
import 'package:frontend/views/profile/profile_screen.dart'; // Importa a tela de perfil
import 'package:frontend/views/home/settings_screen.dart'; // Importa a tela de configurações

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final Color _backgroundColor = const Color(0xFF121212); // Cor de fundo

  // Lista de Widgets para cada seção
  static List<Widget> _widgetOptions = <Widget>[
    EventsScreen(),
    TicketScreen(),
    SocialScreen(), // Tela Social
    ProfileScreen(), // Tela de Perfil
    SettingsScreen(), // Tela de Configurações
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor, // Aplica a cor de fundo ao Scaffold
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF9747FF), // Cor primária para seleção
        unselectedItemColor: Colors.grey, // Cor para itens não selecionados
        onTap: _onItemTapped,
        backgroundColor: _backgroundColor, // Aplica a cor de fundo à BottomNavigationBar
      ),
    );
  }
}

