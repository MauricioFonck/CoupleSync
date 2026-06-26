import 'package:flutter/material.dart';

/// Pantalla provisional para módulos que se implementan en fases posteriores.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title — próximamente',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
