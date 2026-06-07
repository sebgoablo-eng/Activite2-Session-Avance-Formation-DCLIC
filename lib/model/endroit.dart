import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Entité représentant un endroit favori — PODO immuable.
/// Tous les champs sont [final]. La sérialisation SQLite est
/// gérée par [fromMap] et [toMap].
class Endroit {
  final String id;
  final String nom;
  final String imagePath; // chemin persistant sur le disque
  final double? latitude;
  final double? longitude;
  final String? adresse;
  final DateTime dateAjout;

  // ── Constructeur principal ──────────────────────────────────────
  // Génère automatiquement un UUID v4 et horodate la création.
  Endroit({
    required this.nom,
    required this.imagePath,
    this.latitude,
    this.longitude,
    this.adresse,
    DateTime? dateAjout,
  }) : id = _uuid.v4(),
       dateAjout = dateAjout ?? DateTime.now();

  // ── Constructeur interne pour la désérialisation SQLite ─────────
  // Utilisé uniquement par [fromMap] : l'id vient de la base, pas d'un uuid.v4().
  Endroit._fromDb({
    required this.id,
    required this.nom,
    required this.imagePath,
    this.latitude,
    this.longitude,
    this.adresse,
    required this.dateAjout,
  });

  // ── CORRECTION 1 & 2 : factory constructor fromMap ─────────────
  // Remplace le getter stub « static Function(...) get fromMap => null »
  // et initialise correctement imagePath (plus de getter retournant null).
  factory Endroit.fromMap(Map<String, dynamic> map) {
    return Endroit._fromDb(
      id: map['id'] as String,
      nom: map['nom'] as String,
      imagePath: map['imagePath'] as String, // CORRECTION 2
      latitude: map['latitude'] as double?,
      longitude: map['longitude'] as double?,
      adresse: map['adresse'] as String?,
      dateAjout: DateTime.parse(map['dateAjout'] as String),
    );
  }

  // ── CORRECTION 3 : toMap() implémenté ──────────────────────────
  // Remplace le corps vide {} qui causait l'erreur de type de retour.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'adresse': adresse,
      'dateAjout': dateAjout.toIso8601String(),
    };
  }

  // ── Getter métier ───────────────────────────────────────────────
  bool get aLocalisation => latitude != null && longitude != null;
}
