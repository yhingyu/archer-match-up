import '../../domain/entities/match_score.dart';
import '../../domain/repositories/match_score_repository.dart';
import '../../domain/repositories/end_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/services/hive_service.dart';
import '../models/match_score_model.dart';

class MatchScoreRepositoryImpl implements MatchScoreRepository {
  final EndRepository endRepository;
  final UserRepository userRepository;

  MatchScoreRepositoryImpl({
    required this.endRepository,
    required this.userRepository,
  });

  @override
  Future<MatchScore> createScore(MatchScore score) async {
    final model = MatchScoreModel.fromEntity(score);
    final box = HiveService.scoresBox;
    await box.put(score.scoreId, model);
    return score;
  }

  @override
  Future<MatchScore?> getScore(String scoreId) async {
    final box = HiveService.scoresBox;
    final model = box.get(scoreId);
    if (model == null) return null;
    
    final ends = await endRepository.getEndsByMatchAndUser(model.matchId, model.userId);
    return model.toEntity(ends);
  }

  @override
  Future<List<MatchScoreWithUser>> getScoresByMatch(String matchId) async {
    final box = HiveService.scoresBox;
    final models = box.values.where((model) => model.matchId == matchId).toList();
    
    final result = <MatchScoreWithUser>[];
    
    for (final model in models) {
      final user = await userRepository.getUserById(model.userId);
      if (user != null) {
        final ends = await endRepository.getEndsByMatchAndUser(model.matchId, model.userId);
        final score = model.toEntity(ends);
        result.add(MatchScoreWithUser(score: score, user: user));
      }
    }
    
    return result;
  }

  @override
  Future<MatchScore?> getScoreByMatchAndUser(String matchId, String userId) async {
    final scoreId = '${matchId}_$userId';
    return await getScore(scoreId);
  }

  @override
  Future<void> updateScore(MatchScore score) async {
    final model = MatchScoreModel.fromEntity(score);
    final box = HiveService.scoresBox;
    await box.put(score.scoreId, model);
  }

  @override
  Future<void> deleteScore(String scoreId) async {
    final box = HiveService.scoresBox;
    await box.delete(scoreId);
  }

  @override
  Stream<List<MatchScoreWithUser>> watchScoresByMatch(String matchId) {
    final box = HiveService.scoresBox;
    return box.watch().asyncMap((_) async {
      final models = box.values.where((model) => model.matchId == matchId).toList();
      
      final result = <MatchScoreWithUser>[];
      
      for (final model in models) {
        final user = await userRepository.getUserById(model.userId);
        if (user != null) {
          final ends = await endRepository.getEndsByMatchAndUser(model.matchId, model.userId);
          final score = model.toEntity(ends);
          result.add(MatchScoreWithUser(score: score, user: user));
        }
      }
      
      return result;
    });
  }

  @override
  Stream<MatchScore?> watchScoreByMatchAndUser(String matchId, String userId) {
    final scoreId = '${matchId}_$userId';
    final box = HiveService.scoresBox;
    return box.watch().asyncMap((_) async {
      final model = box.get(scoreId);
      if (model == null) return null;
      
      final ends = await endRepository.getEndsByMatchAndUser(model.matchId, model.userId);
      return model.toEntity(ends);
    });
  }
}