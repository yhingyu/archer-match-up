class TargetAssignment {
  final String assignmentId;
  final String matchId;
  final int targetNumber;
  final List<AssignedArcher> archers;
  final DateTime createdAt;

  const TargetAssignment({
    required this.assignmentId,
    required this.matchId,
    required this.targetNumber,
    required this.archers,
    required this.createdAt,
  });

  TargetAssignment copyWith({
    String? assignmentId,
    String? matchId,
    int? targetNumber,
    List<AssignedArcher>? archers,
    DateTime? createdAt,
  }) {
    return TargetAssignment(
      assignmentId: assignmentId ?? this.assignmentId,
      matchId: matchId ?? this.matchId,
      targetNumber: targetNumber ?? this.targetNumber,
      archers: archers ?? this.archers,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isFull => archers.length >= 4; // Standard target capacity
  bool get isEmpty => archers.isEmpty;
  int get availableSpots => 4 - archers.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TargetAssignment && other.assignmentId == assignmentId;
  }

  @override
  int get hashCode => assignmentId.hashCode;

  @override
  String toString() {
    return 'TargetAssignment(assignmentId: $assignmentId, matchId: $matchId, targetNumber: $targetNumber, archers: ${archers.length})';
  }
}

class AssignedArcher {
  final String userId;
  final String name;
  final String shootingPosition; // A, B, C, D
  final int shootingOrder; // 1-4

  const AssignedArcher({
    required this.userId,
    required this.name,
    required this.shootingPosition,
    required this.shootingOrder,
  });

  AssignedArcher copyWith({
    String? userId,
    String? name,
    String? shootingPosition,
    int? shootingOrder,
  }) {
    return AssignedArcher(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      shootingPosition: shootingPosition ?? this.shootingPosition,
      shootingOrder: shootingOrder ?? this.shootingOrder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssignedArcher && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;

  @override
  String toString() {
    return 'AssignedArcher(userId: $userId, name: $name, position: $shootingPosition, order: $shootingOrder)';
  }
}