import '../entities/score.dart';

abstract class ScoreRepository {
  Future<void> createScore(Score score);
  Future<Score?> getScore(String scoreId);
  Future<List<Score>> getScoresByEnd(String endId);
  Future<List<Score>> getScoresByRegistration(String registrationId);
  Future<List<Score>> getScoresByMatch(String matchId);
  Future<void> updateScore(Score score);
  Future<void> deleteScore(String scoreId);
  Stream<List<Score>> watchScoresByEnd(String endId);
  Stream<List<Score>> watchScoresByRegistration(String registrationId);
  Stream<List<Score>> watchScoresByMatch(String matchId);
}