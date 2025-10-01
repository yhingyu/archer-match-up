import '../entities/match.dart';
import '../repositories/match_repository.dart';

class GetMatches {
  final MatchRepository repository;

  GetMatches(this.repository);

  Future<List<Match>> call() async {
    return await repository.getAllMatches();
  }
}

class WatchMatches {
  final MatchRepository repository;

  WatchMatches(this.repository);

  Stream<List<Match>> call() {
    return repository.watchAllMatches();
  }
}