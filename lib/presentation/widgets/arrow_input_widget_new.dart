import 'package:flutter/material.dart';
import 'archery_score_keypad.dart';

class ArrowInputWidget extends StatefulWidget {
  final Function(List<String>) onArrowsSubmitted;
  final int maxArrows;
  final bool isEnabled;

  const ArrowInputWidget({
    super.key,
    required this.onArrowsSubmitted,
    this.maxArrows = 3,
    this.isEnabled = true,
  });

  @override
  State<ArrowInputWidget> createState() => _ArrowInputWidgetState();
}

class _ArrowInputWidgetState extends State<ArrowInputWidget> {
  final List<String> _arrows = [];

  Color _getArrowColor(String arrow) {
    if (arrow.isEmpty) return Colors.grey[300]!;
    if (arrow.toUpperCase() == 'X') return const Color(0xFFFFD700); // Gold
    if (arrow.toUpperCase() == 'M') return const Color(0xFF808080); // Gray
    final score = int.tryParse(arrow);
    if (score != null) {
      if (score == 10) return const Color(0xFFFFA500); // Orange Gold
      if (score == 9) return const Color(0xFFDC143C); // Crimson Red
      if (score == 8) return const Color(0xFFB22222); // Fire Brick Red
      if (score == 7) return const Color(0xFF0066CC); // Royal Blue
      if (score == 6) return const Color(0xFF4169E1); // Royal Blue
      if (score == 5) return const Color(0xFF2C2C2C); // Dark Gray
      if (score == 4) return const Color(0xFF1C1C1C); // Darker Gray
      if (score == 3) return const Color(0xFFF5F5F5); // White Gray
      if (score == 2) return const Color(0xFFE8E8E8); // Light Gray
      if (score == 1) return const Color(0xFFD3D3D3); // Light Gray
    }
    return Colors.grey[300]!;
  }

  Color _getArrowTextColor(String arrow) {
    if (arrow.isEmpty) return Colors.black;
    if (arrow.toUpperCase() == 'X') return Colors.black;
    if (arrow.toUpperCase() == 'M') return Colors.white;
    final score = int.tryParse(arrow);
    if (score != null) {
      if (score >= 9) return Colors.black;  // Gold background
      if (score >= 7) return Colors.white;  // Red background
      if (score >= 5) return Colors.white;  // Blue background
      if (score >= 3) return Colors.black;  // White background
      return Colors.black;  // Light backgrounds
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Arrow Scores',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Current arrows display
            Row(
              children: List.generate(widget.maxArrows, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Text('Arrow ${index + 1}', 
                          style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(height: 4),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: _getArrowColor(index < _arrows.length ? _arrows[index] : ''),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: Text(
                              index < _arrows.length && _arrows[index].isNotEmpty 
                                  ? _arrows[index] 
                                  : '-',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _getArrowTextColor(index < _arrows.length ? _arrows[index] : ''),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 20),
            
            // Archery Score Keypad
            ArcheryScoreKeypad(
              isEnabled: widget.isEnabled && _arrows.length < widget.maxArrows,
              onScoreSelected: (score) {
                if (_arrows.length < widget.maxArrows) {
                  setState(() {
                    _arrows.add(score);
                  });
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.isEnabled && _arrows.isNotEmpty ? () {
                      setState(() {
                        if (_arrows.isNotEmpty) {
                          _arrows.removeLast();
                        }
                      });
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                    ),
                    child: const Text('Remove Last'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.isEnabled && _arrows.isNotEmpty ? () {
                      setState(() {
                        _arrows.clear();
                      });
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                    ),
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: widget.isEnabled && _arrows.isNotEmpty
                        ? () {
                            widget.onArrowsSubmitted(List.from(_arrows));
                            setState(() {
                              _arrows.clear();
                            });
                          }
                        : null,
                    child: Text('Submit End (${_arrows.length}/${widget.maxArrows})'),
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