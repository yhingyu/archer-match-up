import 'package:flutter/foundation.dart';
import '../../domain/entities/match_registration.dart';
import '../../domain/usecases/register_for_match.dart';
import '../../domain/usecases/get_match_registrations.dart';
import '../../domain/usecases/manage_registration.dart';

class RegistrationProvider extends ChangeNotifier {
  final RegisterForMatch _registerForMatch;
  final GetMatchRegistrations _getMatchRegistrations;
  final ManageRegistration _manageRegistration;

  RegistrationProvider({
    required RegisterForMatch registerForMatch,
    required GetMatchRegistrations getMatchRegistrations,
    required ManageRegistration manageRegistration,
  })  : _registerForMatch = registerForMatch,
        _getMatchRegistrations = getMatchRegistrations,
        _manageRegistration = manageRegistration;

  List<RegistrationWithUser> _registrations = [];
  bool _isLoading = false;
  String? _error;

  List<RegistrationWithUser> get registrations => _registrations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadRegistrations(String matchId) async {
    try {
      _setLoading(true);
      _error = null;
      final registrations = await _getMatchRegistrations(matchId);
      _registrations = registrations;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error loading registrations: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> registerArcher({
    required String matchId,
    required String userName,
    String? email,
  }) async {
    try {
      _setLoading(true);
      _error = null;

      await _registerForMatch(
        matchId: matchId,
        userName: userName,
        email: email,
      );

      // Reload registrations to show the new one
      await loadRegistrations(matchId);
      return true;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error registering archer: $e');
      }
      _setLoading(false);
      return false;
    }
  }

  Future<void> acceptRegistration(String registrationId, String matchId) async {
    try {
      _setLoading(true);
      _error = null;

      await _manageRegistration.acceptRegistration(registrationId);
      
      // Reload registrations to show the update
      await loadRegistrations(matchId);
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error accepting registration: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> rejectRegistration(String registrationId, String matchId) async {
    try {
      _setLoading(true);
      _error = null;

      await _manageRegistration.rejectRegistration(registrationId);
      
      // Reload registrations to show the update
      await loadRegistrations(matchId);
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error rejecting registration: $e');
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

  List<RegistrationWithUser> getAcceptedRegistrations() {
    return _registrations
        .where((reg) => reg.registration.isAccepted)
        .toList();
  }

  List<RegistrationWithUser> getPendingRegistrations() {
    return _registrations
        .where((reg) => reg.registration.isPending)
        .toList();
  }
}