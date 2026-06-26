import 'dart:math';

import '../domain/ports/random_port.dart';

/// Aleatoriedad real basada en `dart:math`.
class DartRandom implements RandomPort {
  DartRandom([Random? random]) : _random = random ?? Random();

  final Random _random;

  @override
  int nextInt(int max) => _random.nextInt(max);

  @override
  List<T> shuffled<T>(List<T> items) => List<T>.of(items)..shuffle(_random);
}
