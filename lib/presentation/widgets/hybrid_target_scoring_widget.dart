import 'package:flutter/material.dart';
import '../../domain/entities/target_assignment.dart';
import 'arrow_input_widget.dart';

class HybridTargetScoringWidget extends StatefulWidget {
  final TargetAssignment targetAssignment;
  final Future<void> Function(int targetNumber, Map<String, List<String>>) onTargetEndSubmitted;
  final int maxArrows;
  final bool isEnabled;
  final String currentUserId;

  const HybridTargetScoringWidget({
    super.key,
    required this.targetAssignment,
    required this.onTargetEndSubmitted,
    this.maxArrows = 3,
    this.isEnabled = true,
    required this.currentUserId,
  });

  @override
  State<HybridTargetScoringWidget> createState() => _HybridTargetScoringWidgetState();
}

class _HybridTargetScoringWidgetState extends State<HybridTargetScoringWidget> {
  // Track scores for each archer: userId -> arrows
  final Map<String, List<String>> _archerScores = {};
  // Track which archers have completed their scoring
  final Set<String> _completedArchers = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Initialize empty scores for all archers
    for (final archer in widget.targetAssignment.archers) {
      _archerScores[archer.userId] = [];
    }
  }

  void _onArcherScoreCompleted(String userId, List<String> arrows) {
    setState(() {
      _archerScores[userId] = List.from(arrows);
      if (arrows.isNotEmpty && arrows.length == widget.maxArrows) {
        _completedArchers.add(userId);
      } else {
        _completedArchers.remove(userId);
      }
    });
    
    print('Archer $userId completed scoring: $arrows');
    print('Completed archers: ${_completedArchers.length}/${widget.targetAssignment.archers.length}');
  }

  bool _canSubmitTargetEnd() {
    // All archers on the target must have completed their scoring
    return _completedArchers.length == widget.targetAssignment.archers.length;
  }

  Future<void> _submitTargetEnd() async {
    if (_isSubmitting || !_canSubmitTargetEnd()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Filter out any empty scores (should not happen if logic is correct)
      final validScores = <String, List<String>>{};
      for (final entry in _archerScores.entries) {
        if (entry.value.isNotEmpty) {
          validScores[entry.key] = entry.value;
        }
      }

      print('Submitting target end for Target ${widget.targetAssignment.targetNumber}');
      print('All scores: $validScores');

      await widget.onTargetEndSubmitted(widget.targetAssignment.targetNumber, validScores);
      
      // Clear all scores after successful submission
      _clearAllScores();
      
    } catch (e) {
      print('Error submitting target end: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _clearAllScores() {
    setState(() {
      _archerScores.clear();
      _completedArchers.clear();
      // Reinitialize
      for (final archer in widget.targetAssignment.archers) {
        _archerScores[archer.userId] = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Target ${widget.targetAssignment.targetNumber}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${_completedArchers.length}/${widget.targetAssignment.archers.length} ready',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _canSubmitTargetEnd() 
                        ? Colors.green[700] 
                        : Colors.orange[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Individual arrow input for each archer
            ...widget.targetAssignment.archers.map((archer) {
              final isCurrentUser = archer.userId == widget.currentUserId;
              final hasCompleted = _completedArchers.contains(archer.userId);
              
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCurrentUser 
                      ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                      : hasCompleted
                          ? Colors.green[50]
                          : Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCurrentUser 
                        ? Theme.of(context).colorScheme.primary
                        : hasCompleted
                            ? Colors.green
                            : Colors.grey[300]!,
                    width: isCurrentUser ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${archer.shootingPosition}. ${archer.name}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCurrentUser 
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isCurrentUser)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                        if (hasCompleted) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                        ],
                        const Spacer(),
                        if (hasCompleted)
                          Text(
                            'Total: ${_archerScores[archer.userId]?.map((arrow) {
                              if (arrow.toUpperCase() == 'X') return 10;
                              if (arrow.toUpperCase() == 'M') return 0;
                              return int.tryParse(arrow) ?? 0;
                            }).fold(0, (a, b) => a + b) ?? 0}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Only show arrow input for current user or show readonly scores for others
                    if (isCurrentUser && !hasCompleted)
                      ArrowInputWidget(
                        maxArrows: widget.maxArrows,
                        isEnabled: widget.isEnabled,
                        onArrowsSubmitted: (arrows) {
                          _onArcherScoreCompleted(archer.userId, arrows);
                        },
                      )
                    else if (hasCompleted)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Scores: ${_archerScores[archer.userId]?.join(", ") ?? ""}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            if (isCurrentUser) ...[
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _archerScores[archer.userId] = [];
                                    _completedArchers.remove(archer.userId);
                                  });
                                },
                                child: const Text('Edit'),
                              ),
                            ],
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Waiting for ${archer.name} to score...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
            
            const SizedBox(height: 16),
            
            // Submit button (only enabled when all archers are ready)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.isEnabled && _canSubmitTargetEnd() && !_isSubmitting
                    ? _submitTargetEnd
                    : null,
                icon: _isSubmitting
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(_canSubmitTargetEnd() 
                        ? Icons.check_circle 
                        : Icons.hourglass_empty),
                label: Text(
                  _isSubmitting
                      ? 'Submitting...'
                      : _canSubmitTargetEnd()
                          ? 'Submit End for All Archers'
                          : 'Waiting for ${widget.targetAssignment.archers.length - _completedArchers.length} archer(s)...',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canSubmitTargetEnd() 
                      ? Colors.green 
                      : null,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}