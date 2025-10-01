import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/services/hive_service.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<void> createUser(User user) async {
    final model = UserModel.fromEntity(user);
    final box = HiveService.usersBox;
    await box.put(user.userId, model);
  }

  @override
  Future<User?> getUserById(String userId) async {
    final box = HiveService.usersBox;
    final model = box.get(userId);
    return model?.toEntity();
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final box = HiveService.usersBox;
    final users = box.values;
    
    for (final userModel in users) {
      if (userModel.email == email) {
        return userModel.toEntity();
      }
    }
    
    return null;
  }

  @override
  Future<List<User>> getAllUsers() async {
    final box = HiveService.usersBox;
    return box.values.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateUser(User user) async {
    final model = UserModel.fromEntity(user);
    final box = HiveService.usersBox;
    await box.put(user.userId, model);
  }

  @override
  Future<void> deleteUser(String userId) async {
    final box = HiveService.usersBox;
    await box.delete(userId);
  }

  @override
  Stream<List<User>> watchAllUsers() {
    final box = HiveService.usersBox;
    return box.watch().map((_) {
      return box.values.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Stream<User?> watchUser(String userId) {
    final box = HiveService.usersBox;
    return box.watch().map((_) {
      final model = box.get(userId);
      return model?.toEntity();
    });
  }
}