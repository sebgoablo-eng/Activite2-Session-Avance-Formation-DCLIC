import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/endroits_controller.dart';
import '../../model/endroit.dart';
import '../screens/endroit_detail_screen.dart';

/// Liste des endroits avec suppression par glissement (Dismissible).
class EndroitsListWidget extends ConsumerWidget {
  const EndroitsListWidget({super.key, required this.endroits});
  final List<Endroit> endroits;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (endroits.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun endroit favori pour le moment.',
              style: TextStyle(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 6),
            Text(
              'Appuyez sur + pour en ajouter un.',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      itemCount: endroits.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final e = endroits[i];
        return Dismissible(
          key: ValueKey(e.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red.shade400,
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 28,
            ),
          ),
          confirmDismiss: (_) async => await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Supprimer ?'),
              content: Text('Supprimer « ${e.nom} » définitivement ?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(
                    'Supprimer',
                    style: TextStyle(color: Colors.red.shade400),
                  ),
                ),
              ],
            ),
          ),
          onDismissed: (_) =>
              ref.read(endroitsProvider.notifier).supprimerEndroit(e),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(e.imagePath),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              e.nom,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: e.adresse != null
                ? Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 13),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          e.adresse!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EndroitDetailScreen(endroit: e),
              ),
            ),
          ),
        );
      },
    );
  }
}
