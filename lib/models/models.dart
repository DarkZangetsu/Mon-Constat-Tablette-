import 'dart:io';

class Section {
  final int? id;
  final String name;
  final String description;
  final List<Elements> elements;

  Section({
    this.id,
    required this.name,
    this.description = '',
    this.elements = const [],
  });
}


class Elements {
  final int? id;
  final String name;
  final String description;
  final String status; // NEUF, BON ÉTAT, ÉTAT D'USAGE, DÉGRADÉ
  final List<File> photos;
  final List<String> audioFiles;

  Elements({
    this.id,
    required this.name,
    required this.description,
    required this.status,
    this.photos = const [],
    this.audioFiles = const [],
  });
}


class EtatDesLieux {
  final int? id;
  final String title;
  final DateTime createdAt;
  final List<Section> sections;

  EtatDesLieux({
    this.id,
    required this.title,
    required this.createdAt,
    this.sections = const [],
  });
}