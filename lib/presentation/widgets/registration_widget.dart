import 'package:flutter/material.dart';
import '../../domain/entities/match_registration.dart';

class RegistrationWidget extends StatelessWidget {
  final String matchId;
  final List<RegistrationWithUser> registrations;
  final bool isLoading;
  final String? error;
  final Function(String) onAccept;
  final Function(String) onReject;

  const RegistrationWidget({
    super.key,
    required this.matchId,
    required this.registrations,
    required this.isLoading,
    this.error,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading registrations',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[600]),
            ),
          ],
        ),
      );
    }

    if (registrations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Registrations Yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Use the + button to register archers for this match',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final pendingRegistrations = registrations
        .where((reg) => reg.registration.isPending)
        .toList();
    final acceptedRegistrations = registrations
        .where((reg) => reg.registration.isAccepted)
        .toList();
    final rejectedRegistrations = registrations
        .where((reg) => reg.registration.isRejected)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Pending',
                  pendingRegistrations.length,
                  Colors.orange,
                  Icons.schedule,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Accepted',
                  acceptedRegistrations.length,
                  Colors.green,
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Rejected',
                  rejectedRegistrations.length,
                  Colors.red,
                  Icons.cancel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Pending Registrations
          if (pendingRegistrations.isNotEmpty) ...[
            _buildSectionHeader(context, 'Pending Approval', Icons.schedule, Colors.orange),
            const SizedBox(height: 12),
            ...pendingRegistrations.map((reg) => _buildRegistrationCard(
                  context,
                  reg,
                  showActions: true,
                )),
            const SizedBox(height: 24),
          ],

          // Accepted Registrations
          if (acceptedRegistrations.isNotEmpty) ...[
            _buildSectionHeader(context, 'Accepted Archers', Icons.check_circle, Colors.green),
            const SizedBox(height: 12),
            ...acceptedRegistrations.map((reg) => _buildRegistrationCard(
                  context,
                  reg,
                  showActions: false,
                )),
            const SizedBox(height: 24),
          ],

          // Rejected Registrations
          if (rejectedRegistrations.isNotEmpty) ...[
            _buildSectionHeader(context, 'Rejected', Icons.cancel, Colors.red),
            const SizedBox(height: 12),
            ...rejectedRegistrations.map((reg) => _buildRegistrationCard(
                  context,
                  reg,
                  showActions: false,
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    int count,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildRegistrationCard(
    BuildContext context,
    RegistrationWithUser reg,
    {
    required bool showActions,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reg.user.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (reg.user.email != null && reg.user.email!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      reg.user.email!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    'Registered: ${_formatDateTime(reg.registration.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(reg.registration).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getStatusColor(reg.registration),
                  width: 1,
                ),
              ),
              child: Text(
                _getStatusText(reg.registration),
                style: TextStyle(
                  color: _getStatusColor(reg.registration),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Action Buttons
            if (showActions) ...[
              const SizedBox(width: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => onAccept(reg.registration.registrationId),
                    icon: const Icon(Icons.check),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      foregroundColor: Colors.green,
                    ),
                    tooltip: 'Accept',
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => onReject(reg.registration.registrationId),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.1),
                      foregroundColor: Colors.red,
                    ),
                    tooltip: 'Reject',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(MatchRegistration registration) {
    if (registration.isPending) return Colors.orange;
    if (registration.isAccepted) return Colors.green;
    return Colors.red;
  }

  String _getStatusText(MatchRegistration registration) {
    if (registration.isPending) return 'PENDING';
    if (registration.isAccepted) return 'ACCEPTED';
    return 'REJECTED';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}