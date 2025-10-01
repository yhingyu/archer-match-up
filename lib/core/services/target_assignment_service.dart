import '../../domain/entities/target_assignment.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/match.dart';

class TargetAssignmentService {
  static const int maxArchersPerTarget = 4;
  static const List<String> shootingPositions = ['A', 'B', 'C', 'D'];

  /// Assigns archers to targets using alphabetical order and round-robin distribution
  static List<TargetAssignment> assignTargets({
    required Match match,
    required List<User> archers,
  }) {
    if (archers.isEmpty) {
      return [];
    }

    // Sort archers alphabetically by name (case-insensitive)
    final sortedArchers = List<User>.from(archers)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    // Calculate how many targets we need
    final requiredTargets = (sortedArchers.length / maxArchersPerTarget).ceil();
    final targetsToUse = requiredTargets > match.maxTargets 
        ? match.maxTargets 
        : requiredTargets;

    // Initialize target assignments
    final assignments = <TargetAssignment>[];
    for (int i = 1; i <= targetsToUse; i++) {
      assignments.add(TargetAssignment(
        assignmentId: '${match.matchId}_target_$i',
        matchId: match.matchId,
        targetNumber: i,
        archers: [],
        createdAt: DateTime.now(),
      ));
    }

    // Assign archers using round-robin algorithm
    for (int archerIndex = 0; archerIndex < sortedArchers.length; archerIndex++) {
      final archer = sortedArchers[archerIndex];
      final targetIndex = archerIndex % targetsToUse;
      final positionIndex = archerIndex ~/ targetsToUse;
      
      // Skip if target is already full
      if (positionIndex >= maxArchersPerTarget) {
        continue;
      }

      final assignedArcher = AssignedArcher(
        userId: archer.userId,
        name: archer.name,
        shootingPosition: shootingPositions[positionIndex],
        shootingOrder: positionIndex + 1,
      );

      // Add archer to target
      final updatedArchers = List<AssignedArcher>.from(assignments[targetIndex].archers)
        ..add(assignedArcher);
      
      assignments[targetIndex] = assignments[targetIndex].copyWith(
        archers: updatedArchers,
      );
    }

    return assignments;
  }

  /// Validates target assignments
  static bool validateAssignments(List<TargetAssignment> assignments) {
    for (final assignment in assignments) {
      // Check if target has too many archers
      if (assignment.archers.length > maxArchersPerTarget) {
        return false;
      }
      
      // Check for duplicate shooting positions within target
      final positions = assignment.archers.map((a) => a.shootingPosition).toList();
      if (positions.length != positions.toSet().length) {
        return false;
      }
      
      // Check for duplicate shooting orders within target
      final orders = assignment.archers.map((a) => a.shootingOrder).toList();
      if (orders.length != orders.toSet().length) {
        return false;
      }
    }
    
    return true;
  }

  /// Gets summary statistics for target assignments
  static Map<String, dynamic> getAssignmentStats(List<TargetAssignment> assignments) {
    final totalArchers = assignments.fold<int>(0, (sum, assignment) => sum + assignment.archers.length);
    final totalTargets = assignments.length;
    final fullTargets = assignments.where((assignment) => assignment.isFull).length;
    final emptyTargets = assignments.where((assignment) => assignment.isEmpty).length;
    
    return {
      'totalArchers': totalArchers,
      'totalTargets': totalTargets,
      'fullTargets': fullTargets,
      'emptyTargets': emptyTargets,
      'averageArchersPerTarget': totalTargets > 0 ? totalArchers / totalTargets : 0.0,
    };
  }
}