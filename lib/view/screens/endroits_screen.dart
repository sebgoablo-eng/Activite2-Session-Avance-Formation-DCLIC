import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/endroits_controller.dart';
import '../widgets/endroits_list_widget.dart';
import 'ajout_endroit_screen.dart';

/// Écran principal : liste des endroits favoris.
class EndroitsScreen extends ConsumerWidget {
  const EndroitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEndroits = ref.watch(endroitsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes endroits préférés'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_outlined),
            tooltip: 'Ajouter un endroit',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AjoutEndroitScreen()),
            ),
          ),
        ],
      ),
      body: asyncEndroits.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Erreur : $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (endroits) => EndroitsListWidget(endroits: endroits),
      ),
    );
  }
}
