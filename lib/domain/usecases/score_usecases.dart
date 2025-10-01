import '../entities/score.dart';
import '../repositories/score_repository.dart';

class RecordScore {
  final ScoreRepository repository;

  RecordScore(this.repository);

  Future<void> call(Score score) async {
    await repository.createScore(score);
  }
}

class GetScoresByMatch {
  final ScoreRepository repository;

  GetScoresByMatch(this.repository);

  Future<List<Score>> call(String matchId) async {
    return await repository.getScoresByMatch(matchId);
  }
}

class WatchScoresByMatch {
  final ScoreRepository repository;

  WatchScoresByMatch(this.repository);

  Stream<List<Score>> call(String matchId) {
    return repository.watchScoresByMatch(matchId);
  }
}