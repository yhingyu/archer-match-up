import 'user.dart';

enum RegistrationStatus { pending, accepted, rejected }

class MatchRegistration {
  final String registrationId;
  final String matchId;
  final String userId;
  final RegistrationStatus status;
  final int? assignedTarget;
  final String? shootingOrder;
  final DateTime createdAt;

  const MatchRegistration({
    required this.registrationId,
    required this.matchId,
    required this.userId,
    required this.status,
    this.assignedTarget,
    this.shootingOrder,
    required this.createdAt,
  });

  MatchRegistration copyWith({
    String? registrationId,
    String? matchId,
    String? userId,
    RegistrationStatus? status,
    int? assignedTarget,
    String? shootingOrder,
    DateTime? createdAt,
  }) {
    return MatchRegistration(
      registrationId: registrationId ?? this.registrationId,
      matchId: matchId ?? this.matchId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      assignedTarget: assignedTarget ?? this.assignedTarget,
      shootingOrder: shootingOrder ?? this.shootingOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isAccepted => status == RegistrationStatus.accepted;
  bool get isPending => status == RegistrationStatus.pending;
  bool get isRejected => status == RegistrationStatus.rejected;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MatchRegistration && other.registrationId == registrationId;
  }

  @override
  int get hashCode => registrationId.hashCode;

  @override
  String toString() {
    return 'MatchRegistration(registrationId: $registrationId, matchId: $matchId, userId: $userId, status: $status)';
  }
}

class RegistrationWithUser {
  final MatchRegistration registration;
  final User user;

  RegistrationWithUser({
    required this.registration,
    required this.user,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegistrationWithUser &&
        other.registration == registration &&
        other.user == user;
  }

  @override
  int get hashCode => registration.hashCode ^ user.hashCode;

  @override
  String toString() {
    return 'RegistrationWithUser(registration: $registration, user: $user)';
  }
}