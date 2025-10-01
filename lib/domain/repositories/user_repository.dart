import '../entities/user.dart';

abstract class UserRepository {
  Future<void> createUser(User user);
  Future<User?> getUserById(String userId);
  Future<User?> getUserByEmail(String email);
  Future<List<User>> getAllUsers();
  Future<void> updateUser(User user);
  Future<void> deleteUser(String userId);
  Stream<List<User>> watchAllUsers();
  Stream<User?> watchUser(String userId);
}