import 'package:hive/hive.dart';
import '../../domain/entities/end.dart';

part 'end_model.g.dart';

@HiveType(typeId: 3)
class EndModel extends HiveObject {
  @HiveField(0)
  String endId;

  @HiveField(1)
  String matchId;

  @HiveField(2)
  String userId;

  @HiveField(3)
  int roundNumber;

  @HiveField(4)
  int endNumber;

  @HiveField(5)
  List<String> arrows;

  @HiveField(6)
  int endTotal;

  @HiveField(7)
  int arrowsPerEnd;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime? completedAt;

  EndModel({
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

  factory EndModel.fromEntity(End end) {
    return EndModel(
      endId: end.endId,
      matchId: end.matchId,
      userId: end.userId,
      roundNumber: end.roundNumber,
      endNumber: end.endNumber,
      arrows: List.from(end.arrows),
      endTotal: end.endTotal,
      arrowsPerEnd: end.arrowsPerEnd,
      createdAt: end.createdAt,
      completedAt: end.completedAt,
    );
  }

  End toEntity() {
    return End(
      endId: endId,
      matchId: matchId,
      userId: userId,
      roundNumber: roundNumber,
      endNumber: endNumber,
      arrows: List.from(arrows),
      endTotal: endTotal,
      arrowsPerEnd: arrowsPerEnd,
      createdAt: createdAt,
      completedAt: completedAt,
    );
  }

  EndModel copyWith({
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
    return EndModel(
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
}