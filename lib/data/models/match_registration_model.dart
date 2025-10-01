import 'package:hive/hive.dart';
import '../../domain/entities/match_registration.dart';

part 'match_registration_model.g.dart';

@HiveType(typeId: 2)
class MatchRegistrationModel extends HiveObject {
  @HiveField(0)
  String registrationId;

  @HiveField(1)
  String matchId;

  @HiveField(2)
  String userId;

  @HiveField(3)
  int status; // 0: pending, 1: accepted, 2: rejected

  @HiveField(4)
  int? assignedTarget;

  @HiveField(5)
  String? shootingOrder;

  @HiveField(6)
  DateTime createdAt;

  MatchRegistrationModel({
    required this.registrationId,
    required this.matchId,
    required this.userId,
    required this.status,
    this.assignedTarget,
    this.shootingOrder,
    required this.createdAt,
  });

  factory MatchRegistrationModel.fromEntity(MatchRegistration registration) {
    return MatchRegistrationModel(
      registrationId: registration.registrationId,
      matchId: registration.matchId,
      userId: registration.userId,
      status: registration.status.index,
      assignedTarget: registration.assignedTarget,
      shootingOrder: registration.shootingOrder,
      createdAt: registration.createdAt,
    );
  }

  MatchRegistration toEntity() {
    return MatchRegistration(
      registrationId: registrationId,
      matchId: matchId,
      userId: userId,
      status: RegistrationStatus.values[status],
      assignedTarget: assignedTarget,
      shootingOrder: shootingOrder,
      createdAt: createdAt,
    );
  }

  factory MatchRegistrationModel.fromJson(Map<String, dynamic> json) {
    return MatchRegistrationModel(
      registrationId: json['registrationId'] as String,
      matchId: json['matchId'] as String,
      userId: json['userId'] as String,
      status: json['status'] as int,
      assignedTarget: json['assignedTarget'] as int?,
      shootingOrder: json['shootingOrder'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registrationId': registrationId,
      'matchId': matchId,
      'userId': userId,
      'status': status,
      'assignedTarget': assignedTarget,
      'shootingOrder': shootingOrder,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MatchRegistrationModel.fromMap(Map<String, dynamic> map) {
    return MatchRegistrationModel(
      registrationId: map['registrationId'] as String,
      matchId: map['matchId'] as String,
      userId: map['userId'] as String,
      status: map['status'] as int,
      assignedTarget: map['assignedTarget'] as int?,
      shootingOrder: map['shootingOrder'] as String?,
      createdAt: map['createdAt'] is String
          ? DateTime.parse(map['createdAt'] as String)
          : map['createdAt'] as DateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'registrationId': registrationId,
      'matchId': matchId,
      'userId': userId,
      'status': status,
      'assignedTarget': assignedTarget,
      'shootingOrder': shootingOrder,
      'createdAt': createdAt,
    };
  }

  MatchRegistrationModel copyWith({
    String? registrationId,
    String? matchId,
    String? userId,
    RegistrationStatus? status,
    int? assignedTarget,
    String? shootingOrder,
    DateTime? createdAt,
  }) {
    return MatchRegistrationModel(
      registrationId: registrationId ?? this.registrationId,
      matchId: matchId ?? this.matchId,
      userId: userId ?? this.userId,
      status: status?.index ?? this.status,
      assignedTarget: assignedTarget ?? this.assignedTarget,
      shootingOrder: shootingOrder ?? this.shootingOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}