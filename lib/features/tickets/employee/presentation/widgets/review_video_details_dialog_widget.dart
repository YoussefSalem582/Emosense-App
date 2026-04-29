import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:emosense_mobile/core/core.dart';

class ReviewVideoDetailsDialogWidget extends StatelessWidget {
  final Map<String, dynamic> video;
  final VoidCallback onClose;

  const ReviewVideoDetailsDialogWidget({
    super.key,
    required this.video,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Review ${video['id']}',
                    style: AppFonts.copyWith(
                      AppFonts.h6(color: AppColors.textPrimary),
                      fontWeight: AppFonts.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Video details
              Text(
                video['title'],
                style: AppFonts.copyWith(
                  AppFonts.bodyLarge(color: AppColors.textPrimary),
                  fontWeight: AppFonts.semiBold,
                ),
              ),

              const SizedBox(height: 8),

              // Channel info
              Row(
                children: [
                  Icon(Icons.youtube_searched_for, color: AppColors.error, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    video['channel'],
                    style: AppFonts.copyWith(
                      AppFonts.bodySmall(color: AppColors.textTertiary),
                      fontWeight: AppFonts.medium,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                video['description'],
                style: AppFonts.copyWith(
                  AppFonts.bodySmall(color: AppColors.textTertiary),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Customer and status info
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reviewer',
                        style: AppFonts.copyWith(
                          AppFonts.caption(color: AppColors.textSecondary),
                          fontWeight: AppFonts.semiBold,
                        ),
                      ),
                      Text(
                        video['reviewer'],
                        style: AppFonts.copyWith(
                          AppFonts.bodySmall(color: AppColors.textPrimary),
                          fontWeight: AppFonts.medium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: AppFonts.copyWith(
                          AppFonts.caption(color: AppColors.textSecondary),
                          fontWeight: AppFonts.semiBold,
                        ),
                      ),
                      Text(
                        video['status'],
                        style: AppFonts.bodySmall(
                          color: _getStatusColor(video['status']),
                        ).copyWith(fontWeight: AppFonts.medium),
                      ),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Views',
                        style: AppFonts.copyWith(
                          AppFonts.caption(color: AppColors.textSecondary),
                          fontWeight: AppFonts.semiBold,
                        ),
                      ),
                      Text(
                        video['views'],
                        style: AppFonts.copyWith(
                          AppFonts.bodySmall(color: AppColors.textPrimary),
                          fontWeight: AppFonts.medium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          () => _openReviewVideoUrl(
                            context,
                            video['videoUrl']?.toString(),
                          ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Watch Video'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onClose,
                      icon: const Icon(Icons.analytics),
                      label: const Text('Analyze Review'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.white,
                      ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return AppColors.info;
      case 'under review':
        return AppColors.warning;
      case 'completed':
        return AppColors.success;
      case 'archived':
        return AppColors.textTertiary;
      default:
        return AppColors.textTertiary;
    }
  }
}

Future<void> _openReviewVideoUrl(BuildContext context, String? rawUrl) async {
  final url = rawUrl?.trim();
  if (url == null || url.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No video URL')));
    }
    return;
  }
  final uri = Uri.tryParse(url);
  if (uri == null ||
      !(uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'))) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid video URL')));
    }
    return;
  }
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Could not open link')));
  }
}
