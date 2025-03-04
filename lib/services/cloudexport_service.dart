import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class CloudExportService {
  static const String _apiKey = 'KEY123456';
  static const String _uploadFilesUrl = 'https://monconstatsurtablette.com/api/upload_fichiers.php';
  static const String _convertToWordUrl = 'https://monconstatsurtablette.com/api/conversion_to_word.php';

  /// Exports état des lieux pour le cloud
  Future<void> exportEtatDesLieux({
    required BuildContext context,
    required int idgens,
    required int idConstat,
    required String filename,
    required String htmlContent,
    List<File>? images,
    List<File>? audioFiles,
  }) async {
    bool? confirmed = await _showExportConfirmationDialog(context);
    if (confirmed != true) return;

    try {
      // Determiner methode d'export baser à la presence d'un fichier audio ou pas
      if (audioFiles != null && audioFiles.isNotEmpty) {
        await _exportWithAudioFiles(
          context: context,
          idgens: idgens,
          idConstat: idConstat,
          images: images ?? [],
          audioFiles: audioFiles,
        );
      } else {
        await _exportTextAndImages(
          context: context,
          idgens: idgens,
          filename: filename,
          htmlContent: htmlContent,
          images: images ?? [],
        );
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  Future<void> _exportWithAudioFiles({
    required BuildContext context,
    required int idgens,
    required int idConstat,
    required List<File> images,
    required List<File> audioFiles,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(_uploadFilesUrl));

    request.fields['idgens'] = idgens.toString();
    request.fields['id_constat'] = idConstat.toString();
    request.fields['api_key'] = _apiKey;

    for (var image in images) {
      request.files.add(await http.MultipartFile.fromPath(
        'fichiers[]',
        image.path,
        filename: path.basename(image.path),
      ));
    }

    for (var audio in audioFiles) {
      request.files.add(await http.MultipartFile.fromPath(
        'fichiers[]',
        audio.path,
        filename: path.basename(audio.path),
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      // Success dialog for audio files export
      _showSuccessDialog(
          context,
          'Commande Ma Dactylo envoyée, vous allez recevoir un accusé de réception'
      );
    } else {
      throw Exception('Échec de l\'exportation');
    }
  }

  Future<void> _exportTextAndImages({
    required BuildContext context,
    required int idgens,
    required String filename,
    required String htmlContent,
    required List<File> images,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(_convertToWordUrl));

    request.fields['api_key'] = _apiKey;
    request.fields['idgens'] = idgens.toString();
    request.fields['filename'] = filename;

    request.files.add(http.MultipartFile.fromString(
        'html_file',
        htmlContent,
        filename: '$filename.html'
    ));

    for (var image in images) {
      request.files.add(await http.MultipartFile.fromPath(
        'images[]',
        image.path,
        filename: path.basename(image.path),
      ));
    }

    // Send request
    var response = await request.send();

    if (response.statusCode == 200) {
      // Success dialog for text and images export
      _showSuccessDialog(
          context,
          'Téléchargement effectué, vous pouvez retrouver votre document word dans votre espace livraison Ma Dactylo'
      );
    } else {
      throw Exception('Échec de l\'exportation');
    }
  }

  Future<bool?> _showExportConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation d\'exportation'),
          content: const Text('Voulez-vous exporter cet état des lieux sur le cloud ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Exporter'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exportation réussie'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur d\'exportation'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}