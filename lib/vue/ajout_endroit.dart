import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/endroits_provider.dart';
import '../widgets/image_prise.dart';
import '../widgets/localisation_prise.dart';

/// Formulaire d'ajout d'un nouvel endroit.
/// ConsumerStatefulWidget permet d'avoir un état local ET d'accéder aux providers Riverpod.
class AjoutEndroit extends ConsumerStatefulWidget {
  const AjoutEndroit({super.key});

  @override
  ConsumerState<AjoutEndroit> createState() => _AjoutEndroitState();
}

class _AjoutEndroitState extends ConsumerState<AjoutEndroit> {
  final _nomController = TextEditingController();
  File? _imageSelectionnee;
  double? _latitude;
  double? _longitude;
  String? _adresse;

  /// Libération du contrôleur pour éviter les fuites mémoire
  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  /// Reçoit la photo capturée depuis le widget ImagePrise
  void _surPhotoSelectionnee(File image) {
    setState(() => _imageSelectionnee = image);
  }

  /// Reçoit les coordonnées GPS et l'adresse depuis le widget LocalisationPrise
  void _surLocalisationSelectionnee(double lat, double lng, String adresse) {
    setState(() {
      _latitude = lat;
      _longitude = lng;
      _adresse = adresse;
    });
  }

  /// Valide les champs, crée l'endroit via le provider et ferme la page
  void _enregistrerEndroit() {
    final nom = _nomController.text.trim();

    if (nom.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir un nom pour l\'endroit.'),
        ),
      );
      return;
    }

    if (_imageSelectionnee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez prendre une photo.')),
      );
      return;
    }

    // Ajout via le provider Riverpod — déclenche la reconstruction de l'interface principale
    ref
        .read(endroitsProvider.notifier)
        .ajouterEndroit(
          nom: nom,
          image: _imageSelectionnee!,
          latitude: _latitude,
          longitude: _longitude,
          adresse: _adresse,
        );

    Navigator.of(context).pop(); // Retour à l'écran principal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajout d\'un nouvel endroit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Champ de saisie du nom de l'endroit
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom de l\'endroit',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 20),

            // Widget de prise de photo
            ImagePrise(onPhotoSelectionnee: _surPhotoSelectionnee),
            const SizedBox(height: 20),

            // Widget de géolocalisation
            LocalisationPrise(
              onLocalisationSelectionnee: _surLocalisationSelectionnee,
            ),
            const SizedBox(height: 28),

            // Bouton d'enregistrement
            ElevatedButton.icon(
              onPressed: _enregistrerEndroit,
              icon: const Icon(Icons.save),
              label: const Text('Enregistrer l\'endroit'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
