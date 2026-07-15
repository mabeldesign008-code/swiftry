import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';

/// Full-width primary action button with loading state support.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double height;
  final double? width;
  final double borderRadius;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double fontSize;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.height = 56,
    this.width,
    this.borderRadius = 14,
    this.prefixIcon,
    this.suffixIcon,
    this.fontSize = 16,
  });

  const PrimaryButton.outline({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.backgroundColor = Colors.transparent,
    this.textColor = const Color(0xFF0068FF),
    this.borderColor = const Color(0xFF0068FF),
    this.height = 56,
    this.width,
    this.borderRadius = 14,
    this.prefixIcon,
    this.suffixIcon,
    this.fontSize = 16,
  });

  const PrimaryButton.secondary({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.backgroundColor = const Color(0xFFEFF5FF),
    this.textColor = const Color(0xFF0068FF),
    this.borderColor,
    this.height = 56,
    this.width,
    this.borderRadius = 14,
    this.prefixIcon,
    this.suffixIcon,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? const Color(0xFF0068FF);
    final fg = textColor ?? Colors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: bg.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.5)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: fg,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    Icon(prefixIcon, color: fg, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: AppFonts.inter(
                      color: fg,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(suffixIcon, color: fg, size: 20),
                  ],
                ],
              ),
      ),
    );
  }
}
