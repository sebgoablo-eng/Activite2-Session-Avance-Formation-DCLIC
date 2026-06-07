import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'database_service.dart';
import 'endroit.dart';

/// Couche d'abstraction entre le Controller et SQLite.
/// Gère aussi la copie persistante des fichiers image.
class EndroitRepository {
  final DatabaseService _db;

  EndroitRepository({DatabaseService? db})
    : _db = db ?? DatabaseService.instance;

  // ── CORRECTION 1 : typage explicite de map() ───────────────────
  // Avant : rows.map(Endroit.fromMap)  → List<dynamic>
  // Après : rows.map((m) => Endroit.fromMap(m))  → List<Endroit>
  Future<List<Endroit>> getAll() async {
    final rows = await _db.fetchAll();
    return rows
        .map((m) => Endroit.fromMap(m)) // CORRECTION 1 : typage explicite
        .toList();
  }

  // ── CORRECTION 2 : imageFile passé correctement ────────────────
  // Avant : image: null  →  erreur de type (Null != File)
  // Après : le paramètre imageFile reçu est transmis à Endroit()
  Future<Endroit> add({
    required String nom,
    required File imageFile, // fichier temporaire capturé
    double? latitude,
    double? longitude,
    String? adresse,
  }) async {
    // 1. Copie dans le répertoire persistant de l'application
    final dir = await getApplicationDocumentsDirectory();
    final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final destPath = p.join(dir.path, filename);
    await imageFile.copy(destPath); // CORRECTION 2 : imageFile utilisé

    // 2. Création de l'entité avec le chemin persistant
    final endroit = Endroit(
      nom: nom,
      imagePath: destPath,
      latitude: latitude,
      longitude: longitude,
      adresse: adresse,
    );

    // 3. Insertion en base SQLite
    await _db.insert(endroit);
    return endroit;
  }

  /// Supprime l'endroit de la base et son image du disque.
  Future<void> remove(Endroit endroit) async {
    await _db.delete(endroit.id);
    final fichier = File(endroit.imagePath);
    if (await fichier.exists()) await fichier.delete();
  }
}
