import '../entities/target_assignment.dart';
import '../entities/match_registration.dart';
import '../entities/user.dart';
import '../entities/match.dart';
import '../repositories/match_repository.dart';
import '../repositories/registration_repository.dart';
import '../repositories/user_repository.dart';

class AssignTargets {
  final MatchRepository matchRepository;
  final RegistrationRepository registrationRepository;
  final UserRepository userRepository;

  AssignTargets(
    this.matchRepository,
    this.registrationRepository,
    this.userRepository,
  );

  Future<List<TargetAssignment>> call(String matchId) async {
    // Get match details
    final match = await matchRepository.getMatch(matchId);
    if (match == null) {
      throw Exception('Match not found');
    }

    // Get accepted registrations
    final registrations = await registrationRepository.getRegistrationsByUser('');
    final registrationsForMatch = registrations.where((r) => r.matchId == matchId).toList();
    final acceptedRegistrations = registrations
        .where((reg) => reg.status == RegistrationStatus.accepted)
        .toList();

    if (acceptedRegistrations.isEmpty) {
      return [];
    }

    // Get user details for each registration
    final users = <User>[];
    for (final registration in acceptedRegistrations) {
      final user = await userRepository.getUserById(registration.userId);
      if (user != null) {
        users.add(user);
      }
    }

    // Sort users alphabetically by name
    users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    // Assign targets using round-robin algorithm
    return _assignTargetsAlgorithm(match, users);
  }

  List<TargetAssignment> _assignTargetsAlgorithm(Match match, List<User> users) {
    final assignments = <TargetAssignment>[];
    final maxArchersPerTarget = 4;
    final totalTargets = match.maxTargets;

    // Calculate how many targets we actually need
    final requiredTargets = (users.length / maxArchersPerTarget).ceil();
    final targetsToUse = requiredTargets > totalTargets ? totalTargets : requiredTargets;

    // Initialize targets
    for (int i = 1; i <= targetsToUse; i++) {
      assignments.add(TargetAssignment(
        assignmentId: '${match.matchId}_target_$i',
        matchId: match.matchId,
        targetNumber: i,
        archers: [],
        createdAt: DateTime.now(),
      ));
    }

    // Assign archers to targets in round-robin fashion
    final shootingPositions = ['A', 'B', 'C', 'D'];
    
    for (int userIndex = 0; userIndex < users.length; userIndex++) {
      final user = users[userIndex];
      final targetIndex = userIndex % targetsToUse;
      final positionIndex = (userIndex ~/ targetsToUse) % maxArchersPerTarget;
      
      if (positionIndex < maxArchersPerTarget) {
        final assignedArcher = AssignedArcher(
          userId: user.userId,
          name: user.name,
          shootingPosition: shootingPositions[positionIndex],
          shootingOrder: positionIndex + 1,
        );

        // Update the target assignment
        final updatedArchers = List<AssignedArcher>.from(assignments[targetIndex].archers)
          ..add(assignedArcher);
        
        assignments[targetIndex] = assignments[targetIndex].copyWith(
          archers: updatedArchers,
        );
      }
    }

    return assignments;
  }
}

class GetTargetAssignments {
  final MatchRepository matchRepository;

  GetTargetAssignments(this.matchRepository);

  Future<List<TargetAssignment>> call(String matchId) async {
    // This would typically fetch from a repository
    // For now, we'll use the assign targets use case
    throw UnimplementedError('GetTargetAssignments not implemented yet');
  }
}