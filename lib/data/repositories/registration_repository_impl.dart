import '../../domain/entities/match_registration.dart';
import '../../domain/repositories/registration_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/services/hive_service.dart';
import '../models/match_registration_model.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final UserRepository userRepository;

  RegistrationRepositoryImpl({required this.userRepository});

  @override
  Future<MatchRegistration> createRegistration(MatchRegistration registration) async {
    final model = MatchRegistrationModel.fromEntity(registration);
    
    final box = HiveService.registrationsBox;
    await box.put(registration.registrationId, model);
    
    return registration;
  }

  @override
  Future<MatchRegistration?> getRegistration(String registrationId) async {
    final box = HiveService.registrationsBox;
    final model = box.get(registrationId);
    return model?.toEntity();
  }

  @override
  Future<List<RegistrationWithUser>> getMatchRegistrations(String matchId) async {
    final box = HiveService.registrationsBox;
    final registrations = box.values
        .where((reg) => reg.matchId == matchId)
        .toList();

    final result = <RegistrationWithUser>[];
    
    for (final regModel in registrations) {
      final user = await userRepository.getUserById(regModel.userId);
      if (user != null) {
        result.add(RegistrationWithUser(
          registration: regModel.toEntity(),
          user: user,
        ));
      }
    }
    
    return result;
  }

  @override
  Future<List<MatchRegistration>> getRegistrationsByUser(String userId) async {
    final box = HiveService.registrationsBox;
    return box.values
        .where((reg) => reg.userId == userId)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<void> updateRegistration(MatchRegistration registration) async {
    final model = MatchRegistrationModel.fromEntity(registration);
    final box = HiveService.registrationsBox;
    await box.put(registration.registrationId, model);
  }

  @override
  Future<void> updateRegistrationStatus(String registrationId, {required bool isAccepted}) async {
    final box = HiveService.registrationsBox;
    final model = box.get(registrationId);
    
    if (model != null) {
      final updatedModel = model.copyWith(
        status: isAccepted ? RegistrationStatus.accepted : RegistrationStatus.rejected,
      );
      await box.put(registrationId, updatedModel);
    }
  }

  @override
  Future<void> acceptRegistration(String registrationId) async {
    await updateRegistrationStatus(registrationId, isAccepted: true);
  }

  @override
  Future<void> rejectRegistration(String registrationId) async {
    await updateRegistrationStatus(registrationId, isAccepted: false);
  }

  @override
  Future<void> deleteRegistration(String registrationId) async {
    final box = HiveService.registrationsBox;
    await box.delete(registrationId);
  }

  @override
  Future<List<MatchRegistration>> getAllRegistrations() async {
    final box = HiveService.registrationsBox;
    return box.values.map((model) => model.toEntity()).toList();
  }

  @override
  Stream<List<MatchRegistration>> watchRegistrations() {
    final box = HiveService.registrationsBox;
    return box.watch().map((_) {
      return box.values.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Stream<List<MatchRegistration>> watchRegistrationsByMatch(String matchId) {
    final box = HiveService.registrationsBox;
    return box.watch().map((_) {
      return box.values
          .where((reg) => reg.matchId == matchId)
          .map((model) => model.toEntity())
          .toList();
    });
  }
}