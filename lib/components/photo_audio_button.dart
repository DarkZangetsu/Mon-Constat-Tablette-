import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

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
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    // Request permissions early when the widget initializes
    _requestInitialPermissions();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  // Request permissions when the widget is first initialized
  Future<void> _requestInitialPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
    // On newer Android versions (Android 10+), you need to use mediaLibrary instead
    if (Platform.isAndroid) {
      await Permission.mediaLibrary.request();
    }
  }

  Future<void> _getPhotoFromCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        widget.onPhotoAdded(File(photo.path));
      }
    } else {
      _showPermissionExplanationDialog('Caméra',
          'L\'application a besoin d\'accéder à votre caméra pour prendre des photos.');
    }
  }

  Future<void> _getPhotoFromGallery() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        widget.onPhotoAdded(File(photo.path));
      }
    } else {
      _showPermissionExplanationDialog('Galerie',
          'L\'application a besoin d\'accéder à votre galerie pour sélectionner des photos.');
    }
  }

  Future<void> _showPermissionExplanationDialog(String permissionType, String explanation) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission $permissionType requise'),
          content: Text(explanation),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ouvrir les paramètres'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showImageSourceDialog() async {
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

  Future<bool> _checkAndRequestAudioPermissions() async {
    // Vérifier les statuts actuels avant de demander
    final mediaLibraryStatus = Platform.isAndroid ? await Permission.mediaLibrary.status : PermissionStatus.granted;

    if (Platform.isAndroid) print('Statut initial médiathèque: $mediaLibraryStatus');

    // Demande des permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
      if (Platform.isAndroid) Permission.mediaLibrary,
    ].request();

    if (Platform.isAndroid) print('Statut final médiathèque: ${statuses[Permission.mediaLibrary]}');

    // Vérifier si toutes les permissions nécessaires sont accordées
    if (statuses[Permission.microphone]!.isGranted &&
        (statuses[Permission.storage]!.isGranted ||
            (Platform.isAndroid && statuses[Permission.mediaLibrary]!.isGranted))) {
      return true;
    } else {
      String refusedPermissions = "";
      if (!statuses[Permission.microphone]!.isGranted) refusedPermissions += "Microphone ";
      if (!statuses[Permission.storage]!.isGranted) refusedPermissions += "Stockage ";
      if (Platform.isAndroid && !statuses[Permission.mediaLibrary]!.isGranted) refusedPermissions += "Médiathèque ";

      _showPermissionExplanationDialog('Microphone et Stockage',
          'L\'application a besoin d\'accéder à votre microphone pour enregistrer l\'audio et au stockage pour sauvegarder l\'enregistrement. Permissions refusées: $refusedPermissions');
      return false;
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        widget.onAudioAdded(path);
      }
    } else {
      bool hasPermissions = await _checkAndRequestAudioPermissions();

      if (hasPermissions) {
        try {
          final appDir = await getApplicationDocumentsDirectory();
          final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          final path = '${appDir.path}/audio_$timestamp.m4a';

          if (await _audioRecorder.hasPermission()) {
            await _audioRecorder.start(
              const RecordConfig(
                encoder: AudioEncoder.aacLc,
                bitRate: 128000,
                sampleRate: 44100,
              ),
              path: path,
            );

            setState(() {
              _isRecording = true;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permission de microphone refusée')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur d\'enregistrement: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          const Padding(
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