import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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

