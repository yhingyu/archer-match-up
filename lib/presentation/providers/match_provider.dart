import 'package:flutter/foundation.dart';

import '../../domain/entities/match.dart';
import '../../domain/usecases/create_match.dart';
import '../../domain/usecases/get_matches.dart';
import '../../domain/repositories/match_repository.dart';

class MatchProvider extends ChangeNotifier {
  final CreateMatch _createMatch;
  final GetMatches _getMatches;
  final WatchMatches _watchMatches; // ignore: unused_field
  final MatchRepository _matchRepository;

  MatchProvider({
    required CreateMatch createMatch,
    required GetMatches getMatches,
    required WatchMatches watchMatches,
    required MatchRepository matchRepository,
  })  : _createMatch = createMatch,
        _getMatches = getMatches,
        _watchMatches = watchMatches,
        _matchRepository = matchRepository;

  List<Match> _matches = [];
  bool _isLoading = false;
  String? _error;

  List<Match> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMatches() async {
    try {
      _setLoading(true);
      _error = null;
      final matches = await _getMatches();
      _matches = matches;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error loading matches: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<Match?> getMatch(String matchId) async {
    try {
      return await _matchRepository.getMatch(matchId);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting match: $e');
      }
      return null;
    }
  }

  Future<void> updateMatch(Match match) async {
    try {
      _setLoading(true);
      _error = null;
      
      await _matchRepository.updateMatch(match);
      
      // Reload matches to show the updated one
      await loadMatches();
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error updating match: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteMatch(String matchId) async {
    try {
      _setLoading(true);
      _error = null;
      
      await _matchRepository.deleteMatch(matchId);
      
      // Reload matches to remove the deleted one
      await loadMatches();
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error deleting match: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createMatch({
    required String name,
    required int distance,
    required int numEnds,
    required int arrowsPerEnd,
    required int numberOfRounds,
  }) async {
    try {
      _setLoading(true);
      _error = null;

      final match = Match(
        matchId: DateTime.now().millisecondsSinceEpoch.toString(),
        creatorId: 'current_user', // TODO: Get from auth service
        title: name,
        maxTargets: 10, // Default max targets
        status: MatchStatus.pending,
        createdAt: DateTime.now(),
        arrowsPerEnd: arrowsPerEnd,
        totalEnds: numEnds,
        numberOfRounds: numberOfRounds,
        description: 'Match at ${distance}m distance, $numberOfRounds round${numberOfRounds == 1 ? '' : 's'}',
      );

      await _createMatch(match);
      
      // Reload matches to show the new one
      await loadMatches();
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error creating match: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}