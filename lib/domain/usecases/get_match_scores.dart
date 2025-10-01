import '../entities/match_score.dart';
import '../repositories/match_score_repository.dart';

class GetMatchScores {
  final MatchScoreRepository repository;

  GetMatchScores(this.repository);

  Future<List<MatchScoreWithUser>> call(String matchId) async {
    final scores = await repository.getScoresByMatch(matchId);
    
    // Sort by total score descending (leaderboard)
    scores.sort((a, b) => b.score.totalScore.compareTo(a.score.totalScore));
    
    return scores;
  }

  Stream<List<MatchScoreWithUser>> watchScores(String matchId) {
    return repository.watchScoresByMatch(matchId);
  }
}