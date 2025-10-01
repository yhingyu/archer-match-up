enum MatchStatus { pending, ongoing, completed }

class Match {
  final String matchId;
  final String creatorId;
  final String title;
  final int maxTargets;
  final MatchStatus status;
  final DateTime createdAt;
  final int arrowsPerEnd;
  final int totalEnds;
  final int numberOfRounds;
  final String? description;

  const Match({
    required this.matchId,
    required this.creatorId,
    required this.title,
    required this.maxTargets,
    required this.status,
    required this.createdAt,
    this.arrowsPerEnd = 3,
    this.totalEnds = 10,
    this.numberOfRounds = 1,
    this.description,
  });

  Match copyWith({
    String? matchId,
    String? creatorId,
    String? title,
    int? maxTargets,
    MatchStatus? status,
    DateTime? createdAt,
    int? arrowsPerEnd,
    int? totalEnds,
    int? numberOfRounds,
    String? description,
  }) {
    return Match(
      matchId: matchId ?? this.matchId,
      creatorId: creatorId ?? this.creatorId,
      title: title ?? this.title,
      maxTargets: maxTargets ?? this.maxTargets,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      arrowsPerEnd: arrowsPerEnd ?? this.arrowsPerEnd,
      totalEnds: totalEnds ?? this.totalEnds,
      numberOfRounds: numberOfRounds ?? this.numberOfRounds,
      description: description ?? this.description,
    );
  }

  String get matchCode => matchId.substring(0, 8).toUpperCase();

  bool get isOngoing => status == MatchStatus.ongoing;
  bool get isCompleted => status == MatchStatus.completed;
  bool get isPending => status == MatchStatus.pending;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Match && other.matchId == matchId;
  }

  @override
  int get hashCode => matchId.hashCode;

  @override
  String toString() {
    return 'Match(matchId: $matchId, title: $title, status: $status)';
  }
}