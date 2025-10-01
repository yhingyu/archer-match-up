import 'package:flutter/material.dart';
import '../../domain/entities/target_assignment.dart';

class TargetSelectionWidget extends StatelessWidget {
  final List<TargetAssignment> targetAssignments;
  final int? selectedTargetNumber;
  final Function(int targetNumber) onTargetSelected;
  final String currentUserId;

  const TargetSelectionWidget({
    super.key,
    required this.targetAssignments,
    required this.selectedTargetNumber,
    required this.onTargetSelected,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    // Find which target the current user is assigned to
    int? userTargetNumber;
    for (final assignment in targetAssignments) {
      if (assignment.archers.any((archer) => archer.userId == currentUserId)) {
        userTargetNumber = assignment.targetNumber;
        break;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Target to Score',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            
            if (userTargetNumber != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'You are assigned to Target $userTargetNumber',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            if (userTargetNumber != null) const SizedBox(height: 12),
            
            // Target selection buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: targetAssignments.map((assignment) {
                final isSelected = selectedTargetNumber == assignment.targetNumber;
                final isUserTarget = userTargetNumber == assignment.targetNumber;
                
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Target ${assignment.targetNumber}'),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${assignment.archers.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isUserTarget) const SizedBox(width: 4),
                      if (isUserTarget)
                        Icon(
                          Icons.person,
                          size: 16,
                          color: isSelected 
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.primary,
                        ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => onTargetSelected(assignment.targetNumber),
                  selectedColor: isUserTarget 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  backgroundColor: isUserTarget 
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                );
              }).toList(),
            ),
            
            if (selectedTargetNumber != null) const SizedBox(height: 12),
            if (selectedTargetNumber != null) const Divider(),
            if (selectedTargetNumber != null) const SizedBox(height: 8),
            
            if (selectedTargetNumber != null)
              // Show archers on selected target
              Text(
                'Archers on Target $selectedTargetNumber:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            if (selectedTargetNumber != null) const SizedBox(height: 8),
            
            if (selectedTargetNumber != null)
              ...targetAssignments
                  .where((assignment) => assignment.targetNumber == selectedTargetNumber)
                  .expand((assignment) => assignment.archers)
                  .map((archer) {
                final isCurrentUser = archer.userId == currentUserId;
                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCurrentUser 
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(
                        archer.shootingPosition,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          archer.name,
                          style: TextStyle(
                            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                            color: isCurrentUser 
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                        ),
                      ),
                      if (isCurrentUser)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'YOU',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}