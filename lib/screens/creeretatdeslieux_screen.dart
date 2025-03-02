import 'package:constat/components/blueButton.dart';
import 'package:flutter/material.dart';

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
                            ElementTypeGrid(),
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
                            PhotoAudioButtons(),
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
              return ListTile(
                title: Text(element.name),
                subtitle: Text(element.description),
                trailing: _getStatusColor(element.status),
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
  const ElementTypeGrid({Key? key}) : super(key: key);

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
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
      backgroundColor: Colors.grey,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
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

// Composant pour les boutons Photo et Audio
class PhotoAudioButtons extends StatelessWidget {
  const PhotoAudioButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              // Ajouter une photo
            },
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
        const SizedBox(height: 1), // Espace très petit entre les boutons
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              // Enregistrer un audio
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0288D1), // Bleu légèrement plus foncé
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'ENREGISTRER UN AUDIO',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
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

  Element({
    required this.name,
    required this.description,
    required this.status,
  });
}