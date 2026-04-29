import 'package:flutter/material.dart';

import 'package:emosense_mobile/core/core.dart';

class AuthTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool isPasswordField;
  final bool isPasswordVisible;
  final VoidCallback? onPasswordToggle;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool enabled;
  final Animation<double>? animation;
  final bool useWhiteBackground;

  const AuthTextFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.isPasswordField = false,
    this.isPasswordVisible = false,
    this.onPasswordToggle,
    this.validator,
    this.keyboardType,
    this.enabled = true,
    this.animation,
    this.useWhiteBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget textField = TextFormField(
      controller: controller,
      obscureText: isPasswordField && !isPasswordVisible,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      style: AppFonts.bodyMedium(
        color: useWhiteBackground ? AppColors.textPrimary : Colors.white,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(
          prefixIcon,
          color:
              useWhiteBackground
                  ? Colors.grey.shade600
                  : Colors.white.withValues(alpha: 0.8),
        ),
        suffixIcon:
            isPasswordField
                ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color:
                        useWhiteBackground
                            ? Colors.grey.shade600
                            : Colors.white.withValues(alpha: 0.8),
                  ),
                  onPressed: onPasswordToggle,
                )
                : null,
        labelStyle: AppFonts.bodySmall(
          color:
              useWhiteBackground
                  ? AppColors.gray700
                  : Colors.white.withValues(alpha: 0.8),
        ),
        hintStyle: AppFonts.bodySmall(
          color:
              useWhiteBackground
                  ? AppColors.gray500
                  : Colors.white.withValues(alpha: 0.6),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color:
                useWhiteBackground
                    ? Colors.grey.shade300
                    : Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: useWhiteBackground ? AppColors.primary : Colors.white,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color:
                useWhiteBackground
                    ? Colors.red.shade400
                    : Colors.red.withValues(alpha: 0.8),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color:
                useWhiteBackground
                    ? Colors.grey.shade200
                    : Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        filled: true,
        fillColor:
            useWhiteBackground
                ? Colors.grey.shade50
                : Colors.white.withValues(alpha: 0.1),
        errorStyle: AppFonts.bodyXS(
          color:
              useWhiteBackground
                  ? AppColors.error
                  : Colors.red.withValues(alpha: 0.9),
        ),
      ),
    );

    if (animation != null) {
      return AnimatedBuilder(
        animation: animation!,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - animation!.value)),
            child: Opacity(opacity: animation!.value, child: textField),
          );
        },
      );
    }

    return textField;
  }
}
