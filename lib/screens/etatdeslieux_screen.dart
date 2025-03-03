import 'package:flutter/material.dart';
import '../constants/status_constants.dart';
import '../db/database_helper.dart';
import '../models/models.dart';
import 'creeretatdeslieux_screen.dart';


class EtatDesLieuxScreen extends StatefulWidget {
  const EtatDesLieuxScreen({Key? key}) : super(key: key);

  @override
  State<EtatDesLieuxScreen> createState() => _EtatDesLieuxScreenState();
}

class _EtatDesLieuxScreenState extends State<EtatDesLieuxScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isLoading = true;
  List<EtatDesLieux> _etatDesLieuxList = [];

  @override
  void initState() {
    super.initState();
    _loadEtatDesLieux();
  }

  Future<void> _loadEtatDesLieux() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final etatDesLieuxData = await _dbHelper.getEtatDesLieux();
      List<EtatDesLieux> detailedList = [];

      for (var etat in etatDesLieuxData) {
        final DateTime createdAt = DateTime.parse(etat['created_at']);
        List<Section> sections = await _dbHelper.getSections(etat['id']);

        EtatDesLieux etatComplet = EtatDesLieux(
          id: etat['id'],
          title: etat['title'],
          createdAt: createdAt,
          sections: sections,
        );

        detailedList.add(etatComplet);
      }

      setState(() {
        _etatDesLieuxList = detailedList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
            fontWeight: FontWeight.w500,
            fontSize: 20,
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
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreerEtatDesLieuxScreen()),
                );

                if (result != null || result == null) {
                  _loadEtatDesLieux();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0277BD),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Nouvel état des lieux',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Liste des états des lieux ou message d'information
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF0277BD)))
                : _etatDesLieuxList.isEmpty
                ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4), // Light yellow
                borderRadius: BorderRadius.circular(4),
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
            )
                : ListView.builder(
              itemCount: _etatDesLieuxList.length,
              itemBuilder: (context, index) {
                final etat = _etatDesLieuxList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'État des lieux: ${etat.title}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // Actions
                            Row(
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    'lib/images/cloud-computing.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  onPressed: () {
                                    // Export to cloud
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: Image.asset(
                                    'lib/images/html5.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  onPressed: () {
                                    // Export to HTML
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _showDeleteConfirmation(context, etat.id!);
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Sections et Elements
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: etat.sections.map((section) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  'Section: ${section.name}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                // Elements List avec séparateurs
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(section.elements.length, (index) {
                                    final element = section.elements[index];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // L'élément lui-même
                                        Padding(
                                          padding: const EdgeInsets.only(top: 12, left: 16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                        children: [
                                                          const TextSpan(
                                                            text: 'Élément: ',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: element.name,
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          // Description in parentheses if available
                                                          if (element.description.isNotEmpty)
                                                            TextSpan(
                                                              text: ' - (${element.description})',
                                                              style: const TextStyle(
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  // Status badge if not empty, otherwise black square
                                                  if (element.status.isNotEmpty)
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 8),
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: StatusConstants.getStatusColor(element.status),
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(
                                                        element.status,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    )
                                                  else
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 8),
                                                      width: 16,
                                                      height: 16,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                    ),
                                                ],
                                              ),

                                              // Photos before audio
                                              if (element.photos.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8),
                                                  child: SizedBox(
                                                    height: 80,
                                                    child: ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: element.photos.length,
                                                      itemBuilder: (context, photoIndex) {
                                                        return Padding(
                                                          padding: const EdgeInsets.only(right: 8),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(4),
                                                            child: Image.file(
                                                              element.photos[photoIndex],
                                                              width: 80,
                                                              height: 80,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),

                                              // Audio buttons
                                              if (element.audioFiles.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8),
                                                  child: Row(
                                                    children: element.audioFiles.map((audio) {
                                                      return Padding(
                                                        padding: const EdgeInsets.only(right: 8),
                                                        child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.grey.shade300),
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          child: IconButton(
                                                            icon: const Icon(
                                                              Icons.play_arrow,
                                                              color: Colors.blue,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              // Play audio logic
                                                            },
                                                            padding: EdgeInsets.zero,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),

                                        // Séparateur entre les éléments (sauf pour le dernier)
                                        if (index < section.elements.length - 1)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                                            child: Divider(
                                              color: Colors.grey.shade300,
                                              height: 1,
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Bottom blue indicator
      bottomNavigationBar: Container(
        height: 4,
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                color: const Color(0xFF0277BD),
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

  void _showDeleteConfirmation(BuildContext context, int etatDesLieuxId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation de suppression'),
          content: const Text('Êtes-vous sûr de vouloir supprimer cet état des lieux ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _dbHelper.deleteEtatDesLieux(etatDesLieuxId);
                _loadEtatDesLieux();
              },
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}