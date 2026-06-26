import 'package:uuid/uuid.dart';

import '../domain/ports/id_generator_port.dart';

/// Generador de ids basado en UUID v4.
class UuidIdGenerator implements IdGeneratorPort {
  UuidIdGenerator([Uuid? uuid]) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  @override
  String newId() => _uuid.v4();
}
