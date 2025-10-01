import 'package:flutter/foundation.dart';
import '../../domain/entities/match_score.dart';
import '../../domain/usecases/record_end.dart';
import '../../domain/usecases/get_match_scores.dart';
import '../../domain/usecases/start_match.dart';

class ScoringProvider extends ChangeNotifier {
  final RecordEnd _recordEnd;
  final GetMatchScores _getMatchScores;
  final StartMatch _startMatch;

  ScoringProvider({
    required RecordEnd recordEnd,
    required GetMatchScores getMatchScores,
    required StartMatch startMatch,
  })  : _recordEnd = recordEnd,
        _getMatchScores = getMatchScores,
        _startMatch = startMatch;

  List<MatchScoreWithUser> _scores = [];
  MatchScore? _currentUserScore;
  bool _isLoading = false;
  String? _error;

  List<MatchScoreWithUser> get scores => _scores;
  MatchScore? get currentUserScore => _currentUserScore;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> startMatch(String matchId) async {
    try {
      _setLoading(true);
      _error = null;
      
      await _startMatch(matchId);
      
      if (kDebugMode) {
        print('Match started: $matchId');
      }
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error starting match: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadScores(String matchId) async {
    try {
      _setLoading(true);
      _error = null;
      
      final scores = await _getMatchScores(matchId);
      _scores = scores;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error loading scores: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> recordEnd({
    required String matchId,
    required String userId,
    required int roundNumber,
    required int endNumber,
    required List<String> arrows,
  }) async {
    try {
      _setLoading(true);
      _error = null;

      await _recordEnd(
        matchId: matchId,
        userId: userId,
        roundNumber: roundNumber,
        endNumber: endNumber,
        arrows: arrows,
      );

      // Reload scores to show the update
      await loadScores(matchId);
      
      if (kDebugMode) {
        print('End recorded: R$roundNumber E$endNumber - ${arrows.join(", ")}');
      }
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error recording end: $e');
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

  MatchScoreWithUser? getUserScore(String userId) {
    try {
      return _scores.firstWhere((score) => score.user.userId == userId);
    } catch (e) {
      return null;
    }
  }

  List<MatchScoreWithUser> getLeaderboard() {
    final sortedScores = List<MatchScoreWithUser>.from(_scores);
    sortedScores.sort((a, b) {
      // Sort by total score first
      final scoreComparison = b.score.totalScore.compareTo(a.score.totalScore);
      if (scoreComparison != 0) return scoreComparison;
      
      // If tied, sort by X count
      return b.score.totalXs.compareTo(a.score.totalXs);
    });
    return sortedScores;
  }
}