import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/match.dart';
import '../../domain/entities/target_assignment.dart';
import '../providers/scoring_provider.dart';
import '../providers/registration_provider.dart';
import '../widgets/arrow_input_widget.dart';
import '../widgets/scorecard_widget.dart';
import '../../core/services/target_assignment_service.dart';

class MatchScoringPage extends StatefulWidget {
  final Match match;
  final String currentUserId;

  const MatchScoringPage({
    super.key,
    required this.match,
    required this.currentUserId,
  });

  @override
  State<MatchScoringPage> createState() => _MatchScoringPageState();
}

class _MatchScoringPageState extends State<MatchScoringPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<TargetAssignment> _targetAssignments = [];
  int? _selectedTargetNumber;
  String? _selectedArcherUserId; // For single-device mode

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTargetAssignments();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMatchData();
    });
  }

  void _loadMatchData() async {
    final provider = Provider.of<ScoringProvider>(context, listen: false);
    await provider.loadScores(widget.match.matchId);
  }

  void _loadTargetAssignments() async {
    final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
    final registrationsWithUsers = registrationProvider.getAcceptedRegistrations();
    
    final archers = registrationsWithUsers.map((regWithUser) => regWithUser.user).toList();
    
    final assignments = TargetAssignmentService.assignTargets(
      match: widget.match,
      archers: archers,
    );
    
    setState(() {
      _targetAssignments = assignments;
      // Set first target as default
      if (assignments.isNotEmpty) {
        _selectedTargetNumber = assignments.first.targetNumber;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.match.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Scoring', icon: Icon(Icons.my_location)),
            Tab(text: 'Leaderboard', icon: Icon(Icons.leaderboard)),
          ],
        ),
      ),
      body: Consumer<ScoringProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          if (!widget.match.isOngoing) {
            return _buildStartMatchPrompt(provider);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildScoringTab(context, provider),
              _buildLeaderboardTab(context, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStartMatchPrompt(ScoringProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.play_arrow, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Match Not Started',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('This match needs to be started before scoring can begin.'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showStartMatchDialog(),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Match'),
          ),
        ],
      ),
    );
  }

  Widget _buildScoringTab(BuildContext context, ScoringProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header for single-device mode
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.tablet_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Single Device Mode - Pass device between archers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Archer selection for scoring
          _buildArcherSelectionCard(provider),
          
          const SizedBox(height: 16),
          
          // Current archer scoring interface
          if (_selectedArcherUserId != null)
            _buildCurrentArcherScoring(provider),
        ],
      ),
    );
  }

  Widget _buildArcherSelectionCard(ScoringProvider provider) {
    final allScores = provider.scores;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Archer to Score',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // Grid of archer cards
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allScores.map((scoreWithUser) {
                final isSelected = _selectedArcherUserId == scoreWithUser.user.userId;
                final hasCurrentEnd = scoreWithUser.score.currentEnd <= widget.match.totalEnds;
                
                return GestureDetector(
                  onTap: hasCurrentEnd ? () {
                    setState(() {
                      _selectedArcherUserId = scoreWithUser.user.userId;
                    });
                  } : null,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary
                          : hasCurrentEnd
                              ? Theme.of(context).colorScheme.surface
                              : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected 
                            ? Theme.of(context).colorScheme.primary
                            : hasCurrentEnd
                                ? Theme.of(context).colorScheme.outline
                                : Colors.grey,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          scoreWithUser.user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected 
                                ? Theme.of(context).colorScheme.onPrimary
                                : hasCurrentEnd
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasCurrentEnd
                              ? 'R${scoreWithUser.score.currentRound} E${scoreWithUser.score.currentEnd}'
                              : 'Complete',
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected 
                                ? Theme.of(context).colorScheme.onPrimary
                                : hasCurrentEnd
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Score: ${scoreWithUser.score.totalScore}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected 
                                ? Theme.of(context).colorScheme.onPrimary
                                : hasCurrentEnd
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentArcherScoring(ScoringProvider provider) {
    final selectedScore = provider.getUserScore(_selectedArcherUserId!);
    
    if (selectedScore == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Archer not found'),
        ),
      );
    }

    return Column(
      children: [
        // Current archer's scorecard
        ScorecardWidget(
          scoreWithUser: selectedScore,
          match: widget.match,
          isCurrentUser: true,
        ),
        
        const SizedBox(height: 16),
        
        // Arrow input for current archer
        _buildIndividualArrowInput(provider, selectedScore),
        
        const SizedBox(height: 16),
        
        // Recent ends for current archer
        _buildRecentEnds(context, selectedScore),
      ],
    );
  }

  Widget _buildIndividualArrowInput(ScoringProvider provider, scoreWithUser) {
    final currentRound = scoreWithUser.score.currentRound;
    final currentEnd = scoreWithUser.score.currentEnd;
    
    return ArrowInputWidget(
      maxArrows: widget.match.arrowsPerEnd,
      isEnabled: true,
      onArrowsSubmitted: (arrows) async {
        await provider.recordEnd(
          matchId: widget.match.matchId,
          userId: scoreWithUser.user.userId, // Use selected archer's ID
          roundNumber: currentRound,
          endNumber: currentEnd,
          arrows: arrows,
        );
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('End recorded for ${scoreWithUser.user.name}'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Auto-clear selection to allow next archer
          setState(() {
            _selectedArcherUserId = null;
          });
        }
      },
    );
  }

  Widget _buildRecentEnds(BuildContext context, scoreWithUser) {
    final recentEnds = scoreWithUser.score.ends.take(3).toList();
    
    if (recentEnds.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No ends recorded yet'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Ends',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...recentEnds.map((end) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('R${end.roundNumber} E${end.endNumber}'),
                  Text(end.arrows.join(', ')),
                  Text('${end.endTotal}'),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardTab(BuildContext context, ScoringProvider provider) {
    final leaderboard = provider.getLeaderboard();
    
    if (leaderboard.isEmpty) {
      return const Center(
        child: Text('No scores available'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final scoreWithUser = leaderboard[index];
        return Card(
          child: ListTile(
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getPositionColor(index),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(scoreWithUser.user.name),
            subtitle: Text('R${scoreWithUser.score.currentRound} E${scoreWithUser.score.currentEnd}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${scoreWithUser.score.totalScore}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${scoreWithUser.score.totalXs} X\'s',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  void _showStartMatchDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start Match'),
          content: const Text(
            'This match hasn\'t started yet. Do you want to start it now? '
            'This will create scorecards for all accepted archers.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Also close scoring page
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider = Provider.of<ScoringProvider>(context, listen: false);
                await provider.startMatch(widget.match.matchId);
                
                if (provider.error == null) {
                  Navigator.of(context).pop();
                  provider.loadScores(widget.match.matchId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to start match: ${provider.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Start Match'),
            ),
          ],
        );
      },
    );
  }
}