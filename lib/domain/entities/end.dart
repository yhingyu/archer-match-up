class End {
  final String endId;
  final String matchId;
  final String userId;
  final int roundNumber;
  final int endNumber;
  final List<String> arrows; // Stores "0"-"10", "X", "M"
  final int endTotal;
  final int arrowsPerEnd;
  final DateTime createdAt;
  final DateTime? completedAt;

  const End({
    required this.endId,
    required this.matchId,
    required this.userId,
    required this.roundNumber,
    required this.endNumber,
    required this.arrows,
    required this.endTotal,
    required this.arrowsPerEnd,
    required this.createdAt,
    this.completedAt,
  });

  bool get isComplete => arrows.length >= arrowsPerEnd && completedAt != null;
  
  int get xCount => arrows.where((arrow) => arrow.toUpperCase() == 'X').length;
  
  End copyWith({
    String? endId,
    String? matchId,
    String? userId,
    int? roundNumber,
    int? endNumber,
    List<String>? arrows,
    int? endTotal,
    int? arrowsPerEnd,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return End(
      endId: endId ?? this.endId,
      matchId: matchId ?? this.matchId,
      userId: userId ?? this.userId,
      roundNumber: roundNumber ?? this.roundNumber,
      endNumber: endNumber ?? this.endNumber,
      arrows: arrows ?? this.arrows,
      endTotal: endTotal ?? this.endTotal,
      arrowsPerEnd: arrowsPerEnd ?? this.arrowsPerEnd,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Calculates total score from arrows
  static int calculateTotal(List<String> arrows) {
    return arrows.fold(0, (sum, arrow) {
      switch (arrow.toUpperCase()) {
        case 'X':
          return sum + 10;
        case 'M':
          return sum + 0;
        default:
          return sum + (int.tryParse(arrow) ?? 0);
      }
    });
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is End && other.endId == endId;
  }

  @override
  int get hashCode => endId.hashCode;

  @override
  String toString() {
    return 'End(endId: $endId, userId: $userId, round: $roundNumber, end: $endNumber, total: $endTotal)';
  }
}