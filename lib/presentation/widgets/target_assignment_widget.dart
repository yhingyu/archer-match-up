import 'package:flutter/material.dart';
import '../../domain/entities/target_assignment.dart';

class TargetAssignmentWidget extends StatelessWidget {
  final List<TargetAssignment> assignments;
  final VoidCallback? onReassign;

  const TargetAssignmentWidget({
    super.key,
    required this.assignments,
    this.onReassign,
  });

  @override
  Widget build(BuildContext context) {
    if (assignments.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.gps_fixed,
                size: 48,
                color: Colors.grey,
              ),
              SizedBox(height: 8),
              Text(
                'No Target Assignments',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Assign archers to targets to begin',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Target Assignments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onReassign != null)
              IconButton(
                onPressed: onReassign,
                icon: const Icon(Icons.refresh),
                tooltip: 'Reassign Targets',
              ),
          ],
        ),
        const SizedBox(height: 8),
        _buildAssignmentSummary(),
        const SizedBox(height: 16),
        ...assignments.map((assignment) => _buildTargetCard(assignment)),
      ],
    );
  }

  Widget _buildAssignmentSummary() {
    final totalArchers = assignments.fold<int>(0, (sum, assignment) => sum + assignment.archers.length);
    final totalTargets = assignments.length;
    final fullTargets = assignments.where((assignment) => assignment.isFull).length;

    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryStat('Archers', totalArchers.toString(), Icons.person),
            _buildSummaryStat('Targets', totalTargets.toString(), Icons.gps_fixed),
            _buildSummaryStat('Full', fullTargets.toString(), Icons.check_circle),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTargetCard(TargetAssignment assignment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: assignment.isFull ? Colors.green : Colors.orange,
                  child: Text(
                    assignment.targetNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target ${assignment.targetNumber}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${assignment.archers.length}/4 positions filled',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (assignment.isFull)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
              ],
            ),
            if (assignment.archers.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Shooting Order:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ...assignment.archers.map((archer) => _buildArcherRow(archer)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildArcherRow(AssignedArcher archer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade300),
            ),
            child: Center(
              child: Text(
                archer.shootingPosition,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              archer.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Order ${archer.shootingOrder}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}