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
    // Obtenir les éléments spécifiques à cette section
    List<String> elements = ElementTypes.getElementsForSection(sectionName);

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