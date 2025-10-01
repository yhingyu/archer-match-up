import '../entities/match_registration.dart';

abstract class RegistrationRepository {
  Future<MatchRegistration> createRegistration(MatchRegistration registration);
  Future<MatchRegistration?> getRegistration(String registrationId);
  Future<List<RegistrationWithUser>> getMatchRegistrations(String matchId);
  Future<List<MatchRegistration>> getRegistrationsByUser(String userId);
  Future<void> updateRegistration(MatchRegistration registration);
  Future<void> updateRegistrationStatus(String registrationId, {required bool isAccepted});
  Future<void> deleteRegistration(String registrationId);
  Future<void> acceptRegistration(String registrationId);
  Future<void> rejectRegistration(String registrationId);
  Future<List<MatchRegistration>> getAllRegistrations();
  Stream<List<MatchRegistration>> watchRegistrations();
  Stream<List<MatchRegistration>> watchRegistrationsByMatch(String matchId);
}