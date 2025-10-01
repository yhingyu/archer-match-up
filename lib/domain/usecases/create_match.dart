import '../entities/match.dart';
import '../repositories/match_repository.dart';

class CreateMatch {
  final MatchRepository repository;

  CreateMatch(this.repository);

  Future<void> call(Match match) async {
    await repository.createMatch(match);
  }
}