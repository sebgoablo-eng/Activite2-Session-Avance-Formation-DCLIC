import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modele/endroit.dart';

/// Gestionnaire d'état de la liste des endroits.
/// Utilise la syntaxe Riverpod v2 : Notifier remplace l'ancien StateNotifier.
class EndroitsNotifier extends Notifier<List<Endroit>> {
  /// Méthode obligatoire imposée par Riverpod v2.
  /// Remplace le constructeur et retourne l'état initial : une liste vide.
  @override
  List<Endroit> build() => [];

  /// Crée un nouvel endroit et l'insère en tête de liste.
  /// La réaffectation de [state] déclenche automatiquement la reconstruction
  /// de tous les widgets qui écoutent ce provider.
  void ajouterEndroit({
    required String nom,
    required File image,
    double? latitude,
    double? longitude,
    String? adresse,
  }) {
    final nouvelEndroit = Endroit(
      nom: nom,
      image: image,
      latitude: latitude,
      longitude: longitude,
      adresse: adresse,
    );
    // On place le nouvel endroit en tête pour qu'il apparaisse en premier
    state = [nouvelEndroit, ...state];
  }

  /// Supprime l'endroit correspondant à l'[id] fourni.
  void supprimerEndroit(String id) {
    state = state.where((endroit) => endroit.id != id).toList();
  }
}

/// Provider global exposant la liste des endroits à toute l'application.
/// NotifierProvider est la syntaxe Riverpod v2, équivalent moderne de StateNotifierProvider.
final endroitsProvider = NotifierProvider<EndroitsNotifier, List<Endroit>>(
  EndroitsNotifier.new,
);
