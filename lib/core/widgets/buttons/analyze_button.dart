import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emosense_mobile/features/emotion/presentation/bloc/emotion_bloc.dart';
import '../../../core/core.dart';

class AnalyzeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AnalyzeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmotionBloc, EmotionState>(
      builder: (context, state) {
        return Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isButtonEnabled(state) ? onPressed : null,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading(state)) ...[
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        AppStrings.analyzing,
                        style: AppFonts.copyWith(
                          AppFonts.bodyLarge(color: AppColors.white),
                          fontWeight: AppFonts.semiBold,
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.psychology,
                        color: AppColors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppStrings.analyzeButton,
                        style: AppFonts.copyWith(
                          AppFonts.bodyLarge(color: AppColors.white),
                          fontWeight: AppFonts.semiBold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isButtonEnabled(EmotionState state) {
    if (state is EmotionConnectionResult) {
      return state.isConnected && !_isLoading(state);
    }
    return !_isLoading(state);
  }

  bool _isLoading(EmotionState state) {
    return state is EmotionLoading;
  }
}
