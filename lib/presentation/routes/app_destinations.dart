import 'package:flutter/material.dart';

/// Destino de navegación del shell.
class AppDestination {
  const AppDestination({
    required this.route,
    required this.label,
    required this.icon,
  });

  final String route;
  final String label;
  final IconData icon;
}

/// Destinos principales (orden = orden en la barra/rail).
const List<AppDestination> appDestinations = [
  AppDestination(route: '/dashboard', label: 'Inicio', icon: Icons.dashboard),
  AppDestination(route: '/activities', label: 'Actividades', icon: Icons.event),
  AppDestination(route: '/penalties', label: 'Penitencias', icon: Icons.gavel),
  AppDestination(
    route: '/availability',
    label: 'Disponibilidad',
    icon: Icons.calendar_month,
  ),
  AppDestination(route: '/schedule', label: 'Agenda', icon: Icons.view_week),
  AppDestination(route: '/roulette', label: 'Ruleta', icon: Icons.casino),
  AppDestination(route: '/history', label: 'Historial', icon: Icons.history),
];
