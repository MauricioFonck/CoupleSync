import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/streak_stats.dart';
import '../../domain/ports/statistics_repository_port.dart';
import '../firebase/dtos/streak_stats_dto.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/mappers/mappers.dart';

class FirestoreStatisticsRepository implements StatisticsRepositoryPort {
  FirestoreStatisticsRepository(this._db);

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> get _doc => _db
      .collection(FirestoreCollections.statistics)
      .doc(FirestoreCollections.statisticsDoc);

  @override
  Future<StreakStats?> get() async {
    final doc = await _doc.get();
    final data = doc.data();
    return data == null ? null : StreakStatsDto.fromJson(data).toDomain();
  }

  @override
  Future<void> save(StreakStats stats) => _doc.set(stats.toDto().toJson());
}
