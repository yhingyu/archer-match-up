import 'package:flutter/material.dart';
import '../../domain/entities/match_score.dart';
import '../../domain/entities/match.dart';

class ScorecardWidget extends StatelessWidget {
  final MatchScoreWithUser scoreWithUser;
  final Match match;
  final bool isCurrentUser;

  const ScorecardWidget({
    super.key,
    required this.scoreWithUser,
    required this.match,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final score = scoreWithUser.score;
    final user = scoreWithUser.user;
    
    return Card(
      elevation: isCurrentUser ? 4 : 1,
      color: isCurrentUser ? Theme.of(context).colorScheme.primaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isCurrentUser 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  child: Text(
                    user.name[0].toUpperCase(),
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
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Round ${score.currentRound} • End ${score.currentEnd}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      score.totalScore.toString(),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCurrentUser 
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    if (score.totalXs > 0)
                      Text(
                        '${score.totalXs}X',
                        style: TextStyle(
                          color: Colors.yellow[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Progress indicator
            LinearProgressIndicator(
              value: score.ends.length / (match.totalEnds * match.numberOfRounds),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                isCurrentUser 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              '${score.ends.length} / ${match.totalEnds * match.numberOfRounds} ends completed',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            
            const SizedBox(height: 16),
            
            // Round scores
            _buildRoundScores(context, score, match),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundScores(BuildContext context, MatchScore score, Match match) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Round Scores',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: List.generate(match.numberOfRounds, (roundIndex) {
            final roundNumber = roundIndex + 1;
            final roundScore = score.getRoundScore(roundNumber);
            final roundEnds = score.getRoundEnds(roundNumber);
            final isCompleted = roundEnds.length >= match.totalEnds;
            
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isCompleted 
                    ? (isCurrentUser ? Theme.of(context).colorScheme.primary : Colors.grey)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'R$roundNumber: $roundScore',
                style: TextStyle(
                  color: isCompleted ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}