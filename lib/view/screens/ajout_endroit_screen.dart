import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/endroits_controller.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/localisation_widget.dart';

/// Formulaire d'ajout d'un nouvel endroit.
class AjoutEndroitScreen extends ConsumerStatefulWidget {
  const AjoutEndroitScreen({super.key});
  @override
  ConsumerState<AjoutEndroitScreen> createState() => _AjoutEndroitScreenState();
}

class _AjoutEndroitScreenState extends ConsumerState<AjoutEndroitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  File? _imageFile;
  double? _latitude, _longitude;
  String? _adresse;
  bool _saving = false;

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  void _onImageSelected(File f) => setState(() => _imageFile = f);
  void _onLocationSelected(double lat, double lng, String addr) => setState(() {
    _latitude = lat;
    _longitude = lng;
    _adresse = addr;
  });

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une photo.')),
      );
      return;
    }
    setState(() => _saving = true);
    await ref
        .read(endroitsProvider.notifier)
        .ajouterEndroit(
          nom: _nomController.text.trim(),
          imageFile: _imageFile!,
          latitude: _latitude,
          longitude: _longitude,
          adresse: _adresse,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un endroit'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nomController,
              decoration: InputDecoration(
                labelText: 'Nom de l\'endroit',
                prefixIcon: const Icon(Icons.label_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Le nom est requis' : null,
            ),
            const SizedBox(height: 24),
            ImagePickerWidget(onImageSelected: _onImageSelected),
            const SizedBox(height: 24),
            LocalisationWidget(onLocationSelected: _onLocationSelected),
            const SizedBox(height: 32),
            _saving
                ? const Center(child: CircularProgressIndicator())
                : FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Enregistrer l\'endroit'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
