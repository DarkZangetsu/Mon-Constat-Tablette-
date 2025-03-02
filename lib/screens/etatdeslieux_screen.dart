import 'package:constat/screens/creeretatdeslieux_screen.dart';
import 'package:flutter/material.dart';

class EtatDesLieuxScreen extends StatelessWidget {
  const EtatDesLieuxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'États des lieux',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 100,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                'Accueil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to home screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Déconnexion',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle logout logic
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Blue button for "Nouvel état des lieux"
          Container(
            margin: const EdgeInsets.all(16),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Naviguer vers l'écran de création d'état des lieux
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreerEtatDesLieuxScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0277BD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Nouvel état des lieux',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Yellow notification container
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9C4), // Light yellow
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "Il n'y a pas d'état des lieux à lister",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 4,
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                color: Colors.blue,
              ),
            ),
            Expanded(
              flex: 90,
              child: Container(
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}