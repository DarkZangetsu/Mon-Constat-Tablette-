import 'package:flutter/material.dart';
import '../constants/element_types.dart';

class ElementTypeGrid extends StatelessWidget {
  final TextEditingController elementNameController;
  final String sectionName;

  const ElementTypeGrid({
    Key? key,
    required this.elementNameController,
    required this.sectionName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Vérifier si la section est dans la liste des sections spécifiques
    bool hasSpecificElements = ElementTypes.sectionSpecific.containsKey(sectionName);

    List<String> elements;

    if (hasSpecificElements) {
      // Si la section a des éléments spécifiques, afficher ces éléments spécifiques
      elements = ElementTypes.getElementsForSection(sectionName);
    } else {
      // Si la section n'a pas d'éléments spécifiques, afficher les éléments standard
      elements = ElementTypes.standard;
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: elements.map((element) => _buildElementChip(element)).toList(),
    );
  }

  Widget _buildElementChip(String label) {
    return InkWell(
      onTap: () {
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