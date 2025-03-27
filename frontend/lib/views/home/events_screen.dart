import 'package:flutter/material.dart';
import 'package:frontend/views/profile/profile_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  int _selectedIndex = 0;
  final List<String> categories = ["All", "Entertainment", "Fitness & Health"];
  String selectedCategory = "All";

  final List<Map<String, dynamic>> events = [
    {
      "title": "Spa - 50%",
      "location": "Luxury Resort",
      "time": "2PM - 4PM",
      "image": "assets/placeholder_funight.png",
      "favorite": false,
    },
    {
      "title": "Concert with a Band",
      "location": "Downtown Arena",
      "time": "7PM",
      "image": "assets/placeholder_funight.png",
      "favorite": false,
    },
    {
      "title": "Rock on the Beach",
      "location": "A Beach Bar",
      "time": "10PM",
      "image": "assets/placeholder_funight.png",
      "favorite": false,
    },
    {
      "title": "Tennis Tournament",
      "location": "City Court",
      "time": "11AM",
      "image": "assets/placeholder_funight.png",
      "favorite": true,
    },
  ];

  void _toggleFavorite(int index) {
    setState(() {
      events[index]["favorite"] = !events[index]["favorite"];
    });
  }

  void _onItemTapped(int index) {
    if (index == 4) {
      // Redireciona para a página de perfil
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Event",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF9747FF)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filtros de categorias
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children:
                  categories.map((category) {
                    bool isSelected = category == selectedCategory;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Color(0xFF9747FF) : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              "Wednesday, 6th of August",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Row(
                    children: [
                      // Imagem do evento
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          event["image"],
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),

                      // Informações do evento
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event["title"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${event["location"]} • ${event["time"]}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Botão de favorito
                      IconButton(
                        icon: Icon(
                          event["favorite"]
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              event["favorite"]
                                  ? Color(0xFF9747FF)
                                  : Colors.white70,
                        ),
                        onPressed: () => _toggleFavorite(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar corrigida
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Fundo preto
        selectedItemColor: Color(0xFF9747FF),
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Para manter a cor correta
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Event"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Food"),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: "Deals",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "VIP"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ), // Ícone de perfil
        ],
      ),
    );
  }
}
