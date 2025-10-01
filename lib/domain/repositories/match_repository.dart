import '../entities/match.dart';

abstract class MatchRepository {
  Future<void> createMatch(Match match);
  Future<Match?> getMatch(String matchId);
  Future<List<Match>> getAllMatches();
  Future<List<Match>> getMatchesByCreator(String creatorId);
  Future<void> updateMatch(Match match);
  Future<void> deleteMatch(String matchId);
  Stream<List<Match>> watchAllMatches();
  Stream<Match?> watchMatch(String matchId);
  Future<Match?> getMatchByCode(String matchCode);
}