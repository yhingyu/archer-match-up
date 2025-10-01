import 'package:flutter/material.dart';
import '../../domain/entities/target_assignment.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/match.dart';
import '../../core/services/target_assignment_service.dart';
import '../widgets/target_assignment_widget.dart';

class TargetAssignmentDemoPage extends StatefulWidget {
  const TargetAssignmentDemoPage({super.key});

  @override
  State<TargetAssignmentDemoPage> createState() => _TargetAssignmentDemoPageState();
}

class _TargetAssignmentDemoPageState extends State<TargetAssignmentDemoPage> {
  List<TargetAssignment> _assignments = [];
  final List<User> _sampleArchers = [
    User(
      userId: '1',
      name: 'Alice Johnson',
      email: 'alice@example.com',
      createdAt: DateTime.now(),
    ),
    User(
      userId: '2',
      name: 'Bob Smith',
      email: 'bob@example.com',
      createdAt: DateTime.now(),
    ),
    User(
      userId: '3',
      name: 'Charlie Brown',
      email: 'charlie@example.com',
      createdAt: DateTime.now(),
    ),
    User(
      userId: '4',
      name: 'Diana Wilson',
      email: 'diana@example.com',
      createdAt: DateTime.now(),
    ),
    User(
      userId: '5',
      name: 'Eve Davis',
      email: 'eve@example.com',
      createdAt: DateTime.now(),
    ),
    User(
      userId: '6',
      name: 'Frank Miller',
      email: 'frank@example.com',
      createdAt: DateTime.now(),
    ),
    User(
      userId: '7',
      name: 'Grace Taylor',
      email: 'grace@example.com',
      createdAt: DateTime.now(),
    ),
    User(
      userId: '8',
      name: 'Henry Anderson',
      email: 'henry@example.com',
      createdAt: DateTime.now(),
    ),
    User(
      userId: '9',
      name: 'Ivy Chen',
      email: 'ivy@example.com',
      createdAt: DateTime.now(),
    ),
    User(
      userId: '10',
      name: 'Jack Thompson',
      email: 'jack@example.com',
      createdAt: DateTime.now(),
    ),
  ];

  final Match _sampleMatch = Match(
    matchId: 'demo_match_123',
    creatorId: 'creator_1',
    title: 'Target Assignment Demo',
    maxTargets: 8,
    status: MatchStatus.pending,
    createdAt: DateTime.now(),
    arrowsPerEnd: 3,
    totalEnds: 6,
    numberOfRounds: 1,
    description: 'Demonstration of target assignment algorithm',
  );

  List<User> _selectedArchers = [];

  @override
  void initState() {
    super.initState();
    _selectedArchers = _sampleArchers.take(7).toList(); // Start with 7 archers
    _assignTargets();
  }

  void _assignTargets() {
    setState(() {
      _assignments = TargetAssignmentService.assignTargets(
        match: _sampleMatch,
        archers: _selectedArchers,
      );
    });
  }

  void _addArcher(User archer) {
    if (!_selectedArchers.contains(archer)) {
      setState(() {
        _selectedArchers.add(archer);
        _selectedArchers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      });
      _assignTargets();
    }
  }

  void _removeArcher(User archer) {
    setState(() {
      _selectedArchers.remove(archer);
    });
    _assignTargets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Assignment Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildArcherSelection(),
            const SizedBox(height: 24),
            TargetAssignmentWidget(
              assignments: _assignments,
              onReassign: _assignTargets,
            ),
            const SizedBox(height: 24),
            _buildAlgorithmInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildArcherSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Archer Selection',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected: ${_selectedArchers.length} archers',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sampleArchers.map((archer) {
                final isSelected = _selectedArchers.contains(archer);
                return FilterChip(
                  label: Text(archer.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      _addArcher(archer);
                    } else {
                      _removeArcher(archer);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlgorithmInfo() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.green.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  'Algorithm Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Target Assignment Process:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildAlgorithmStep('1', 'Sort archers alphabetically by name'),
            _buildAlgorithmStep('2', 'Calculate required targets (max 4 archers per target)'),
            _buildAlgorithmStep('3', 'Distribute archers using round-robin algorithm'),
            _buildAlgorithmStep('4', 'Assign shooting positions (A, B, C, D) and order'),
            const SizedBox(height: 12),
            if (_assignments.isNotEmpty) ...[
              const Text(
                'Current Assignment Stats:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              ..._buildAssignmentStats(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAlgorithmStep(String number, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAssignmentStats() {
    final stats = TargetAssignmentService.getAssignmentStats(_assignments);
    return [
      Text('• Total Archers: ${stats['totalArchers']}'),
      Text('• Targets Used: ${stats['totalTargets']}'),
      Text('• Full Targets: ${stats['fullTargets']}'),
      Text('• Average per Target: ${stats['averageArchersPerTarget'].toStringAsFixed(1)}'),
    ];
  }
}