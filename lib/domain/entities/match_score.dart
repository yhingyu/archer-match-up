import 'end.dart';
import 'user.dart';

class MatchScore {
  final String scoreId;
  final String matchId;
  final String userId;
  final List<End> ends;
  final int totalScore;
  final int currentRound;
  final int currentEnd;
  final bool isComplete;
  final DateTime createdAt;
  final DateTime? completedAt;

  const MatchScore({
    required this.scoreId,
    required this.matchId,
    required this.userId,
    required this.ends,
    required this.totalScore,
    required this.currentRound,
    required this.currentEnd,
    required this.isComplete,
    required this.createdAt,
    this.completedAt,
  });

  MatchScore copyWith({
    String? scoreId,
    String? matchId,
    String? userId,
    List<End>? ends,
    int? totalScore,
    int? currentRound,
    int? currentEnd,
    bool? isComplete,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return MatchScore(
      scoreId: scoreId ?? this.scoreId,
      matchId: matchId ?? this.matchId,
      userId: userId ?? this.userId,
      ends: ends ?? this.ends,
      totalScore: totalScore ?? this.totalScore,
      currentRound: currentRound ?? this.currentRound,
      currentEnd: currentEnd ?? this.currentEnd,
      isComplete: isComplete ?? this.isComplete,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  int getRoundScore(int roundNumber) {
    return ends
        .where((end) => end.roundNumber == roundNumber)
        .fold(0, (sum, end) => sum + end.endTotal);
  }

  List<End> getRoundEnds(int roundNumber) {
    return ends.where((end) => end.roundNumber == roundNumber).toList();
  }

  int get totalXs => ends.fold(0, (sum, end) => sum + end.xCount);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MatchScore && other.scoreId == scoreId;
  }

  @override
  int get hashCode => scoreId.hashCode;

  @override
  String toString() {
    return 'MatchScore(scoreId: $scoreId, userId: $userId, total: $totalScore, round: $currentRound/$currentEnd)';
  }
}

class MatchScoreWithUser {
  final MatchScore score;
  final User user;

  MatchScoreWithUser({
    required this.score,
    required this.user,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MatchScoreWithUser &&
        other.score == score &&
        other.user == user;
  }

  @override
  int get hashCode => score.hashCode ^ user.hashCode;

  @override
  String toString() {
    return 'MatchScoreWithUser(score: $score, user: $user)';
  }
}