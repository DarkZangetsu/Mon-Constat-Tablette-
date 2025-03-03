import 'dart:io';

import 'package:constat/components/blueButton.dart';
import 'package:flutter/material.dart';

import '../components/element_type_grid.dart';
import '../components/media_display.dart';
import '../components/photo_audio_button.dart';
import '../components/section_items.dart';
import '../components/status_button_row.dart';
import '../models/models.dart';

class Element {
  final String name;
  final String description;
  final String status; // NEUF, BON ÉTAT, ÉTAT D'USAGE, DÉGRADÉ
  final List<File> photos;
  final List<String> audioFiles;

  Element({
    required this.name,
    required this.description,
    required this.status,
    this.photos = const [],
    this.audioFiles = const [],
  });
}

class CreerEtatDesLieuxScreen extends StatefulWidget {
  const CreerEtatDesLieuxScreen({Key? key}) : super(key: key);

  @override
  State<CreerEtatDesLieuxScreen> createState() => _CreerEtatDesLieuxScreenState();
}

class _CreerEtatDesLieuxScreenState extends State<CreerEtatDesLieuxScreen> {
  final TextEditingController _titleController = TextEditingController(text: 'Test');
  List<Section> sections = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Créer un état des lieux',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Champ de texte pour le titre
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bouton Ajouter une section
                    BlueButton(
                      text: 'AJOUTER UNE SECTION',
                      onPressed: () {
                        _showAddSectionDialog();
                      },
                    ),

                    // Liste des sections
                    if (sections.isNotEmpty)
                      const SizedBox(height: 16),

                    Expanded(
                      child: ListView.builder(
                        itemCount: sections.length,
                        itemBuilder: (context, index) {
                          return SectionItem(
                            section: sections[index],
                            onAddElement: () {
                              _showAddElementDialog(index);
                            },
                          );
                        },
                      ),
                    ),

                    // Bouton du bas
                    BlueButton(
                      text: 'CRÉER L\'ÉTAT DES LIEUX',
                      onPressed: () {
                        // Logique pour finaliser la création
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSectionDialog() {
    TextEditingController sectionNameController = TextEditingController();
    TextEditingController sectionDescController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSectionChip('EXTÉRIEUR', sectionNameController),
                      _buildSectionChip('JARDIN', sectionNameController),
                      _buildSectionChip('DRESSING', sectionNameController),
                      _buildSectionChip('CUISINE', sectionNameController),
                      _buildSectionChip('SALON', sectionNameController),
                      _buildSectionChip('SALLE À MANGER', sectionNameController),
                      _buildSectionChip('SÉJOUR', sectionNameController),
                      _buildSectionChip('SALLE DE BAINS', sectionNameController),
                      _buildSectionChip('TOILETTES', sectionNameController),
                      _buildSectionChip('BUANDERIE', sectionNameController),
                      _buildSectionChip('CHAMBRE 1', sectionNameController),
                      _buildSectionChip('CHAMBRE 2', sectionNameController),
                      _buildSectionChip('ESCALIER', sectionNameController),
                      _buildSectionChip('CAVE', sectionNameController),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: sectionNameController,
                    decoration: const InputDecoration(
                      hintText: 'Saisissez un nom de section',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: sectionDescController,
                    decoration: const InputDecoration(
                      hintText: 'Saisissez une description de section',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlueButton(
                    text: 'CRÉER LA SECTION',
                    onPressed: () {
                      setState(() {
                        String name = sectionNameController.text.trim();
                        String description = sectionDescController.text.trim();
                        sections.add(Section(
                          name: name.isNotEmpty ? name : 'Nouvelle Section',
                          description: description,
                          elements: [],
                        ));
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionChip(String label, TextEditingController sectionNameController) {
    return InkWell(
      onTap: () {
        // Instead of creating a section directly, just fill the text field
        sectionNameController.text = label;
      },
      child: Chip(
        label: Text(label),
        backgroundColor: const Color(0xFF2196F3),
        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    );
  }

  void _showAddElementDialog(int sectionIndex) {
    TextEditingController elementNameController = TextEditingController();
    TextEditingController elementDescController = TextEditingController();
    String selectedStatus = 'NEUF';
    List<File> photos = [];
    List<String> audioFiles = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ajouter un Élément',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('Type d\'Élément:', style: TextStyle(fontSize: 14)),
                            const SizedBox(height: 10),
                            ElementTypeGrid(elementNameController: elementNameController, sectionName: '',),
                            const SizedBox(height: 16),
                            TextField(
                              controller: elementNameController,
                              decoration: const InputDecoration(
                                hintText: 'Saisissez un nom d\'élément',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: elementDescController,
                              decoration: const InputDecoration(
                                hintText: 'Saisissez la description de l\'élément',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text('État de l\'Élément:', style: TextStyle(fontSize: 14)),
                            const SizedBox(height: 10),
                            StatusButtonRow(
                              selectedStatus: selectedStatus,
                              onStatusChanged: (status) {
                                setState(() {
                                  selectedStatus = status;
                                });
                              },
                            ),
                            const SizedBox(height: 20),

                            // Media display section
                            if (photos.isNotEmpty || audioFiles.isNotEmpty)
                              MediaDisplay(
                                photos: photos,
                                audioFiles: audioFiles,
                                onDeletePhoto: (index) {
                                  setState(() {
                                    photos.removeAt(index);
                                  });
                                },
                                onDeleteAudio: (index) {
                                  setState(() {
                                    audioFiles.removeAt(index);
                                  });
                                },
                              ),

                            const SizedBox(height: 20),

                            // Photo and audio buttons
                            PhotoAudioButtons(
                              onPhotoAdded: (File photo) {
                                setState(() {
                                  photos.add(photo);
                                });
                              },
                              onAudioAdded: (String audioPath) {
                                setState(() {
                                  audioFiles.add(audioPath);
                                });
                              },
                            ),

                            const SizedBox(height: 20),
                            BlueButton(
                              text: 'AJOUTER L\'ÉLÉMENT',
                              onPressed: () {
                                this.setState(() {
                                  String name = elementNameController.text.trim();
                                  String description = elementDescController.text.trim();
                                  sections[sectionIndex].elements.add(Element(
                                    name: name.isNotEmpty ? name : 'Nouvel Élément',
                                    description: description,
                                    status: selectedStatus,
                                    photos: List.from(photos),
                                    audioFiles: List.from(audioFiles),
                                  ));
                                });
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
