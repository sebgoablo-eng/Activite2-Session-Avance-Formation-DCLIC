import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/endroits_provider.dart';
import '../widgets/endroits_list.dart';
import 'ajout_endroit.dart';

/// Écran principal de l'application.
/// ConsumerWidget suffit ici car il n'y a pas d'état local à gérer.
class EndroitsInterface extends ConsumerWidget {
  const EndroitsInterface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch écoute le provider : toute modification de la liste
    // déclenche automatiquement la reconstruction de ce widget.
    final listeEndroits = ref.watch(endroitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes endroits préférés'),
        actions: [
          // Bouton "+" pour naviguer vers le formulaire d'ajout
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => const AjoutEndroit()));
            },
          ),
        ],
      ),
      // Transmission de la liste au widget dédié à l'affichage
      body: EndroitsList(endroits: listeEndroits),
    );
  }
}
