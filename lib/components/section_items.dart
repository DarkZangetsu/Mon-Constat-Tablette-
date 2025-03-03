import 'package:flutter/material.dart';
import '../models/models.dart';
import '../constants/status_constants.dart';

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
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: StatusConstants.getStatusColor(status),
        shape: BoxShape.circle,
      ),
    );
  }
}