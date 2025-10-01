import 'package:flutter/material.dart';

class ArcheryScoreKeypad extends StatelessWidget {
  final Function(String) onScoreSelected;
  final bool isEnabled;

  const ArcheryScoreKeypad({
    super.key,
    required this.onScoreSelected,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Arrow Score',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildScoreGrid(context),
        ],
      ),
    );
  }

  Widget _buildScoreGrid(BuildContext context) {
    return Column(
      children: [
        // X and M scores (Top row)
        Row(
          children: [
            Expanded(
              child: _buildScoreTile(
                context,
                score: 'X',
                color: const Color(0xFFFFD700), // Bright Yellow
                textColor: Colors.black,
                description: 'X-Ring (10)',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildScoreTile(
                context,
                score: 'M',
                color: const Color(0xFF808080), // Gray
                textColor: Colors.white,
                description: 'Miss (0)',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // 9 and 10 scores
        Row(
          children: [
            Expanded(
              child: _buildScoreTile(
                context,
                score: '9',
                color: const Color(0xFFFFD700), // Bright Yellow
                textColor: Colors.black,
                description: '9 Ring',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildScoreTile(
                context,
                score: '10',
                color: const Color(0xFFFFFACD), // Light Yellow
                textColor: Colors.black,
                description: '10 Ring',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // 7 and 8 scores (Red shades)
        Row(
          children: [
            Expanded(
              child: _buildScoreTile(
                context,
                score: '7',
                color: const Color(0xFFDC143C), // Crimson Red
                textColor: Colors.white,
                description: '7 Ring',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildScoreTile(
                context,
                score: '8',
                color: const Color(0xFFB22222), // Fire Brick Red
                textColor: Colors.white,
                description: '8 Ring',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // 5 and 6 scores (Blue shades)
        Row(
          children: [
            Expanded(
              child: _buildScoreTile(
                context,
                score: '5',
                color: const Color(0xFF0066CC), // Royal Blue
                textColor: Colors.white,
                description: '5 Ring',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildScoreTile(
                context,
                score: '6',
                color: const Color(0xFF4169E1), // Light Blue
                textColor: Colors.white,
                description: '6 Ring',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // 3 and 4 scores (Black shades)
        Row(
          children: [
            Expanded(
              child: _buildScoreTile(
                context,
                score: '3',
                color: const Color(0xFF2C2C2C), // Dark Black
                textColor: Colors.white,
                description: '3 Ring',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildScoreTile(
                context,
                score: '4',
                color: const Color(0xFF1C1C1C), // Black
                textColor: Colors.white,
                description: '4 Ring',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // 1 and 2 scores (White shades)
        Row(
          children: [
            Expanded(
              child: _buildScoreTile(
                context,
                score: '1',
                color: const Color(0xFFF5F5F5), // White
                textColor: Colors.black,
                description: '1 Ring',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildScoreTile(
                context,
                score: '2',
                color: const Color(0xFFFFFFFF), // Pure White
                textColor: Colors.black,
                description: '2 Ring',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreTile(
    BuildContext context, {
    required String score,
    required Color color,
    required Color textColor,
    required String description,
  }) {
    return Material(
      elevation: isEnabled ? 2 : 0,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: isEnabled ? () => onScoreSelected(score) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isEnabled ? color : color.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                score,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isEnabled ? textColor : textColor.withOpacity(0.5),
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 10,
                  color: isEnabled ? textColor.withOpacity(0.8) : textColor.withOpacity(0.3),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}