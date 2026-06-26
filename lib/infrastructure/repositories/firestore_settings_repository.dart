import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/ports/settings_repository_port.dart';
import '../../domain/value_objects/scheduling_config.dart';
import '../firebase/dtos/scheduling_config_dto.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/mappers/mappers.dart';

class FirestoreSettingsRepository implements SettingsRepositoryPort {
  FirestoreSettingsRepository(this._db);

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> get _doc => _db
      .collection(FirestoreCollections.settings)
      .doc(FirestoreCollections.schedulingSettingsDoc);

  @override
  Future<SchedulingConfig> getSchedulingConfig() async {
    final doc = await _doc.get();
    final data = doc.data();
    return data == null
        ? SchedulingConfig.defaults()
        : SchedulingConfigDto.fromJson(data).toDomain();
  }

  @override
  Future<void> saveSchedulingConfig(SchedulingConfig config) =>
      _doc.set(config.toDto().toJson());
}
