import '../entities/match_registration.dart';
import '../repositories/registration_repository.dart';

class GetMatchRegistrations {
  final RegistrationRepository repository;

  GetMatchRegistrations(this.repository);

  Future<List<RegistrationWithUser>> call(String matchId) async {
    return await repository.getMatchRegistrations(matchId);
  }
}