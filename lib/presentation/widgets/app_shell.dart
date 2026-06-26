import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/connectivity_provider.dart';
import '../providers/sign_in_controller.dart';
import '../routes/app_destinations.dart';
import '../theme/app_theme.dart';

/// Shell responsive: `NavigationBar` en pantallas compactas y `NavigationRail`
/// en medianas/expandidas.
class AppShell extends ConsumerWidget {
  const AppShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  int get _selectedIndex {
    final index = appDestinations.indexWhere(
      (d) => location.startsWith(d.route),
    );
    return index < 0 ? 0 : index;
  }

  void _onSelect(BuildContext context, int index) =>
      context.go(appDestinations[index].route);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = Breakpoints.isCompact(width);
    final title = appDestinations[_selectedIndex].label;
    final online = ref.watch(isOnlineProvider);

    final body = Column(
      children: [
        if (!online)
          Material(
            color: Theme.of(context).colorScheme.errorContainer,
            child: const SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Sin conexión — los cambios se sincronizarán al volver',
                  key: Key('offline_banner'),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        Expanded(child: child),
      ],
    );

    final appBar = AppBar(
      title: Text(title),
      actions: [
        IconButton(
          key: const Key('logout_button'),
          tooltip: 'Cerrar sesión',
          icon: const Icon(Icons.logout),
          onPressed: () =>
              ref.read(signInControllerProvider.notifier).signOut(),
        ),
      ],
    );

    if (compact) {
      return Scaffold(
        appBar: appBar,
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (i) => _onSelect(context, i),
          destinations: [
            for (final d in appDestinations)
              NavigationDestination(icon: Icon(d.icon), label: d.label),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => _onSelect(context, i),
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (final d in appDestinations)
                NavigationRailDestination(
                  icon: Icon(d.icon),
                  label: Text(d.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
