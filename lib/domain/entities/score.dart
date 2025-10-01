class Score {
  final String scoreId;
  final String endId;
  final String registrationId;
  final int arrowNumber;
  final String score; // Can be "0"-"10", "X", "M"
  final DateTime createdAt;

  const Score({
    required this.scoreId,
    required this.endId,
    required this.registrationId,
    required this.arrowNumber,
    required this.score,
    required this.createdAt,
  });

  Score copyWith({
    String? scoreId,
    String? endId,
    String? registrationId,
    int? arrowNumber,
    String? score,
    DateTime? createdAt,
  }) {
    return Score(
      scoreId: scoreId ?? this.scoreId,
      endId: endId ?? this.endId,
      registrationId: registrationId ?? this.registrationId,
      arrowNumber: arrowNumber ?? this.arrowNumber,
      score: score ?? this.score,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Returns numerical value of the score
  int get numericValue {
    switch (score.toUpperCase()) {
      case 'X':
        return 10;
      case 'M':
        return 0;
      default:
        return int.tryParse(score) ?? 0;
    }
  }

  /// Returns true if this is an X (inner 10)
  bool get isX => score.toUpperCase() == 'X';

  /// Returns true if this is a miss
  bool get isMiss => score.toUpperCase() == 'M';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Score && other.scoreId == scoreId;
  }

  @override
  int get hashCode => scoreId.hashCode;

  @override
  String toString() {
    return 'Score(scoreId: $scoreId, endId: $endId, arrowNumber: $arrowNumber, score: $score)';
  }
}