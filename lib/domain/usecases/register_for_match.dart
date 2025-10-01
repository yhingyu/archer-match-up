import '../entities/match_registration.dart';
import '../entities/user.dart';
import '../repositories/registration_repository.dart';
import '../repositories/user_repository.dart';

class RegisterForMatch {
  final RegistrationRepository registrationRepository;
  final UserRepository userRepository;

  RegisterForMatch({
    required this.registrationRepository,
    required this.userRepository,
  });

  Future<MatchRegistration> call({
    required String matchId,
    required String userName,
    String? email,
  }) async {
    // Check if user exists, if not create one
    User? user;
    
    if (email != null && email.isNotEmpty) {
      final users = await userRepository.getAllUsers();
      try {
        user = users.firstWhere((u) => u.email == email);
      } catch (e) {
        user = null;
      }
    }
    
    if (user == null) {
      // Create new user
      user = User(
        userId: DateTime.now().millisecondsSinceEpoch.toString(),
        name: userName,
        email: email,
        createdAt: DateTime.now(),
      );
      
      await userRepository.createUser(user);
    }

    // Create registration
    final registration = MatchRegistration(
      registrationId: DateTime.now().millisecondsSinceEpoch.toString(),
      matchId: matchId,
      userId: user.userId,
      status: RegistrationStatus.pending,
      createdAt: DateTime.now(),
    );

    await registrationRepository.createRegistration(registration);
    return registration;
  }
}