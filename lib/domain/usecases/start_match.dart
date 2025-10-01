import '../entities/match.dart';
import '../entities/match_score.dart';
import '../repositories/match_repository.dart';
import '../repositories/registration_repository.dart';
import '../repositories/match_score_repository.dart';

class StartMatch {
  final MatchRepository matchRepository;
  final RegistrationRepository registrationRepository;
  final MatchScoreRepository scoreRepository;

  StartMatch({
    required this.matchRepository,
    required this.registrationRepository,
    required this.scoreRepository,
  });

  Future<void> call(String matchId) async {
    // Get the match
    final match = await matchRepository.getMatch(matchId);
    if (match == null) {
      throw Exception('Match not found');
    }

    if (match.status != MatchStatus.pending) {
      throw Exception('Match can only be started from pending status');
    }

    // Get accepted registrations
    final registrations = await registrationRepository.getMatchRegistrations(matchId);
    final acceptedRegistrations = registrations
        .where((reg) => reg.registration.isAccepted)
        .toList();

    if (acceptedRegistrations.isEmpty) {
      throw Exception('No accepted registrations found for this match');
    }

    // Update match status to ongoing
    final updatedMatch = match.copyWith(status: MatchStatus.ongoing);
    await matchRepository.updateMatch(updatedMatch);

    // Create initial score entries for each archer
    for (final registration in acceptedRegistrations) {
      final score = MatchScore(
        scoreId: '${matchId}_${registration.user.userId}',
        matchId: matchId,
        userId: registration.user.userId,
        ends: [],
        totalScore: 0,
        currentRound: 1,
        currentEnd: 1,
        isComplete: false,
        createdAt: DateTime.now(),
      );

      await scoreRepository.createScore(score);
    }
  }
}