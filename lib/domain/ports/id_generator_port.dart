/// Puerto generador de identificadores únicos (UUID en infraestructura).
/// Inyectable para hacer deterministas los tests del dominio.
abstract interface class IdGeneratorPort {
  String newId();
}
