import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'vue/endroits_interface.dart';

/// Point d'entrée de l'application.
/// ProviderScope est obligatoire pour initialiser le système de providers Riverpod v2.
void main() {
  runApp(const ProviderScope(child: MonApplication()));
}

/// Widget racine de l'application.
class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Endroits Favoris',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const EndroitsInterface(),
    );
  }
}
