import 'dart:io';

import 'package:constat/components/blueButton.dart';
import 'package:constat/components/drawer.dart';
import 'package:flutter/material.dart';

import '../components/element_type_grid.dart';
import '../components/media_display.dart';
import '../components/photo_audio_button.dart';
import '../components/section_items.dart';
import '../components/status_button_row.dart';
import '../constants/section_types.dart';
import '../db/database_helper.dart';
import '../models/models.dart';


class CreerEtatDesLieuxScreen extends StatefulWidget {
  const CreerEtatDesLieuxScreen({super.key});

  @override
  State<CreerEtatDesLieuxScreen> createState() => _CreerEtatDesLieuxScreenState();
}

class _CreerEtatDesLieuxScreenState extends State<CreerEtatDesLieuxScreen> {
  final TextEditingController _titleController = TextEditingController(text: 'Test');
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Section> sections = [];
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          'Créer un état des lieux',
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: const AppDrawer(),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                      text: _isSaving ? 'SAUVEGARDE EN COURS...' : 'CRÉER L\'ÉTAT DES LIEUX',
                      onPressed: _isSaving ? () {} : _showConfirmationDialog,
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

  // Dialog de confirmation pour la création de l'état des lieux
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Voulez-vous vraiment créer cet état des lieux ?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () {
                Navigator.of(context).pop();
                _saveEtatDesLieux();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveEtatDesLieux() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir un titre pour l\'état des lieux')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Insérer l'état des lieux et récupérer son ID
      int etatDesLieuxId = await _dbHelper.insertEtatDesLieux(_titleController.text.trim());


      // Enregistrer chaque section
      for (var section in sections) {
        int sectionId = await _dbHelper.insertSection(etatDesLieuxId, section);

        // Enregistrer chaque élément de la section
        for (var element in section.elements) {
          await _dbHelper.insertElement(sectionId, element);
        }
      }

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('État des lieux enregistré avec succès!')),
      );

      // Rediriger vers la liste des états des lieux ou fermer cette page
      Navigator.pop(context);
    } catch (e) {
      // Afficher une erreur si quelque chose ne va pas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sauvegarde: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
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
                    children: SectionTypes.allSections.map((sectionName) =>
                        _buildSectionChip(sectionName, sectionNameController)
                    ).toList(),
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
                      _showConfirmSectionDialog(context, sectionNameController, sectionDescController);
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

  // Dialog de confirmation pour la création de section
  void _showConfirmSectionDialog(BuildContext context, TextEditingController sectionNameController, TextEditingController sectionDescController) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Voulez-vous vraiment créer cette section ?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Fermer le dialog de confirmation

                setState(() {
                  String name = sectionNameController.text.trim();
                  String description = sectionDescController.text.trim();
                  sections.add(Section(
                    name: name.isNotEmpty ? name : 'Nouvelle Section',
                    description: description,
                    elements: [],
                  ));
                });

                Navigator.pop(context); // Fermer le dialog de création de section
              },
            ),
          ],
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

    String sectionName = sections[sectionIndex].name;
    print('Section name being passed: "$sectionName"');

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
                            ElementTypeGrid(
                              elementNameController: elementNameController,
                              sectionName: sectionName,
                            ),
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
                                _showConfirmElementDialog(
                                    context,
                                    sectionIndex,
                                    elementNameController,
                                    elementDescController,
                                    selectedStatus,
                                    photos,
                                    audioFiles,
                                    setState
                                );
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

  // Dialog de confirmation pour l'ajout d'élément
  void _showConfirmElementDialog(
      BuildContext context,
      int sectionIndex,
      TextEditingController elementNameController,
      TextEditingController elementDescController,
      String selectedStatus,
      List<File> photos,
      List<String> audioFiles,
      StateSetter setDialogState
      ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Voulez-vous vraiment ajouter cet élément ?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Fermer le dialog de confirmation

                setState(() {
                  String name = elementNameController.text.trim();
                  String description = elementDescController.text.trim();
                  sections[sectionIndex].elements.add(Elements(
                    name: name.isNotEmpty ? name : 'Nouvel Élément',
                    description: description,
                    status: selectedStatus,
                    photos: List.from(photos),
                    audioFiles: List.from(audioFiles),
                  ));
                });

                Navigator.pop(context); // Fermer le dialog d'ajout d'élément
              },
            ),
          ],
        );
      },
    );
  }
}