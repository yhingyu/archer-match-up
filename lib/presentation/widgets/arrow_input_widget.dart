import 'package:flutter/material.dart';

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
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (int i = 0; i < widget.maxArrows; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
      _arrows.add('');
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onArrowChanged(int index, String value) {
    setState(() {
      _arrows[index] = value.toUpperCase();
    });

    // Auto-focus next field
    if (value.isNotEmpty && index < widget.maxArrows - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _submitArrows() {
    final validArrows = _arrows.where((arrow) => arrow.isNotEmpty).toList();
    if (validArrows.isNotEmpty) {
      widget.onArrowsSubmitted(validArrows);
      _clearArrows();
    }
  }

  void _clearArrows() {
    setState(() {
      for (int i = 0; i < _controllers.length; i++) {
        _controllers[i].clear();
        _arrows[i] = '';
      }
    });
    _focusNodes[0].requestFocus();
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
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            // Arrow input fields
            Row(
              children: List.generate(widget.maxArrows, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < widget.maxArrows - 1 ? 8 : 0,
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      enabled: widget.isEnabled,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getArrowColor(_arrows[index]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Arrow ${index + 1}',
                        hintText: '0-10, X, M',
                        border: const OutlineInputBorder(),
                        errorText: !_isValidArrow(_arrows[index]) 
                            ? 'Invalid' 
                            : null,
                      ),
                      onChanged: (value) => _onArrowChanged(index, value),
                      onSubmitted: (_) {
                        if (index == widget.maxArrows - 1) {
                          _submitArrows();
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 16),
            
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
                    'Scoring Guide:',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  const Text('• 0-10: Numeric score'),
                  const Text('• X: Inner 10 (worth 10 points)'),
                  const Text('• M: Miss (worth 0 points)'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.isEnabled ? _clearArrows : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                    ),
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: widget.isEnabled && 
                        _arrows.any((arrow) => arrow.isNotEmpty) &&
                        _arrows.every((arrow) => _isValidArrow(arrow))
                        ? _submitArrows 
                        : null,
                    child: const Text('Submit End'),
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