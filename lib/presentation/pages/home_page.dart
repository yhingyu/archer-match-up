import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/match_provider.dart';
import '../providers/scoring_provider.dart';
import 'target_assignment_demo_page.dart';
import 'match_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load matches when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MatchProvider>(context, listen: false).loadMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('Archer Match Up'),
            SizedBox(width: 8),
            Icon(
              Icons.offline_bolt,
              size: 20,
              color: Colors.orange,
            ),
            Text(
              ' (Offline)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Consumer<MatchProvider>(
        builder: (context, matchProvider, child) {
          if (matchProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (matchProvider.matches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.sports_score,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No matches yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your first match to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TargetAssignmentDemoPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.gps_fixed),
                    label: const Text('View Target Assignment Demo'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matchProvider.matches.length,
            itemBuilder: (context, index) {
              final match = matchProvider.matches[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      Icons.sports_score,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  title: Text(match.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(match.description ?? 'No description'),
                      Text('${match.numberOfRounds} round${match.numberOfRounds == 1 ? '' : 's'}: ${match.totalEnds} ends, ${match.arrowsPerEnd} arrows/end'),
                      Text('Status: ${match.status.name}'),
                      Text('Max targets: ${match.maxTargets}'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) => _handleMatchAction(context, match, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'open',
                        child: ListTile(
                          leading: Icon(Icons.open_in_new),
                          title: Text('Open Match'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit Match'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'reset',
                        child: ListTile(
                          leading: Icon(Icons.refresh),
                          title: Text('Reset Scores'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete Match', style: TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchDetailPage(match: match),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "target_demo",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TargetAssignmentDemoPage(),
                ),
              );
            },
            backgroundColor: Colors.orange,
            child: const Icon(Icons.gps_fixed),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "create_match",
            onPressed: () {
              _showCreateMatchDialog(context);
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _showCreateMatchDialog(BuildContext context) {
    final nameController = TextEditingController();
    final distanceController = TextEditingController(text: '18');
    final numEndsController = TextEditingController(text: '6');
    final arrowsPerEndController = TextEditingController(text: '3');
    final numberOfRoundsController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Text('Create New Match'),
              SizedBox(width: 8),
              Icon(
                Icons.offline_bolt,
                size: 16,
                color: Colors.orange,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Match Name',
                    hintText: 'Enter match name',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: distanceController,
                  decoration: const InputDecoration(
                    labelText: 'Distance (m)',
                    hintText: 'Enter distance in meters',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: numEndsController,
                  decoration: const InputDecoration(
                    labelText: 'Number of Ends',
                    hintText: 'Enter number of ends',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: arrowsPerEndController,
                  decoration: const InputDecoration(
                    labelText: 'Arrows per End',
                    hintText: 'Enter arrows per end',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: numberOfRoundsController,
                  decoration: const InputDecoration(
                    labelText: 'Number of Rounds',
                    hintText: 'Enter number of rounds',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a match name'),
                    ),
                  );
                  return;
                }

                final distance = int.tryParse(distanceController.text) ?? 18;
                final numEnds = int.tryParse(numEndsController.text) ?? 6;
                final arrowsPerEnd = int.tryParse(arrowsPerEndController.text) ?? 3;
                final numberOfRounds = int.tryParse(numberOfRoundsController.text) ?? 1;

                Provider.of<MatchProvider>(context, listen: false).createMatch(
                  name: nameController.text.trim(),
                  distance: distance,
                  numEnds: numEnds,
                  arrowsPerEnd: arrowsPerEnd,
                  numberOfRounds: numberOfRounds,
                );

                Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _handleMatchAction(BuildContext context, match, String action) {
    switch (action) {
      case 'open':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchDetailPage(match: match),
          ),
        );
        break;
      case 'edit':
        _showEditMatchDialog(context, match);
        break;
      case 'reset':
        _showResetScoresDialog(context, match);
        break;
      case 'delete':
        _showDeleteMatchDialog(context, match);
        break;
    }
  }

  void _showEditMatchDialog(BuildContext context, match) {
    final titleController = TextEditingController(text: match.title);
    final descriptionController = TextEditingController(text: match.description ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Match'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Match Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedMatch = match.copyWith(
                title: titleController.text.trim(),
                description: descriptionController.text.trim().isNotEmpty 
                    ? descriptionController.text.trim() 
                    : null,
              );
              
              final matchProvider = Provider.of<MatchProvider>(context, listen: false);
              await matchProvider.updateMatch(updatedMatch);
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Match updated successfully')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showResetScoresDialog(BuildContext context, match) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Scores'),
        content: Text(
          'Are you sure you want to reset all scores for "${match.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final scoringProvider = Provider.of<ScoringProvider>(context, listen: false);
              await scoringProvider.resetMatchScores(match.matchId);
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Match scores reset successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Reset Scores'),
          ),
        ],
      ),
    );
  }

  void _showDeleteMatchDialog(BuildContext context, match) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Match'),
        content: Text(
          'Are you sure you want to delete "${match.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final matchProvider = Provider.of<MatchProvider>(context, listen: false);
              await matchProvider.deleteMatch(match.matchId);
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Match deleted successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}