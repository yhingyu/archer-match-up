import 'package:hive/hive.dart';

import '../../domain/entities/match.dart';
import '../../domain/repositories/match_repository.dart';
import '../models/match_model.dart';

class MatchRepositoryImpl implements MatchRepository {
  static const String _boxName = 'matches';
  
  late Box<MatchModel> _matchBox;

  MatchRepositoryImpl() {
    _initBox();
  }

  Future<void> _initBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _matchBox = await Hive.openBox<MatchModel>(_boxName);
    } else {
      _matchBox = Hive.box<MatchModel>(_boxName);
    }
  }

  @override
  Future<void> createMatch(Match match) async {
    try {
      await _initBox();
      
      final matchModel = MatchModel.fromEntity(match);
      
      // Save to local storage only (offline mode)
      await _matchBox.put(match.matchId, matchModel);
      
      print('Match created offline: ${match.title}');
    } catch (e) {
      throw Exception('Failed to create match: $e');
    }
  }

  @override
  Future<Match?> getMatch(String matchId) async {
    try {
      await _initBox();
      
      // Get from local storage only (offline mode)
      final localMatch = _matchBox.get(matchId);
      if (localMatch != null) {
        return localMatch.toEntity();
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to get match: $e');
    }
  }

  @override
  Future<List<Match>> getAllMatches() async {
    try {
      await _initBox();
      
      // Get local matches only (offline mode)
      final localMatches = _matchBox.values
          .map((model) => model.toEntity())
          .toList();
      
      return localMatches
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      throw Exception('Failed to get all matches: $e');
    }
  }

  @override
  Future<List<Match>> getMatchesByCreator(String creatorId) async {
    try {
      await _initBox();
      
      // Get local matches by creator only (offline mode)
      final localMatches = _matchBox.values
          .where((model) => model.creatorId == creatorId)
          .map((model) => model.toEntity())
          .toList();
      
      return localMatches
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      throw Exception('Failed to get matches by creator: $e');
    }
  }

  @override
  Future<void> updateMatch(Match match) async {
    try {
      await _initBox();
      
      final matchModel = MatchModel.fromEntity(match);
      
      // Update local storage only (offline mode)
      await _matchBox.put(match.matchId, matchModel);
      
      print('Match updated offline: ${match.title}');
    } catch (e) {
      throw Exception('Failed to update match: $e');
    }
  }

  @override
  Future<void> deleteMatch(String matchId) async {
    try {
      await _initBox();
      
      // Delete from local storage only (offline mode)
      await _matchBox.delete(matchId);
      
      print('Match deleted offline: $matchId');
    } catch (e) {
      throw Exception('Failed to delete match: $e');
    }
  }

  @override
  Stream<List<Match>> watchAllMatches() {
    try {
      // Return local data stream only (offline mode)
      return Stream.value(_matchBox.values
          .map((model) => model.toEntity())
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
    } catch (e) {
      return Stream.value([]);
    }
  }

  @override
  Stream<Match?> watchMatch(String matchId) {
    try {
      // Return local data only (offline mode)
      final localMatch = _matchBox.get(matchId);
      return Stream.value(localMatch?.toEntity());
    } catch (e) {
      return Stream.value(null);
    }
  }

  @override
  Future<Match?> getMatchByCode(String matchCode) async {
    try {
      await _initBox();
      
      // Search local matches only (offline mode)
      for (final matchModel in _matchBox.values) {
        final match = matchModel.toEntity();
        if (match.matchCode == matchCode.toUpperCase()) {
          return match;
        }
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to get match by code: $e');
    }
  }
}