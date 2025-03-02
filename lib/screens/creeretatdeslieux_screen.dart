import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:constat/components/blueButton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

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
                            ElementTypeGrid(elementNameController: elementNameController),
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

// Composant pour afficher un élément de section
class SectionItem extends StatelessWidget {
  final Section section;
  final VoidCallback onAddElement;

  const SectionItem({
    Key? key,
    required this.section,
    required this.onAddElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayName = section.description.isNotEmpty
        ? '${section.name} - (${section.description})'
        : section.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                displayName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
              onPressed: onAddElement,
            ),
          ],
        ),
        if (section.elements.isEmpty)
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: Text(
              'Aucun élément ajouté.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: section.elements.length,
            itemBuilder: (context, elementIndex) {
              final element = section.elements[elementIndex];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(element.name),
                    subtitle: Text(element.description),
                    trailing: _getStatusColor(element.status),
                  ),

                  // Afficher les photos s'il y en a
                  if (element.photos.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                      child: Container(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: element.photos.length,
                          itemBuilder: (ctx, photoIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.file(
                                element.photos[photoIndex],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  // Afficher les audios s'il y en a
                  if (element.audioFiles.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.audiotrack, color: Colors.blue),
                          Text('${element.audioFiles.length} audio(s) enregistré(s)'),
                        ],
                      ),
                    ),

                  const Divider(),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _getStatusColor(String status) {
    Color color;
    switch (status) {
      case 'NEUF':
        color = Colors.blue;
        break;
      case 'BON ÉTAT':
        color = Colors.green;
        break;
      case 'ÉTAT D\'USAGE':
        color = Colors.orange;
        break;
      case 'DÉGRADÉ':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// Composant pour la grille des types d'éléments
class ElementTypeGrid extends StatelessWidget {
  final TextEditingController elementNameController;

  const ElementTypeGrid({
    Key? key,
    required this.elementNameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final elements = [
      'ABAT-JOUR', 'AMPOULE', 'AÉRATION', 'BATTANT', 'BOÎTE DE DÉRIVATION',
      'CARRELAGE', 'CHAMBRANLE', 'CLOISON', 'COMPTEUR', 'CONDUITE',
      'CONVECTEUR', 'COUPE-CIRCUIT', 'CUMULUS', 'DESCENTE', 'DISJONCTEUR DIFFÉRENTIEL',
      'DOUILLE', 'FAUX PLAFOND', 'FENÊTRE DOUBLE VANTAUX', 'FENÊTRE SIMPLE VANTAIL',
      'GAINE', 'GARDE-CORPS', 'GLOBE', 'GONDS', 'GOULOTTE', 'HUISSERIES',
      'INTERRUPTEURS', 'ISOLATION', 'LED', 'LAMPE', 'LINOLITE', 'LUCARNE',
      'LUMINAIRE', 'LUSTRE', 'LÉ DE PAPIER PEINT', 'MATELAS', 'MOULURES',
      'MUR EST', 'MUR NORD', 'MUR OUEST', 'MUR SUD', 'NÉON', 'PAPIER PEINT',
      'PAUMELLE', 'PLACARD ÉLECTRIQUE', 'PLAQUE DE PROPRETÉ', 'PLINTHES',
      'PLINTHES CARRELÉES', 'POIGNÉE LAITON', 'PORTE', 'PORTE ISOPLANE',
      'PRISE RÉSEAU', 'PRISE TÉLÉPHONE', 'PRISE TÉLÉVISION', 'PRISES ÉLECTRIQUES',
      'PUITS DE LUMIÈRE', 'RADIATEUR', 'RIDEAU', 'SERRURE', 'SOMMIER',
      'SORTIE DE FIL', 'SPOT', 'STORE', 'SUSPENSION', 'TABLE DE NUIT',
      'TAPISSERIE', 'TRINGLE', 'TUYAUTERIE', 'TÊTE DE LIT', 'VMC', 'VELUX',
      'VERROU', 'VITRAGE', 'VOLET ROULANT'
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: elements.map((element) => _buildElementChip(element)).toList(),
    );
  }

  Widget _buildElementChip(String label) {
    return InkWell(
      onTap: () {
        // Au lieu de créer un élément directement, on remplit le champ de texte
        elementNameController.text = label;
      },
      child: Chip(
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        backgroundColor: Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    );
  }
}

// Composant pour les boutons d'état
class StatusButtonRow extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusChanged;

  const StatusButtonRow({
    Key? key,
    required this.selectedStatus,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatusButton('NEUF', const Color(0xFF2196F3)),
        const SizedBox(width: 8),
        _buildStatusButton('BON ÉTAT', const Color(0xFF4CAF50)),
        const SizedBox(width: 8),
        _buildStatusButton('ÉTAT D\'USAGE', const Color(0xFFFF9800)),
        const SizedBox(width: 8),
        _buildStatusButton('DÉGRADÉ', const Color(0xFFF44336)),
      ],
    );
  }

  Widget _buildStatusButton(String status, Color color) {
    bool isSelected = selectedStatus == status;

    return ElevatedButton(
      onPressed: () {
        onStatusChanged(status);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : color.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(
        status,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}

class PhotoAudioButtons extends StatefulWidget {
  final Function(File) onPhotoAdded;
  final Function(String) onAudioAdded;

  const PhotoAudioButtons({
    super.key,
    required this.onPhotoAdded,
    required this.onAudioAdded,
  });

  @override
  State<PhotoAudioButtons> createState() => _PhotoAudioButtonsState();
}

class _PhotoAudioButtonsState extends State<PhotoAudioButtons> {
  final ImagePicker _picker = ImagePicker();
  // Create AudioRecorder instance instead of Record
  final _audioRecorder = AudioRecorder();
  String? _currentRecordingPath;
  bool _isRecording = false;

  @override
  void dispose() {
    // Properly close the recorder
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _getPhotoFromCamera() async {
    // No change needed here
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        widget.onPhotoAdded(File(photo.path));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission de caméra refusée')),
      );
    }
  }

  Future<void> _getPhotoFromGallery() async {
    // No change needed here
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        widget.onPhotoAdded(File(photo.path));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission d\'accès à la galerie refusée')),
      );
    }
  }

  Future<void> _showImageSourceDialog() async {
    // No change needed here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter une photo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Prendre une photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getPhotoFromCamera();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Choisir depuis la galerie'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getPhotoFromGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _toggleRecording() async {
    final micStatus = await Permission.microphone.request();
    final storageStatus = await Permission.storage.request();

    if (micStatus.isGranted && storageStatus.isGranted) {
      if (_isRecording) {
        // Stop the recording with the updated API
        final path = await _audioRecorder.stop();
        setState(() {
          _isRecording = false;
          _currentRecordingPath = null;
        });

        if (path != null) {
          widget.onAudioAdded(path);
        }
      } else {
        // Start recording with the updated API
        final appDir = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final path = '${appDir.path}/audio_$timestamp.m4a';

        // Check if microphone is available before recording
        if (await _audioRecorder.hasPermission()) {
          // Updated method call for starting the recording
          await _audioRecorder.start(
            RecordConfig(
              encoder: AudioEncoder.aacLc,
              bitRate: 128000,
              sampleRate: 44100,
            ),
            path: path,
          );

          setState(() {
            _isRecording = true;
            _currentRecordingPath = path;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission de microphone refusée')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission de microphone ou stockage refusée')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // No change needed here
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _showImageSourceDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'AJOUTER UNE PHOTO',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 1),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _toggleRecording,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isRecording ? Colors.red : const Color(0xFF0288D1),
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              _isRecording ? 'ARRÊTER L\'ENREGISTREMENT' : 'ENREGISTRER UN AUDIO',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        if (_isRecording)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Enregistrement en cours...',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

// Composant pour afficher les médias (photos et audios)
class MediaDisplay extends StatefulWidget {
  final List<File> photos;
  final List<String> audioFiles;
  final Function(int) onDeletePhoto;
  final Function(int) onDeleteAudio;

  const MediaDisplay({
    Key? key,
    required this.photos,
    required this.audioFiles,
    required this.onDeletePhoto,
    required this.onDeleteAudio,
  }) : super(key: key);

  @override
  State<MediaDisplay> createState() => _MediaDisplayState();
}

class _MediaDisplayState extends State<MediaDisplay> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingIndex;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(int index) async {
    if (_playingIndex == index) {
      // Si déjà en lecture, arrêter
      await _audioPlayer.stop();
      setState(() {
        _playingIndex = null;
      });
    } else {
      // Sinon, commencer la lecture
      await _audioPlayer.play(DeviceFileSource(widget.audioFiles[index]));
      setState(() {
        _playingIndex = index;
      });

      // Mettre à jour l'état quand l'audio est terminé
      _audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          _playingIndex = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.photos.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Text(
              'Photos :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.photos.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.file(
                        widget.photos[index],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => widget.onDeletePhoto(index),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
        if (widget.audioFiles.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Text(
              'Audios Enregistrés :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.audioFiles.length,
            itemBuilder: (context, index) {
              final audioFile = File(widget.audioFiles[index]);
              final fileName = audioFile.path.split('/').last;
              final isPlaying = _playingIndex == index;

              return ListTile(
                leading: IconButton(
                  icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                  color: isPlaying ? Colors.red : Colors.blue,
                  onPressed: () => _playAudio(index),
                ),
                title: Text('Audio ${index + 1}'),
                subtitle: Text(fileName),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => widget.onDeleteAudio(index),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

// Modèles de données
class Section {
  final String name;
  final String description;
  final List<Element> elements;

  Section({
    required this.name,
    required this.description,
    required this.elements,
  });
}

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