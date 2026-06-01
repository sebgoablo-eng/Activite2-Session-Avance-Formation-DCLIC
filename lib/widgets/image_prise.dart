import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Widget permettant à l'utilisateur de prendre une photo avec l'appareil.
/// Affiche un bouton si aucune photo n'est prise, sinon l'aperçu de la photo.
class ImagePrise extends StatefulWidget {
  const ImagePrise({super.key, required this.onPhotoSelectionnee});

  /// Callback transmettant le fichier image capturé au widget parent.
  final void Function(File image) onPhotoSelectionnee;

  @override
  State<ImagePrise> createState() => _ImagePriseState();
}

class _ImagePriseState extends State<ImagePrise> {
  // Stocke la photo capturée ; null tant qu'aucune photo n'a été prise
  File? _photoSelectionnee;

  /// Ouvre la caméra et capture une photo.
  /// Convertit le XFile retourné par image_picker en File standard de dart:io.
  Future<void> _prendrePhoto() async {
    final picker = ImagePicker();
    final photoCapturee = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600, // Limite la taille pour éviter de surcharger la mémoire
    );

    if (photoCapturee == null) return; // L'utilisateur a annulé

    setState(() {
      _photoSelectionnee = File(photoCapturee.path);
    });

    // Informe le widget parent de la photo sélectionnée
    widget.onPhotoSelectionnee(_photoSelectionnee!);
  }

  @override
  Widget build(BuildContext context) {
    // Conteneur commun pour la zone photo
    Widget contenu = TextButton.icon(
      onPressed: _prendrePhoto,
      icon: const Icon(Icons.camera_alt),
      label: const Text('Prendre une photo'),
    );

    // Si une photo est disponible, on l'affiche en remplacement du bouton.
    // GestureDetector permet de retoucher la photo en appuyant dessus.
    if (_photoSelectionnee != null) {
      contenu = GestureDetector(
        onTap: _prendrePhoto,
        child: Image.file(
          _photoSelectionnee!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Photo', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          child: contenu,
        ),
      ],
    );
  }
}
