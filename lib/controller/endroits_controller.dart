import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/endroit.dart';
import '../model/endroit_repository.dart';

/// Controller MVC — orchestre les cas d'usage.
/// [AsyncNotifier] charge les données SQLite au démarrage.
class EndroitsController extends AsyncNotifier<List<Endroit>> {
  late final EndroitRepository _repository;

  // ── CORRECTION : await + typage explicite ──────────────────────
  // Avant : return _repository.getAll();
  //         → Flutter inférait Future<List<dynamic>>, type incompatible.
  // Après : final List<Endroit> liste = await _repository.getAll();
  //         → Le type est explicite et garanti.
  @override
  Future<List<Endroit>> build() async {
    _repository = EndroitRepository();
    final List<Endroit> liste = await _repository.getAll(); // CORRECTION
    return liste;
  }

  /// Ajoute un endroit : persistance via repository + mise à jour état.
  Future<void> ajouterEndroit({
    required String nom,
    required File imageFile,
    double? latitude,
    double? longitude,
    String? adresse,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final Endroit nouvel = await _repository.add(
        nom: nom,
        imageFile: imageFile,
        latitude: latitude,
        longitude: longitude,
        adresse: adresse,
      );
      return [nouvel, ...state.value ?? []];
    });
  }

  /// Supprime un endroit : disque + SQLite + état Riverpod.
  Future<void> supprimerEndroit(Endroit endroit) async {
    await _repository.remove(endroit);
    final liste = state.value ?? [];
    state = AsyncValue.data(liste.where((e) => e.id != endroit.id).toList());
  }
}

/// Provider global — point d'entrée Riverpod pour la View.
final endroitsProvider =
    AsyncNotifierProvider<EndroitsController, List<Endroit>>(
      EndroitsController.new,
    );
