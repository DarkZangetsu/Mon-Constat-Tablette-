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
  String? _currentRecordingPath;
  bool _isRecording = false;

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _getPhotoFromCamera() async {
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
        final path = await _audioRecorder.stop();
        setState(() {
          _isRecording = false;
          _currentRecordingPath = null;
        });

        if (path != null) {
          widget.onAudioAdded(path);
        }
      } else {
        final appDir = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final path = '${appDir.path}/audio_$timestamp.m4a';

        if (await _audioRecorder.hasPermission()) {
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