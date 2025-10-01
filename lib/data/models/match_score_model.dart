import 'package:hive/hive.dart';
import '../../domain/entities/match_score.dart';
import '../../domain/entities/end.dart';

part 'match_score_model.g.dart';

@HiveType(typeId: 4)
class MatchScoreModel extends HiveObject {
  @HiveField(0)
  String scoreId;

  @HiveField(1)
  String matchId;

  @HiveField(2)
  String userId;

  @HiveField(3)
  int totalScore;

  @HiveField(4)
  int currentRound;

  @HiveField(5)
  int currentEnd;

  @HiveField(6)
  bool isComplete;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? completedAt;

  MatchScoreModel({
    required this.scoreId,
    required this.matchId,
    required this.userId,
    required this.totalScore,
    required this.currentRound,
    required this.currentEnd,
    required this.isComplete,
    required this.createdAt,
    this.completedAt,
  });

  factory MatchScoreModel.fromEntity(MatchScore score) {
    return MatchScoreModel(
      scoreId: score.scoreId,
      matchId: score.matchId,
      userId: score.userId,
      totalScore: score.totalScore,
      currentRound: score.currentRound,
      currentEnd: score.currentEnd,
      isComplete: score.isComplete,
      createdAt: score.createdAt,
      completedAt: score.completedAt,
    );
  }

  MatchScore toEntity(List<End> ends) {
    return MatchScore(
      scoreId: scoreId,
      matchId: matchId,
      userId: userId,
      ends: ends,
      totalScore: totalScore,
      currentRound: currentRound,
      currentEnd: currentEnd,
      isComplete: isComplete,
      createdAt: createdAt,
      completedAt: completedAt,
    );
  }

  MatchScoreModel copyWith({
    String? scoreId,
    String? matchId,
    String? userId,
    int? totalScore,
    int? currentRound,
    int? currentEnd,
    bool? isComplete,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return MatchScoreModel(
      scoreId: scoreId ?? this.scoreId,
      matchId: matchId ?? this.matchId,
      userId: userId ?? this.userId,
      totalScore: totalScore ?? this.totalScore,
      currentRound: currentRound ?? this.currentRound,
      currentEnd: currentEnd ?? this.currentEnd,
      isComplete: isComplete ?? this.isComplete,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}