import 'package:flutter/material.dart';
import '../modele/endroit.dart';
import '../vue/endroit_detail.dart';

/// Widget affichant la liste des endroits favoris.
/// StatelessWidget car il ne gère pas d'état propre : il reçoit la liste depuis le provider.
class EndroitsList extends StatelessWidget {
  const EndroitsList({super.key, required this.endroits});

  final List<Endroit> endroits;

  @override
  Widget build(BuildContext context) {
    // Cas d'une liste vide : message d'invitation à ajouter un premier endroit
    if (endroits.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun endroit favori pour le moment.\nAppuyez sur + pour en ajouter un.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    // Affichage de la liste avec ListView.builder pour des performances optimales
    return ListView.builder(
      itemCount: endroits.length,
      itemBuilder: (context, index) {
        final endroit = endroits[index];
        return ListTile(
          // Vignette circulaire de la photo de l'endroit
          leading: CircleAvatar(
            radius: 28,
            backgroundImage: FileImage(endroit.image),
          ),
          title: Text(endroit.nom),
          // L'adresse n'est affichée que si elle est disponible
          subtitle: endroit.adresse != null ? Text(endroit.adresse!) : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigation vers la page de détails de l'endroit sélectionné
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => EndroitDetail(endroit: endroit),
              ),
            );
          },
        );
      },
    );
  }
}
