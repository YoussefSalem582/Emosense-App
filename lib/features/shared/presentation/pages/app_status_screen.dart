import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/network/connection_bloc.dart';
import 'package:emosense_mobile/core/widgets/cards/connection_status_card.dart';

/// Diagnostics surface for backend connectivity (named route [AppRouter.appStatus]).
class AppStatusScreen extends StatelessWidget {
  const AppStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App status')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ConnectionStatusCard(),
          const SizedBox(height: 24),
          Text('Details', style: AppFonts.h6ForTheme(context)),
          const SizedBox(height: 8),
          BlocBuilder<ConnectionBloc, BackendConnectionState>(
            builder: (context, state) {
              if (state is ConnectionConnected) {
                final details = state.details;
                return _DetailCard(
                  children: [
                    _kv('Environment', state.config.name),
                    if (details != null && details.isNotEmpty)
                      ...details.entries.map((e) => _kv(e.key, '${e.value}')),
                  ],
                );
              }
              if (state is ConnectionConnecting) {
                return const Text('Connecting…');
              }
              if (state is ConnectionError) {
                return Text(
                  state.message,
                  style: AppFonts.bodyMedium(
                    color: Theme.of(context).colorScheme.error,
                  ),
                );
              }
              if (state is ConnectionDisconnected) {
                return const Text(
                  'Not connected to a backend. Use refresh on the card above to test.',
                );
              }
              return const Text('Connection not initialized yet.');
            },
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => AppRouter.toTestBackend(context),
            icon: const Icon(Icons.bug_report_outlined),
            label: const Text('API health checks (legacy tester)'),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              k,
              style: AppFonts.copyWith(
                AppFonts.labelLarge(color: AppColors.textPrimary),
                fontWeight: AppFonts.semiBold,
              ),
            ),
          ),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
