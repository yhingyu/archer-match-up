import '../entities/match_registration.dart';

abstract class MatchRegistrationRepository {
  Future<void> createRegistration(MatchRegistration registration);
  Future<MatchRegistration?> getRegistration(String registrationId);
  Future<List<MatchRegistration>> getRegistrationsByMatch(String matchId);
  Future<List<MatchRegistration>> getRegistrationsByUser(String userId);
  Future<MatchRegistration?> getRegistrationByMatchAndUser(String matchId, String userId);
  Future<void> updateRegistration(MatchRegistration registration);
  Future<void> deleteRegistration(String registrationId);
  Stream<List<MatchRegistration>> watchRegistrationsByMatch(String matchId);
  Future<void> approveRegistration(String registrationId, int targetNumber, String shootingOrder);
  Future<void> rejectRegistration(String registrationId);
}