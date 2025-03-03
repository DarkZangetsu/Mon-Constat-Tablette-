
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


import '../models/models.dart';



class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'etat_des_lieux.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    // Création de la table des états des lieux
    await db.execute('''
      CREATE TABLE etat_des_lieux (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Création de la table des sections
    await db.execute('''
      CREATE TABLE sections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        etat_des_lieux_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        FOREIGN KEY (etat_des_lieux_id) REFERENCES etat_des_lieux (id) ON DELETE CASCADE
      )
    ''');

    // Création de la table des éléments
    await db.execute('''
      CREATE TABLE elements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        section_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        status TEXT NOT NULL,
        FOREIGN KEY (section_id) REFERENCES sections (id) ON DELETE CASCADE
      )
    ''');

    // Création de la table des photos
    await db.execute('''
      CREATE TABLE photos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        element_id INTEGER NOT NULL,
        path TEXT NOT NULL,
        FOREIGN KEY (element_id) REFERENCES elements (id) ON DELETE CASCADE
      )
    ''');

    // Création de la table des fichiers audio
    await db.execute('''
      CREATE TABLE audio_files (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        element_id INTEGER NOT NULL,
        path TEXT NOT NULL,
        FOREIGN KEY (element_id) REFERENCES elements (id) ON DELETE CASCADE
      )
    ''');
  }

  // Méthodes pour gérer les états des lieux
  Future<int> insertEtatDesLieux(String title) async {
    Database db = await database;
    Map<String, dynamic> row = {
      'title': title,
      'created_at': DateTime.now().toIso8601String()
    };
    return await db.insert('etat_des_lieux', row);
  }

  Future<List<Map<String, dynamic>>> getEtatDesLieux() async {
    Database db = await database;
    var result = await db.query('etat_des_lieux', orderBy: 'created_at DESC');
    return List<Map<String, dynamic>>.from(result);
  }
  // Méthodes pour gérer les sections
  Future<int> insertSection(int etatDesLieuxId, Section section) async {
    Database db = await database;
    Map<String, dynamic> row = {
      'etat_des_lieux_id': etatDesLieuxId,
      'name': section.name,
      'description': section.description,
    };
    return await db.insert('sections', row);
  }

  Future<List<Section>> getSections(int etatDesLieuxId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'sections',
      where: 'etat_des_lieux_id = ?',
      whereArgs: [etatDesLieuxId],
    );

    List<Section> sections = [];
    for (var map in maps) {
      sections.add(Section(
        id: map['id'],
        name: map['name'],
        description: map['description'] ?? '',
        elements: await getElements(map['id']),
      ));
    }
    return sections;
  }

  // Méthodes pour gérer les éléments
  Future<int> insertElement(int sectionId, Elements element) async {
    Database db = await database;
    Map<String, dynamic> row = {
      'section_id': sectionId,
      'name': element.name,
      'description': element.description,
      'status': element.status,
    };
    int elementId = await db.insert('elements', row);

    // Enregistrer les photos
    for (var photo in element.photos) {
      await insertPhoto(elementId, photo.path);
    }

    // Enregistrer les fichiers audio
    for (var audioFile in element.audioFiles) {
      await insertAudioFile(elementId, audioFile);
    }

    return elementId;
  }

  Future<List<Elements>> getElements(int sectionId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'elements',
      where: 'section_id = ?',
      whereArgs: [sectionId],
    );

    List<Elements> elements = [];
    for (var map in maps) {
      int elementId = map['id'];
      List<File> photos = await getPhotos(elementId);
      List<String> audioFiles = await getAudioFiles(elementId);

      elements.add(Elements(
        id: elementId,
        name: map['name'],
        description: map['description'] ?? '',
        status: map['status'],
        photos: photos,
        audioFiles: audioFiles,
      ));
    }
    return elements;
  }

  // Méthodes pour gérer les photos
  Future<int> insertPhoto(int elementId, String path) async {
    Database db = await database;
    Map<String, dynamic> row = {
      'element_id': elementId,
      'path': path,
    };
    return await db.insert('photos', row);
  }

  Future<List<File>> getPhotos(int elementId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'photos',
      where: 'element_id = ?',
      whereArgs: [elementId],
    );

    return maps.map((map) => File(map['path'])).toList();
  }

  // Méthodes pour gérer les fichiers audio
  Future<int> insertAudioFile(int elementId, String path) async {
    Database db = await database;
    Map<String, dynamic> row = {
      'element_id': elementId,
      'path': path,
    };
    return await db.insert('audio_files', row);
  }

  Future<List<String>> getAudioFiles(int elementId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'audio_files',
      where: 'element_id = ?',
      whereArgs: [elementId],
    );

    return maps.map((map) => map['path'] as String).toList();
  }

  // Méthode pour supprimer un état des lieux
  Future<int> deleteEtatDesLieux(int id) async {
    Database db = await database;
    return await db.delete(
      'etat_des_lieux',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}