import '../entities/end.dart';

abstract class EndRepository {
  Future<void> createEnd(End end);
  Future<End?> getEnd(String endId);
  Future<List<End>> getEndsByMatch(String matchId);
  Future<List<End>> getEndsByUser(String userId);
  Future<List<End>> getEndsByMatchAndUser(String matchId, String userId);
  Future<void> updateEnd(End end);
  Future<void> deleteEnd(String endId);
  Stream<List<End>> watchEndsByMatch(String matchId);
  Stream<List<End>> watchEndsByMatchAndUser(String matchId, String userId);
}