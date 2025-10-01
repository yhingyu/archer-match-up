import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/match.dart';
import '../providers/registration_provider.dart';
import '../providers/scoring_provider.dart';
import '../widgets/registration_widget.dart';
import '../widgets/target_assignment_widget.dart';
import '../../core/services/target_assignment_service.dart';
import 'match_scoring_page.dart';

class MatchDetailPage extends StatefulWidget {
  final Match match;

  const MatchDetailPage({
    super.key,
    required this.match,
  });

  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Load registrations when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RegistrationProvider>(context, listen: false)
          .loadRegistrations(widget.match.matchId);
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Details'),
            Tab(icon: Icon(Icons.people), text: 'Registrations'),
            Tab(icon: Icon(Icons.gps_fixed), text: 'Targets'),
            Tab(icon: Icon(Icons.sports_score), text: 'Scoring'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDetailsTab(),
          _buildRegistrationsTab(),
          _buildTargetsTab(),
          _buildScoringTab(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMatchInfoCard(),
          const SizedBox(height: 16),
          _buildStatusCard(),
          const SizedBox(height: 16),
          _buildConfigurationCard(),
        ],
      ),
    );
  }

  Widget _buildRegistrationsTab() {
    return Consumer<RegistrationProvider>(builder: (context, provider, child) {
      return RegistrationWidget(
        matchId: widget.match.matchId,
        registrations: provider.registrations,
        isLoading: provider.isLoading,
        error: provider.error,
        onAccept: (registrationId) => provider.acceptRegistration(registrationId, widget.match.matchId),
        onReject: (registrationId) => provider.rejectRegistration(registrationId, widget.match.matchId),
      );
    });
  }

  Widget _buildTargetsTab() {
    return Consumer<RegistrationProvider>(builder: (context, provider, child) {
      final acceptedRegistrations = provider.getAcceptedRegistrations();
      final archers = acceptedRegistrations.map((reg) => reg.user).toList();
      
      final assignments = TargetAssignmentService.assignTargets(
        match: widget.match,
        archers: archers,
      );

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: TargetAssignmentWidget(
          assignments: assignments,
          onReassign: () {
            // Targets will be reassigned automatically when acceptedRegistrations change
            setState(() {});
          },
        ),
      );
    });
  }

  Widget _buildScoringTab() {
    return Consumer<ScoringProvider>(builder: (context, provider, child) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_score,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              widget.match.status == MatchStatus.pending
                  ? 'Match Ready for Scoring'
                  : widget.match.status == MatchStatus.ongoing
                      ? 'Match in Progress'
                      : 'Match Completed',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.match.status == MatchStatus.pending
                  ? 'Start the match to begin scoring'
                  : 'Open full scoring interface',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // For demo purposes, use a fixed user ID
                // In a real app, this would come from authentication
                final acceptedRegistrations = Provider.of<RegistrationProvider>(
                  context,
                  listen: false,
                ).getAcceptedRegistrations();
                
                if (acceptedRegistrations.isNotEmpty) {
                  final currentUserId = acceptedRegistrations.first.user.userId;
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchScoringPage(
                        match: widget.match,
                        currentUserId: currentUserId,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No accepted registrations found'),
                    ),
                  );
                }
              },
              icon: Icon(
                widget.match.status == MatchStatus.pending
                    ? Icons.play_arrow
                    : Icons.open_in_new,
              ),
              label: Text(
                widget.match.status == MatchStatus.pending
                    ? 'Start Scoring'
                    : 'Open Scoring',
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMatchInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sports_score,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Match Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Match Code', widget.match.matchCode),
            _buildInfoRow('Title', widget.match.title),
            _buildInfoRow('Description', widget.match.description ?? 'No description'),
            _buildInfoRow('Created', _formatDateTime(widget.match.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getStatusIcon(),
                  color: _getStatusColor(),
                ),
                const SizedBox(width: 8),
                Text(
                  'Match Status',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _getStatusColor()),
              ),
              child: Text(
                widget.match.status.name.toUpperCase(),
                style: TextStyle(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Configuration',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Rounds', widget.match.numberOfRounds.toString()),
            _buildInfoRow('Ends per Round', widget.match.totalEnds.toString()),
            _buildInfoRow('Arrows per End', widget.match.arrowsPerEnd.toString()),
            _buildInfoRow('Max Targets', widget.match.maxTargets.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        _showRegisterDialog();
      },
      child: const Icon(Icons.person_add),
    );
  }

  void _showRegisterDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Register for Match'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Archer Name *',
                    hintText: 'Enter archer name',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email (Optional)',
                    hintText: 'Enter email address',
                  ),
                  keyboardType: TextInputType.emailAddress,
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
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter archer name'),
                    ),
                  );
                  return;
                }

                final success = await Provider.of<RegistrationProvider>(
                  context,
                  listen: false,
                ).registerArcher(
                  matchId: widget.match.matchId,
                  userName: nameController.text.trim(),
                  email: emailController.text.trim().isEmpty
                      ? null
                      : emailController.text.trim(),
                );

                if (success) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${nameController.text.trim()} registered successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  final error = Provider.of<RegistrationProvider>(
                    context,
                    listen: false,
                  ).error;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Registration failed: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Register'),
            ),
          ],
        );
      },
    );
  }

  IconData _getStatusIcon() {
    switch (widget.match.status) {
      case MatchStatus.pending:
        return Icons.schedule;
      case MatchStatus.ongoing:
        return Icons.play_arrow;
      case MatchStatus.completed:
        return Icons.check_circle;
    }
  }

  Color _getStatusColor() {
    switch (widget.match.status) {
      case MatchStatus.pending:
        return Colors.orange;
      case MatchStatus.ongoing:
        return Colors.green;
      case MatchStatus.completed:
        return Colors.blue;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}