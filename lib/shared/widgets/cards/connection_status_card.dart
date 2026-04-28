import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/network/connection_bloc.dart';

/// Shows backend connection status from [ConnectionBloc].
class ConnectionStatusCard extends StatelessWidget {
  const ConnectionStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionBloc, BackendConnectionState>(
      builder: (context, state) {
        final isConnected = state is ConnectionConnected;
        final isChecking = state is ConnectionConnecting;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient:
                isConnected
                    ? AppColors.successGradient
                    : AppColors.errorGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (isConnected ? AppColors.success : AppColors.error)
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                isConnected ? Icons.check_circle : Icons.error,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isConnected ? AppStrings.connected : AppStrings.disconnected,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed:
                    isChecking
                        ? null
                        : () => context.read<ConnectionBloc>().add(
                          const ConnectionTestRequested(),
                        ),
                icon:
                    isChecking
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 18,
                        ),
                label: Text(
                  AppStrings.refresh,
                  style: const TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
