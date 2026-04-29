import 'package:flutter/material.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/widgets/common/surface_section_card.dart';
import 'package:emosense_mobile/core/widgets/dialogs/ticket_details_dialog.dart';

import '../../../shared/domain/entities/ticket.dart';
import '../bloc/admin_tickets_bloc.dart';

class AdminTicketCard extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final AdminTicketsBloc bloc;

  const AdminTicketCard({super.key, required this.ticket, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final customSpacing = Theme.of(context).extension<CustomSpacing>()!;

    return SurfaceSectionCard(
      margin: EdgeInsets.only(bottom: customSpacing.md),
      padding: EdgeInsets.zero,
      color: Colors.white.withValues(alpha: 0.95),
      elevation: SurfaceElevation.settings,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => TicketDetailsDialog(ticket: ticket),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(customSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderRow(customSpacing),
                SizedBox(height: customSpacing.sm),
                _buildTitle(),
                SizedBox(height: customSpacing.sm),
                _buildDescription(),
                SizedBox(height: customSpacing.md),
                _buildStatusAndPriorityRow(customSpacing),
                SizedBox(height: customSpacing.md),
                _buildFooterRow(customSpacing),
                if (ticket['source']?.toString() == 'Employee Ticket') ...[
                  SizedBox(height: customSpacing.sm),
                  _buildEmployeeTicketInfo(customSpacing),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(CustomSpacing spacing) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: spacing.xs,
          ),
          decoration: BoxDecoration(
            color:
                ticket['source'] == 'Employee Ticket'
                    ? AppColors.info.withValues(alpha: 0.1)
                    : AppColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  ticket['source'] == 'Employee Ticket'
                      ? AppColors.info.withValues(alpha: 0.3)
                      : AppColors.accent.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            ticket['source'] ?? 'Admin Ticket',
            style: AppFonts.copyWith(
              AppFonts.labelSmall(
                color:
                    ticket['source'] == 'Employee Ticket'
                        ? AppColors.info
                        : AppColors.accentDark,
              ),
              fontWeight: AppFonts.semiBold,
            ),
          ),
        ),
        const Spacer(),
        Text(
          ticket['id']?.toString() ?? 'NO-ID',
          style: AppFonts.copyWith(
            AppFonts.caption(color: AppColors.textSecondary),
            fontWeight: AppFonts.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      ticket['title']?.toString() ?? 'No Title',
      style: AppFonts.copyWith(
        AppFonts.bodyLarge(color: AppColors.textPrimary),
        fontWeight: AppFonts.bold,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      ticket['description']?.toString() ?? 'No Description',
      style: AppFonts.bodyMedium(color: AppColors.textSecondary),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatusAndPriorityRow(CustomSpacing spacing) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: spacing.xs,
          ),
          decoration: BoxDecoration(
            color: _getStatusColor(
              ticket['status']?.toString(),
            ).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getStatusColor(
                ticket['status']?.toString(),
              ).withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            ticket['status']?.toString() ?? 'Unknown',
            style: AppFonts.copyWith(
              AppFonts.caption(
                color: _getStatusColor(ticket['status']?.toString()),
              ),
              fontWeight: AppFonts.semiBold,
            ),
          ),
        ),
        SizedBox(width: spacing.sm),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: spacing.xs,
          ),
          decoration: BoxDecoration(
            color: _getPriorityColor(
              ticket['priority']?.toString(),
            ).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getPriorityColor(
                ticket['priority']?.toString(),
              ).withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            ticket['priority']?.toString() ?? 'Unknown',
            style: AppFonts.copyWith(
              AppFonts.caption(
                color: _getPriorityColor(ticket['priority']?.toString()),
              ),
              fontWeight: AppFonts.semiBold,
            ),
          ),
        ),
        const Spacer(),
        _buildActionMenu(),
      ],
    );
  }

  Widget _buildActionMenu() {
    return Builder(
      builder:
          (context) => PopupMenuButton<String>(
            onSelected: (value) {
              final ticketId = ticket['id']?.toString();
              if (ticketId == null) return;

              switch (value) {
                case 'assign':
                  _showAssignDialog(context, ticket, bloc);
                  break;
                case 'status':
                  _showStatusDialog(context, ticket, bloc);
                  break;
                case 'priority':
                  _showPriorityDialog(context, ticket, bloc);
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'assign',
                    child: Row(
                      children: [
                        Icon(Icons.person_add, size: 16),
                        SizedBox(width: 8),
                        Text('Assign'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'status',
                    child: Row(
                      children: [
                        Icon(Icons.update, size: 16),
                        SizedBox(width: 8),
                        Text('Change Status'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'priority',
                    child: Row(
                      children: [
                        Icon(Icons.flag, size: 16),
                        SizedBox(width: 8),
                        Text('Change Priority'),
                      ],
                    ),
                  ),
                ],
            child: Icon(Icons.more_vert, color: AppColors.textSecondary),
          ),
    );
  }

  Widget _buildFooterRow(CustomSpacing spacing) {
    return Row(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: ticket['assignedToColor'] ?? AppColors.textTertiary,
              child: Text(
                ticket['assignedToAvatar'] ?? '?',
                style: AppFonts.copyWith(
                  AppFonts.caption(color: AppColors.white),
                  fontWeight: AppFonts.bold,
                ),
              ),
            ),
            SizedBox(width: spacing.xs),
            Text(
              ticket['assignedTo'] ?? 'Unassigned',
              style: AppFonts.copyWith(
                AppFonts.caption(color: AppColors.textPrimary),
                fontWeight: AppFonts.medium,
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          ticket['createdAt'] ?? '',
          style: AppFonts.caption(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildEmployeeTicketInfo(CustomSpacing spacing) {
    return Row(
      children: [
        Icon(Icons.person, size: 16, color: AppColors.textSecondary),
        SizedBox(width: spacing.xs),
        Text(
          'Customer: ${ticket['customerName']?.toString() ?? 'Unknown'}',
          style: AppFonts.caption(color: AppColors.textSecondary).copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
        const Spacer(),
        Text(
          'by ${ticket['employeeName']?.toString() ?? 'Unknown'}',
          style: AppFonts.copyWith(
            AppFonts.caption(color: AppColors.info),
            fontWeight: AppFonts.medium,
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(String? priority) {
    if (priority == null) return AppColors.textTertiary;
    switch (priority.toLowerCase()) {
      case 'critical':
        return AppColors.error;
      case 'high':
        return AppColors.warning;
      case 'medium':
        return AppColors.info;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.textTertiary;
    }
  }

  Color _getStatusColor(String? status) {
    if (status == null) return AppColors.textTertiary;
    switch (status.toLowerCase()) {
      case 'open':
        return AppColors.warning;
      case 'in progress':
        return AppColors.info;
      case 'resolved':
        return AppColors.success;
      default:
        return AppColors.textTertiary;
    }
  }
}

// Dialog helper functions (moved from main screen)
void _showAssignDialog(
  BuildContext context,
  Map<String, dynamic> ticket,
  AdminTicketsBloc bloc,
) {
  final ticketId = ticket['id']?.toString();
  if (ticketId == null) return;

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Assign Ticket'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('John Smith'),
                subtitle: const Text('Senior Support'),
                onTap: () {
                  bloc.add(AdminTicketsAssignRequested(ticketId, 'John Smith'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Sarah Johnson'),
                subtitle: const Text('Technical Lead'),
                onTap: () {
                  bloc.add(
                    AdminTicketsAssignRequested(ticketId, 'Sarah Johnson'),
                  );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Lisa Wong'),
                subtitle: const Text('Customer Success'),
                onTap: () {
                  bloc.add(AdminTicketsAssignRequested(ticketId, 'Lisa Wong'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
  );
}

void _showStatusDialog(
  BuildContext context,
  Map<String, dynamic> ticket,
  AdminTicketsBloc bloc,
) {
  final ticketId = ticket['id']?.toString();
  if (ticketId == null) return;

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Open'),
                onTap: () {
                  bloc.add(
                    AdminTicketsStatusUpdateRequested(
                      ticketId,
                      TicketStatus.open,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('In Progress'),
                onTap: () {
                  bloc.add(
                    AdminTicketsStatusUpdateRequested(
                      ticketId,
                      TicketStatus.inProgress,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Resolved'),
                onTap: () {
                  bloc.add(
                    AdminTicketsStatusUpdateRequested(
                      ticketId,
                      TicketStatus.resolved,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
  );
}

void _showPriorityDialog(
  BuildContext context,
  Map<String, dynamic> ticket,
  AdminTicketsBloc bloc,
) {
  final ticketId = ticket['id']?.toString();
  if (ticketId == null) return;

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Change Priority'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Low'),
                onTap: () {
                  bloc.add(
                    AdminTicketsPriorityUpdateRequested(
                      ticketId,
                      TicketPriority.low,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Medium'),
                onTap: () {
                  bloc.add(
                    AdminTicketsPriorityUpdateRequested(
                      ticketId,
                      TicketPriority.medium,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('High'),
                onTap: () {
                  bloc.add(
                    AdminTicketsPriorityUpdateRequested(
                      ticketId,
                      TicketPriority.high,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Critical'),
                onTap: () {
                  bloc.add(
                    AdminTicketsPriorityUpdateRequested(
                      ticketId,
                      TicketPriority.critical,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
  );
}
