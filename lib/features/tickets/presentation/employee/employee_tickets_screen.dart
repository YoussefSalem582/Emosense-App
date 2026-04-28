import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../presentation/widgets/dialogs/create_ticket_dialog.dart';
import '../bloc/tickets_bloc.dart';
import 'widgets/review_video_filter_chips_widget.dart';

class EmployeeTicketsScreen extends StatefulWidget {
  const EmployeeTicketsScreen({super.key});

  @override
  State<EmployeeTicketsScreen> createState() => _EmployeeTicketsScreenState();
}

class _EmployeeTicketsScreenState extends State<EmployeeTicketsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _backgroundController;

  int _selectedFilterIndex = 0;
  bool _showVideoDetailsDialog = false;
  String? _selectedVideoId;

  /// True after submitting [TicketsCreateRequested] until we handle result in [BlocConsumer].
  bool _expectingTicketCreate = false;

  @override
  void initState() {
    super.initState();
    context.read<TicketsBloc>().add(const TicketsLoadEmployeeRequested());
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _fadeController.forward();
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _openCreateTicketDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateTicketDialog(
        onSubmit: (data) {
          setState(() => _expectingTicketCreate = true);
          context.read<TicketsBloc>().add(TicketsCreateRequested(data));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customSpacing = Theme.of(context).extension<CustomSpacing>()!;

    return BlocConsumer<TicketsBloc, TicketsState>(
      listenWhen: (prev, curr) {
        if (!_expectingTicketCreate) return false;
        return (prev is TicketsLoading && curr is TicketsSuccess) ||
            (prev is TicketsLoading && curr is TicketsError);
      },
      listener: (context, state) {
        setState(() => _expectingTicketCreate = false);
        if (state is TicketsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ticket created successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is TicketsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final tickets =
            state is TicketsSuccess && state.employeeData != null
                ? state.employeeData!.assignedTickets
                : <Map<String, dynamic>>[];

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                      Color(0xFF06B6D4),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: _buildTicketsBody(state, customSpacing),
              ),
              if (_showVideoDetailsDialog && tickets.isNotEmpty)
                _buildTicketDetailsDialog(tickets),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTicketsBody(
    TicketsState state,
    CustomSpacing customSpacing,
  ) {
    if (state is TicketsLoading || state is TicketsInitial) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (state is TicketsError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              SizedBox(height: customSpacing.md),
              FilledButton(
                onPressed:
                    () => context.read<TicketsBloc>().add(
                          const TicketsLoadEmployeeRequested(),
                        ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (state is TicketsSuccess && state.employeeData != null) {
      final list = state.employeeData!.assignedTickets;
      return Column(
        children: [
          SizedBox(height: customSpacing.md),
          _buildSectionHeader(customSpacing, list.length),
          SizedBox(height: customSpacing.md),
          ReviewVideoFilterChipsWidget(
            spacing: customSpacing,
            selectedFilterIndex: _selectedFilterIndex,
            onFilterChanged:
                (index) => setState(() => _selectedFilterIndex = index),
            tickets: list,
          ),
          SizedBox(height: customSpacing.md),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: customSpacing.md),
              itemCount: _getFilteredTickets(list).length,
              itemBuilder: (context, index) {
                final ticket = _getFilteredTickets(list)[index];
                return _buildTicketCard(ticket, customSpacing);
              },
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSectionHeader(CustomSpacing spacing, int totalTickets) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacing.md),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Support Tickets',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                'Total Tickets: $totalTickets',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _openCreateTicketDialog,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('New Ticket'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket, CustomSpacing spacing) {
    final priorityColor = _getPriorityColor(ticket['priority']);
    final statusColor = _getStatusColor(ticket['status']);

    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Ticket ID
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ticket['id'],
                  style: const TextStyle(
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              // Priority Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ticket['priority'],
                  style: TextStyle(
                    color: priorityColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: spacing.md),

          // Title
          Text(
            ticket['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: spacing.sm),

          // Description
          Text(
            ticket['description'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),

          SizedBox(height: spacing.md),

          // Footer Row
          Row(
            children: [
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ticket['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              // Action Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedVideoId = ticket['id'];
                    _showVideoDetailsDialog = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.md,
                    vertical: spacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF6366F1)),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      color: Color(0xFF6366F1),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'critical':
        return Colors.purple;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.blue;
      case 'in progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getFilteredTickets(
    List<Map<String, dynamic>> all,
  ) {
    switch (_selectedFilterIndex) {
      case 1:
        return all.where((ticket) => ticket['status'] == 'Open').toList();
      case 2:
        return all
            .where((ticket) => ticket['status'] == 'In Progress')
            .toList();
      case 3:
        return all.where((ticket) => ticket['status'] == 'Resolved').toList();
      default:
        return all;
    }
  }

  String _assigneeLabel(Map<String, dynamic> ticket) {
    final v = ticket['assignedTo'] ?? ticket['assignee'];
    return v?.toString() ?? '';
  }

  Widget _buildTicketDetailsDialog(List<Map<String, dynamic>> tickets) {
    final ticket = tickets.firstWhere(
      (t) => t['id'] == _selectedVideoId,
      orElse: () => tickets.first,
    );

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Ticket Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap:
                        () => setState(() => _showVideoDetailsDialog = false),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow('Ticket ID:', ticket['id']),
              _buildDetailRow(
                'Customer:',
                '${ticket['customer'] ?? ticket['customerName'] ?? ''}',
              ),
              _buildDetailRow('Priority:', '${ticket['priority']}'),
              _buildDetailRow('Status:', '${ticket['status']}'),
              _buildDetailRow(
                'Created:',
                '${ticket['created'] ?? ticket['createdAt'] ?? ''}',
              ),
              _buildDetailRow('Assignee:', _assigneeLabel(ticket)),
              if (ticket['referenceUrl'] != null)
                _buildDetailRow('Reference URL:', ticket['referenceUrl']),
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ticket['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          () => setState(() => _showVideoDetailsDialog = false),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          () => setState(() => _showVideoDetailsDialog = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Update Status'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
