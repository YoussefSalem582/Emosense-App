import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emosense_mobile/core/core.dart';

/// Widget for live recording section
class VoiceAnalysisRecordingSection extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onRecordingToggle;

  const VoiceAnalysisRecordingSection({
    super.key,
    required this.isRecording,
    required this.onRecordingToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.mic,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Live Recording',
                  style: AppFonts.copyWith(
                    AppFonts.bodyLarge(color: AppColors.darkSurface),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      onRecordingToggle();
                      HapticFeedback.mediumImpact();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color:
                            isRecording
                                ? AppColors.error
                                : AppColors.error.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isRecording ? Icons.stop : Icons.mic,
                        size: 40,
                        color:
                            isRecording
                                ? AppColors.white
                                : AppColors.error,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isRecording ? 'Recording... 00:42' : 'Ready to Record',
                    style: AppFonts.button(
                      color:
                          isRecording
                              ? AppColors.error
                              : AppColors.darkSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isRecording
                        ? 'Tap to stop recording'
                        : 'Tap the microphone to start recording',
                    style: AppFonts.bodySmall(color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      onRecordingToggle();
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isRecording
                              ? AppColors.textTertiary
                              : AppColors.error,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isRecording ? 'Stop Recording' : 'Start Recording',
                      style: AppFonts.button(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
