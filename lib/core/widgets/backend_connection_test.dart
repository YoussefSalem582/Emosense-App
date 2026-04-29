import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/network/api_client.dart';

/// Widget to test and display backend connection status
class BackendConnectionTest extends StatefulWidget {
  const BackendConnectionTest({super.key});

  @override
  State<BackendConnectionTest> createState() => _BackendConnectionTestState();
}

class _BackendConnectionTestState extends State<BackendConnectionTest> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;
  String _status = 'Not tested';
  Map<String, dynamic>? _healthData;
  String? _error;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing...';
      _healthData = null;
      _error = null;
    });

    try {
      // Test basic health endpoint
      final response = await _apiClient.get('/health');

      if (response.statusCode == 200) {
        setState(() {
          _status = 'Connected ✅';
          _healthData = response.data;
          _error = null;
        });
      } else {
        setState(() {
          _status = 'Failed ❌';
          _error = 'HTTP ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error ❌';
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testTextAnalysis() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing text analysis...';
    });

    try {
      final response = await _apiClient.post(
        '/analyze/text',
        data: {'text': 'I am feeling great today!'},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        setState(() {
          _status = 'Text Analysis Working ✅';
          _healthData = response.data['data'];
          _error = null;
        });
      } else {
        setState(() {
          _status = 'Text Analysis Failed ❌';
          _error = response.data['error'] ?? 'Unknown error';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Text Analysis Error ❌';
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.network_check, size: 24, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Backend Connection Test',
                  style: AppFonts.copyWith(
                    AppFonts.bodyLarge(color: AppColors.textPrimary),
                    fontWeight: AppFonts.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Current configuration
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Backend URL: ${AppConfig.baseUrl}',
                    style: AppFonts.bodySmall(color: AppColors.textPrimary),
                  ),
                  Text(
                    'Environment: ${AppConfig.environment}',
                    style: AppFonts.bodySmall(color: AppColors.textPrimary),
                  ),
                  Text(
                    'Mock Data: ${AppConfig.enableMockData ? "Enabled" : "Disabled"}',
                    style: AppFonts.bodySmall(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Test buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testConnection,
                    icon:
                        _isLoading
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.health_and_safety),
                    label: const Text('Test Health'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testTextAnalysis,
                    icon:
                        _isLoading
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.psychology),
                    label: const Text('Test Analysis'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Status display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    _status.contains('✅')
                        ? AppColors.successSurface
                        : _status.contains('❌')
                        ? AppColors.errorSurface
                        : AppColors.infoSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      _status.contains('✅')
                          ? AppColors.success
                          : _status.contains('❌')
                          ? AppColors.error
                          : AppColors.info,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: $_status',
                    style: AppFonts.copyWith(
                      AppFonts.bodySmall(
                        color:
                            _status.contains('✅')
                                ? AppColors.successDark
                                : _status.contains('❌')
                                ? AppColors.error
                                : AppColors.info,
                      ),
                      fontWeight: AppFonts.bold,
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Error: $_error',
                      style: AppFonts.caption(color: AppColors.error),
                    ),
                  ],
                  if (_healthData != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Response Data:',
                      style: AppFonts.copyWith(
                        AppFonts.bodySmall(color: AppColors.textPrimary),
                        fontWeight: AppFonts.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatJsonData(_healthData!),
                        style: AppFonts.code(fontSize: AppFonts.sizeS),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.warning),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Instructions',
                        style: AppFonts.copyWith(
                          AppFonts.bodySmall(color: AppColors.textPrimary),
                          fontWeight: AppFonts.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. First, test the health endpoint to verify basic connectivity\n'
                    '2. Then test text analysis to verify AI functionality\n'
                    '3. If tests fail, check your internet connection and backend URL\n'
                    '4. For production, ensure the backend is deployed on Render',
                    style: AppFonts.caption(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatJsonData(Map<String, dynamic> data) {
    final buffer = StringBuffer();
    data.forEach((key, value) {
      if (value is Map || value is List) {
        buffer.writeln('$key: ${value.toString()}');
      } else {
        buffer.writeln('$key: $value');
      }
    });
    return buffer.toString().trim();
  }
}
