import '../entities/end.dart';
import '../entities/match.dart';
import '../repositories/end_repository.dart';
import '../repositories/match_score_repository.dart';
import '../repositories/match_repository.dart';

class RecordEnd {
  final EndRepository endRepository;
  final MatchScoreRepository scoreRepository;
  final MatchRepository matchRepository;

  RecordEnd({
    required this.endRepository,
    required this.scoreRepository,
    required this.matchRepository,
  });

  Future<void> call({
    required String matchId,
    required String userId,
    required int roundNumber,
    required int endNumber,
    required List<String> arrows,
  }) async {
    // Validate arrows
    if (arrows.isEmpty || arrows.length > 6) {
      throw Exception('Invalid number of arrows (1-6 allowed)');
    }

    for (final arrow in arrows) {
      if (!_isValidArrowScore(arrow)) {
        throw Exception('Invalid arrow score: $arrow (allowed: 0-10, X, M)');
      }
    }

    // Get match to validate it's ongoing
    final match = await matchRepository.getMatch(matchId);
    if (match == null || match.status != MatchStatus.ongoing) {
      throw Exception('Match is not ongoing');
    }

    // Calculate end total
    final endTotal = End.calculateTotal(arrows);

    // Create end
    final end = End(
      endId: '${matchId}_${userId}_r${roundNumber}_e$endNumber',
      matchId: matchId,
      userId: userId,
      roundNumber: roundNumber,
      endNumber: endNumber,
      arrows: List.from(arrows),
      endTotal: endTotal,
      arrowsPerEnd: match.arrowsPerEnd,
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
    );

    await endRepository.createEnd(end);

    // Update score
    await _updateScore(matchId, userId, match);
  }

  bool _isValidArrowScore(String arrow) {
    final upper = arrow.toUpperCase();
    if (upper == 'X' || upper == 'M') return true;
    final score = int.tryParse(arrow);
    return score != null && score >= 0 && score <= 10;
  }

  Future<void> _updateScore(String matchId, String userId, Match match) async {
    // Get current score
    final currentScore = await scoreRepository.getScoreByMatchAndUser(matchId, userId);
    if (currentScore == null) {
      throw Exception('Score not found for user');
    }

    // Get all ends for this user
    final allEnds = await endRepository.getEndsByMatchAndUser(matchId, userId);
    
    // Calculate new total
    final newTotal = allEnds.fold(0, (sum, end) => sum + end.endTotal);
    
    // Determine current position
    final completedEnds = allEnds.length;
    final totalEndsPerRound = match.totalEnds;
    final totalRounds = match.numberOfRounds;
    
    final currentRound = (completedEnds ~/ totalEndsPerRound) + 1;
    final currentEnd = (completedEnds % totalEndsPerRound) + 1;
    
    // Check if complete
    final isComplete = completedEnds >= (totalEndsPerRound * totalRounds);

    // Update score
    final updatedScore = currentScore.copyWith(
      ends: allEnds,
      totalScore: newTotal,
      currentRound: currentRound,
      currentEnd: currentEnd,
      isComplete: isComplete,
      completedAt: isComplete ? DateTime.now() : null,
    );

    await scoreRepository.updateScore(updatedScore);
  }
}