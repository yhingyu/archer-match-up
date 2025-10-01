import 'package:hive/hive.dart';
import '../../domain/entities/match.dart';

part 'match_model.g.dart';

@HiveType(typeId: 1)
class MatchModel extends HiveObject {
  @HiveField(0)
  String matchId;

  @HiveField(1)
  String creatorId;

  @HiveField(2)
  String title;

  @HiveField(3)
  int maxTargets;

  @HiveField(4)
  int status; // 0: pending, 1: ongoing, 2: completed

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  int arrowsPerEnd;

  @HiveField(7)
  int totalEnds;

  @HiveField(8)
  int numberOfRounds;

  @HiveField(9)
  String? description;

  MatchModel({
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

  factory MatchModel.fromEntity(Match match) {
    return MatchModel(
      matchId: match.matchId,
      creatorId: match.creatorId,
      title: match.title,
      maxTargets: match.maxTargets,
      status: match.status.index,
      createdAt: match.createdAt,
      arrowsPerEnd: match.arrowsPerEnd,
      totalEnds: match.totalEnds,
      numberOfRounds: match.numberOfRounds,
      description: match.description,
    );
  }

  Match toEntity() {
    return Match(
      matchId: matchId,
      creatorId: creatorId,
      title: title,
      maxTargets: maxTargets,
      status: MatchStatus.values[status],
      createdAt: createdAt,
      arrowsPerEnd: arrowsPerEnd,
      totalEnds: totalEnds,
      numberOfRounds: numberOfRounds,
      description: description,
    );
  }

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      matchId: json['matchId'] as String,
      creatorId: json['creatorId'] as String,
      title: json['title'] as String,
      maxTargets: json['maxTargets'] as int,
      status: json['status'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      arrowsPerEnd: json['arrowsPerEnd'] as int? ?? 3,
      totalEnds: json['totalEnds'] as int? ?? 10,
      numberOfRounds: json['numberOfRounds'] as int? ?? 1,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'creatorId': creatorId,
      'title': title,
      'maxTargets': maxTargets,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'arrowsPerEnd': arrowsPerEnd,
      'totalEnds': totalEnds,
      'numberOfRounds': numberOfRounds,
      'description': description,
    };
  }

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      matchId: map['matchId'] as String,
      creatorId: map['creatorId'] as String,
      title: map['title'] as String,
      maxTargets: map['maxTargets'] as int,
      status: map['status'] as int,
      createdAt: map['createdAt'] is String
          ? DateTime.parse(map['createdAt'] as String)
          : map['createdAt'] as DateTime,
      arrowsPerEnd: map['arrowsPerEnd'] as int? ?? 3,
      totalEnds: map['totalEnds'] as int? ?? 10,
      numberOfRounds: map['numberOfRounds'] as int? ?? 1,
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'matchId': matchId,
      'creatorId': creatorId,
      'title': title,
      'maxTargets': maxTargets,
      'status': status,
      'createdAt': createdAt,
      'arrowsPerEnd': arrowsPerEnd,
      'totalEnds': totalEnds,
      'numberOfRounds': numberOfRounds,
      'description': description,
    };
  }
}