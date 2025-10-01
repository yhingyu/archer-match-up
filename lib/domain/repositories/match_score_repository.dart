import '../entities/match_score.dart';

abstract class MatchScoreRepository {
  Future<MatchScore> createScore(MatchScore score);
  Future<MatchScore?> getScore(String scoreId);
  Future<MatchScore?> getScoreByMatchAndUser(String matchId, String userId);
  Future<List<MatchScoreWithUser>> getScoresByMatch(String matchId);
  Future<void> updateScore(MatchScore score);
  Future<void> deleteScore(String scoreId);
  Stream<List<MatchScoreWithUser>> watchScoresByMatch(String matchId);
  Stream<MatchScore?> watchScoreByMatchAndUser(String matchId, String userId);
}