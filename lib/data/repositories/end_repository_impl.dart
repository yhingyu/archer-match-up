import '../../domain/entities/end.dart';
import '../../domain/repositories/end_repository.dart';
import '../../core/services/hive_service.dart';
import '../models/end_model.dart';

class EndRepositoryImpl implements EndRepository {
  @override
  Future<End> createEnd(End end) async {
    final model = EndModel.fromEntity(end);
    final box = HiveService.endsBox;
    await box.put(end.endId, model);
    return end;
  }

  @override
  Future<End?> getEnd(String endId) async {
    final box = HiveService.endsBox;
    final model = box.get(endId);
    return model?.toEntity();
  }

  @override
  Future<List<End>> getEndsByMatch(String matchId) async {
    final box = HiveService.endsBox;
    final models = box.values.where((model) => model.matchId == matchId).toList();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<End>> getEndsByUser(String userId) async {
    final box = HiveService.endsBox;
    final models = box.values.where((model) => model.userId == userId).toList();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<End>> getEndsByMatchAndUser(String matchId, String userId) async {
    final box = HiveService.endsBox;
    final models = box.values
        .where((model) => model.matchId == matchId && model.userId == userId)
        .toList();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateEnd(End end) async {
    final model = EndModel.fromEntity(end);
    final box = HiveService.endsBox;
    await box.put(end.endId, model);
  }

  @override
  Future<void> deleteEnd(String endId) async {
    final box = HiveService.endsBox;
    await box.delete(endId);
  }

  @override
  Stream<List<End>> watchEndsByMatch(String matchId) {
    final box = HiveService.endsBox;
    return box.watch().map((_) {
      final models = box.values.where((model) => model.matchId == matchId).toList();
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Stream<List<End>> watchEndsByMatchAndUser(String matchId, String userId) {
    final box = HiveService.endsBox;
    return box.watch().map((_) {
      final models = box.values
          .where((model) => model.matchId == matchId && model.userId == userId)
          .toList();
      return models.map((model) => model.toEntity()).toList();
    });
  }
}