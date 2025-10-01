import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  DateTime createdAt;

  UserModel({
    required this.userId,
    required this.name,
    this.email,
    required this.createdAt,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      userId: user.userId,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt,
    );
  }

  User toEntity() {
    return User(
      userId: userId,
      name: name,
      email: email,
      createdAt: createdAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}