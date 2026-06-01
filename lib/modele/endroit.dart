import 'dart:io';
import 'package:uuid/uuid.dart';

// Instance globale du générateur UUID, accessible dans toute l'application
const uuid = Uuid();

/// Modèle de données représentant un endroit favori.
/// Contient l'identifiant unique, le nom, la photo, et les données GPS optionnelles.
class Endroit {
  final String id;
  final String nom;
  final File image;
  final double? latitude;
  final double? longitude;
  final String? adresse;

  Endroit({
    required this.nom,
    required this.image,
    this.latitude,
    this.longitude,
    this.adresse,
  }) : id = uuid.v4();
  // L'id est initialisé automatiquement via uuid.v4() dans la liste d'initialisation

  /// Retourne true si les coordonnées GPS sont disponibles.
  /// Utilisé dans EndroitDetail pour décider d'afficher ou non la carte.
  bool get aLocalisation => latitude != null && longitude != null;
}
