import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';

class CreateTicketDialog extends StatefulWidget {
  /// When set, receives validated ticket fields (bloc / parent handles persistence).
  final void Function(Map<String, dynamic> ticketData)? onSubmit;

  /// Legacy: called when [onSubmit] is null and the form is submitted.
  final VoidCallback? onTicketCreated;

  const CreateTicketDialog({super.key, this.onSubmit, this.onTicketCreated});

  @override
  State<CreateTicketDialog> createState() => _CreateTicketDialogState();
}

class _CreateTicketDialogState extends State<CreateTicketDialog> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _issueTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  String? _selectedPriority;

  @override
  void dispose() {
    _customerNameController.dispose();
    _issueTitleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

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
        title: Row(
          children: [
            Icon(Icons.add_circle, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'New Support Ticket',
              style: AppFonts.h6(color: AppColors.textPrimary),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _customerNameController,
                  style: AppFonts.bodyMedium(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    labelStyle: AppFonts.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _issueTitleController,
                  style: AppFonts.bodyMedium(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Issue Title',
                    labelStyle: AppFonts.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter issue title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  style: AppFonts.bodyMedium(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: AppFonts.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _urlController,
                  style: AppFonts.bodyMedium(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Reference URL (Optional)',
                    labelStyle: AppFonts.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                    hintText: 'https://example.com',
                    hintStyle: AppFonts.bodySmall(color: AppColors.textLight),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    prefixIcon: Icon(Icons.link, color: AppColors.primary),
                  ),
                  keyboardType: TextInputType.url,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  key: ValueKey(_selectedPriority),
                  initialValue: _selectedPriority,
                  style: AppFonts.bodyMedium(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    labelStyle: AppFonts.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  items:
                      ['Low', 'Medium', 'High'].map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(
                            priority,
                            style: AppFonts.bodyMedium(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select priority';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppFonts.bodySmall(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: _createTicket,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            child: Text(
              'Create Ticket',
              style: AppFonts.button(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _createTicket() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final data = <String, dynamic>{
      'title': _issueTitleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'customer': _customerNameController.text.trim(),
      'customerName': _customerNameController.text.trim(),
      'priority': _selectedPriority,
    };
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      data['referenceUrl'] = url;
    }

    final submit = widget.onSubmit;
    if (submit != null) {
      submit(data);
    } else {
      widget.onTicketCreated?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket created successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }

    Navigator.pop(context);
  }
}
