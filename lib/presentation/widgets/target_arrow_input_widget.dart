import 'package:flutter/material.dart';
import '../../domain/entities/target_assignment.dart';

class TargetArrowInputWidget extends StatefulWidget {
  final TargetAssignment targetAssignment;
  final Future<void> Function(int targetNumber, Map<String, List<String>>) onTargetEndSubmitted;
  final int maxArrows;
  final bool isEnabled;
  final String currentUserId;

  const TargetArrowInputWidget({
    super.key,
    required this.targetAssignment,
    required this.onTargetEndSubmitted,
    this.maxArrows = 3,
    this.isEnabled = true,
    required this.currentUserId,
  });

  @override
  State<TargetArrowInputWidget> createState() => _TargetArrowInputWidgetState();
}

class _TargetArrowInputWidgetState extends State<TargetArrowInputWidget> {
  // Map of userId -> arrow scores
  final Map<String, List<String>> _allArrows = {};
  final Map<String, List<TextEditingController>> _allControllers = {};
  final Map<String, List<FocusNode>> _allFocusNodes = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (final archer in widget.targetAssignment.archers) {
      final controllers = <TextEditingController>[];
      final focusNodes = <FocusNode>[];
      final arrows = <String>[];
      
      for (int i = 0; i < widget.maxArrows; i++) {
        controllers.add(TextEditingController());
        focusNodes.add(FocusNode());
        arrows.add('');
      }
      
      _allControllers[archer.userId] = controllers;
      _allFocusNodes[archer.userId] = focusNodes;
      _allArrows[archer.userId] = arrows;
    }
  }

  @override
  void dispose() {
    for (final controllers in _allControllers.values) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }
    for (final focusNodes in _allFocusNodes.values) {
      for (final focusNode in focusNodes) {
        focusNode.dispose();
      }
    }
    super.dispose();
  }

  void _onArrowChanged(String userId, int arrowIndex, String value) {
    setState(() {
      _allArrows[userId]![arrowIndex] = value.toUpperCase();
    });

    print('Arrow changed: User $userId, Arrow $arrowIndex, Value: $value');

    // Auto-focus next field
    if (value.isNotEmpty && arrowIndex < widget.maxArrows - 1) {
      _allFocusNodes[userId]![arrowIndex + 1].requestFocus();
    }
  }

  Future<void> _submitTargetEnd() async {
    if (_isSubmitting) return; // Prevent double submission
    
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      // Collect all valid arrows from all archers on this target
      final targetArrows = <String, List<String>>{};
      
      for (final archer in widget.targetAssignment.archers) {
        final arrows = _allArrows[archer.userId]!
            .where((arrow) => arrow.isNotEmpty)
            .toList();
        if (arrows.isNotEmpty) {
          targetArrows[archer.userId] = arrows;
        }
      }
      
      print('Submitting target end: Target ${widget.targetAssignment.targetNumber}');
      print('Arrows: $targetArrows');
      
      if (targetArrows.isNotEmpty) {
        await widget.onTargetEndSubmitted(widget.targetAssignment.targetNumber, targetArrows);
        _clearAllArrows();
        print('Target end submitted successfully');
      } else {
        print('No arrows to submit');
      }
    } catch (e) {
      // Error is handled by the parent widget
      print('Error submitting target end: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _clearAllArrows() {
    setState(() {
      for (final archer in widget.targetAssignment.archers) {
        final controllers = _allControllers[archer.userId]!;
        final arrows = _allArrows[archer.userId]!;
        
        for (int i = 0; i < controllers.length; i++) {
          controllers[i].clear();
          arrows[i] = '';
        }
      }
    });
  }

  bool _isValidArrow(String value) {
    if (value.isEmpty) return true;
    final upper = value.toUpperCase();
    if (upper == 'X' || upper == 'M') return true;
    final score = int.tryParse(value);
    return score != null && score >= 0 && score <= 10;
  }

  Color _getArrowColor(String arrow) {
    if (arrow.isEmpty) return Colors.grey;
    if (arrow.toUpperCase() == 'X') return Colors.yellow[700]!;
    if (arrow.toUpperCase() == 'M') return Colors.red;
    final score = int.tryParse(arrow);
    if (score != null) {
      if (score >= 9) return Colors.yellow[700]!;
      if (score >= 7) return Colors.red;
      if (score >= 5) return Colors.blue;
      return Colors.black;
    }
    return Colors.grey;
  }

  bool _canSubmitEnd() {
    // Check if all archers on this target have entered at least one arrow
    for (final archer in widget.targetAssignment.archers) {
      final arrows = _allArrows[archer.userId]!;
      if (!arrows.any((arrow) => arrow.isNotEmpty && _isValidArrow(arrow))) {
        return false;
      }
    }
    return true;
  }

  int _getArchersWithScores() {
    int count = 0;
    for (final archer in widget.targetAssignment.archers) {
      final arrows = _allArrows[archer.userId]!;
      if (arrows.any((arrow) => arrow.isNotEmpty)) {
        count++;
      }
    }
    return count;
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
                  '${_getArchersWithScores()}/${widget.targetAssignment.archers.length} archers',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Arrow input for each archer
            ...widget.targetAssignment.archers.map((archer) {
              final isCurrentUser = archer.userId == widget.currentUserId;
              final controllers = _allControllers[archer.userId]!;
              final focusNodes = _allFocusNodes[archer.userId]!;
              final arrows = _allArrows[archer.userId]!;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCurrentUser 
                      ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCurrentUser 
                        ? Theme.of(context).colorScheme.primary
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
                        if (isCurrentUser) ...[
                          const SizedBox(width: 8),
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
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(widget.maxArrows, (arrowIndex) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: arrowIndex < widget.maxArrows - 1 ? 8 : 0,
                            ),
                            child: TextField(
                              controller: controllers[arrowIndex],
                              focusNode: focusNodes[arrowIndex],
                              enabled: widget.isEnabled, // Allow all archers to input scores
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _getArrowColor(arrows[arrowIndex]),
                              ),
                              decoration: InputDecoration(
                                labelText: '${arrowIndex + 1}',
                                hintText: '0-10,X,M', // Show hint for all archers
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, 
                                  vertical: 8,
                                ),
                                errorText: !_isValidArrow(arrows[arrowIndex]) 
                                    ? 'Invalid' 
                                    : null,
                              ),
                              onChanged: (value) => _onArrowChanged(archer.userId, arrowIndex, value),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            // Scoring guide
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Target Scoring - All archers can input scores:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('• 0-10: Numeric score'),
                  const Text('• X: Inner 10 (worth 10 points)'),
                  const Text('• M: Miss (worth 0 points)'),
                  const Text('• All archers must enter scores before submitting'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.isEnabled ? _clearAllArrows : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                    ),
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: widget.isEnabled && _canSubmitEnd() && !_isSubmitting
                        ? _submitTargetEnd 
                        : null,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            _canSubmitEnd() 
                                ? 'Submit Target End'
                                : 'Waiting for all archers...',
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}