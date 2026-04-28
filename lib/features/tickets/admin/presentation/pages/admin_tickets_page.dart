import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/shared/widgets/common/animated_background_widget.dart';

import '../bloc/admin_tickets_bloc.dart';
import '../../../shared/presentation/models/ticket_ui_models.dart';
import '../../../shared/presentation/widgets/dialogs/create_ticket_dialog.dart';
import '../widgets/widgets.dart';

class AdminTicketsScreen extends StatefulWidget {
  const AdminTicketsScreen({super.key});

  @override
  State<AdminTicketsScreen> createState() => _AdminTicketsScreenState();
}

class _AdminTicketsScreenState extends State<AdminTicketsScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    );
    _backgroundController.repeat();

    _searchController = TextEditingController();

    context.read<AdminTicketsBloc>().add(const AdminTicketsLoadRequested());
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackgroundWidget(animation: _backgroundAnimation),
          SafeArea(
            child: BlocBuilder<AdminTicketsBloc, AdminTicketsState>(
              builder: (context, state) {
                if (state is AdminTicketsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AdminTicketsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        SizedBox(height: customSpacing.md),
                        Text(
                          'Error loading tickets',
                          style: theme.textTheme.headlineSmall,
                        ),
                        SizedBox(height: customSpacing.sm),
                        Text(
                          state.message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: customSpacing.lg),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AdminTicketsBloc>().add(
                              const AdminTicketsLoadRequested(),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is AdminTicketsSuccess) {
                  return _buildTicketsContent(
                    context,
                    state.data,
                    customSpacing,
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsContent(
    BuildContext context,
    AdminTicketsData data,
    CustomSpacing spacing,
  ) {
    final bloc = context.read<AdminTicketsBloc>();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AdminTicketsHeader(
            totalCount: data.totalCount,
            onCreateTicket: () {
              showDialog<void>(
                context: context,
                builder:
                    (dialogContext) => CreateTicketDialog(
                      onSubmit: (ticketData) {
                        bloc.add(AdminTicketsCreateRequested(ticketData));
                      },
                    ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: spacing.xl)),
        SliverToBoxAdapter(
          child: AdminTicketsFilters(
            searchController: _searchController,
            bloc: bloc,
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: spacing.lg)),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final ticket = data.filteredTickets[index];
              return AdminTicketCard(ticket: ticket, bloc: bloc);
            }, childCount: data.filteredTickets.length),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: spacing.xl)),
      ],
    );
  }
}
