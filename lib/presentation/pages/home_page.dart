import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/match_provider.dart';
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
                  trailing: const Icon(Icons.arrow_forward_ios),
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
}