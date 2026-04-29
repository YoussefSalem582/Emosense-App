import 'package:flutter/material.dart';
import '../../../core/core.dart';

class TicketDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const TicketDetailsDialog({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: AppColors.textPrimary,
              displayColor: AppColors.textPrimary,
            ),
      ),
      child: AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Ticket Details',
          style: AppFonts.copyWith(
            AppFonts.bodyLarge(color: AppColors.textPrimary),
            fontWeight: AppFonts.bold,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(
                'Ticket ID',
                ticket['id']?.toString() ?? 'Unknown',
              ),
              _buildDetailRow(
                'Customer',
                ticket['customerName']?.toString() ??
                    ticket['customer']?.toString() ??
                    'Unknown',
              ),
              _buildDetailRow(
                'Priority',
                ticket['priority']?.toString() ?? 'Unknown',
              ),
              _buildDetailRow(
                'Status',
                ticket['status']?.toString() ?? 'Unknown',
              ),
              _buildDetailRow(
                'Created',
                ticket['createdAt']?.toString() ??
                    ticket['created']?.toString() ??
                    'Unknown',
              ),
              _buildDetailRow(
                'Assignee',
                ticket['assignedTo']?.toString() ??
                    ticket['assignee']?.toString() ??
                    'Unassigned',
              ),
              if (ticket['url'] != null)
                _buildDetailRowWithLink(
                  context,
                  'Reference URL',
                  ticket['url'].toString(),
                ),
              SizedBox(height: 16),
              Text(
                'Description:',
                style: AppFonts.copyWith(
                  AppFonts.bodySmall(color: AppColors.textPrimary),
                  fontWeight: AppFonts.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                ticket['description']?.toString() ?? 'No description available',
                style: AppFonts.bodyMedium(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppFonts.bodySmall(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => _updateTicketStatus(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            child: Text(
              'Update Status',
              style: AppFonts.button(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: AppFonts.copyWith(
                AppFonts.bodySmall(color: AppColors.textPrimary),
                fontWeight: AppFonts.medium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFonts.bodySmall(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithLink(
    BuildContext context,
    String label,
    String url,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: AppFonts.copyWith(
                AppFonts.bodySmall(color: AppColors.textPrimary),
                fontWeight: AppFonts.medium,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _handleUrlTap(context, url),
              child: Text(
                url,
                style: AppFonts.copyWith(
                  AppFonts.bodySmall(color: AppColors.primary),
                  fontWeight: AppFonts.medium,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.open_in_new, size: 16, color: AppColors.primary),
        ],
      ),
    );
  }

  void _handleUrlTap(BuildContext context, String url) async {
    // Show confirmation dialog before opening URL
    final shouldOpen = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Open Link',
            style: AppFonts.bodyLarge(color: AppColors.textPrimary),
          ),
          content: Text(
            'Do you want to open this link?\n\n$url',
            style: AppFonts.bodyMedium(color: AppColors.textPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: AppFonts.bodySmall(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: Text(
                'Open',
                style: AppFonts.button(color: AppColors.white),
              ),
            ),
          ],
        );
      },
    );

    if (shouldOpen == true) {
      // Here you would use url_launcher package: await launchUrl(Uri.parse(url));
      // For now, show a snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Opening: $url',
              style: AppFonts.bodySmall(color: AppColors.white),
            ),
            backgroundColor: AppColors.primary,
            action: SnackBarAction(
              label: 'Copy',
              textColor: AppColors.white,
              onPressed: () {
                // Here you would copy to clipboard
                // Clipboard.setData(ClipboardData(text: url));
              },
            ),
          ),
        );
      }
    }
  }

  void _updateTicketStatus(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Ticket updated!',
          style: AppFonts.bodySmall(color: AppColors.white),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
