import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Verifica la regla de dependencias de la arquitectura hexagonal:
/// el dominio (y la aplicación) son Dart puro y no conocen Flutter/Firebase/
/// Riverpod ni otras librerías de infraestructura.
void main() {
  test('lib/domain no importa Flutter/Firebase/Riverpod/infra', () {
    final violations = _scanForbiddenImports(
      'lib/domain',
      forbidden: const [
        'package:flutter/',
        'package:flutter_riverpod',
        'package:riverpod',
        'package:firebase',
        'package:cloud_firestore',
        'package:go_router',
        'package:image',
        'package:uuid',
        'dart:io',
        'dart:html',
      ],
    );
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('lib/application no importa Flutter/Firebase/Riverpod', () {
    final violations = _scanForbiddenImports(
      'lib/application',
      forbidden: const [
        'package:flutter/',
        'package:flutter_riverpod',
        'package:riverpod',
        'package:firebase',
        'package:cloud_firestore',
      ],
    );
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}

List<String> _scanForbiddenImports(
  String directory, {
  required List<String> forbidden,
}) {
  final violations = <String>[];
  final dir = Directory(directory);
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final lines = entity.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (!line.startsWith('import ') && !line.startsWith('export ')) continue;
      for (final needle in forbidden) {
        if (line.contains(needle)) {
          violations.add('${entity.path}:${i + 1}  ->  $line');
        }
      }
    }
  }
  return violations;
}
