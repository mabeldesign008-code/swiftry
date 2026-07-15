import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../dashboard/vendor_dashboard_screen.dart';

class UnderReviewScreen extends StatefulWidget {
  const UnderReviewScreen({super.key});

  @override
  State<UnderReviewScreen> createState() => _UnderReviewScreenState();
}

class _UnderReviewScreenState extends State<UnderReviewScreen> {
  bool _refreshing = false;

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.textPrimary,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      ),
    );
  }

  void _handleRefresh() {
    setState(() => _refreshing = true);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() => _refreshing = false);
        _showToast("Status is still under review. We'll notify you once complete.");
      }
    });
  }

  void _goToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const VendorDashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Application Status',
          style: AppTextStyles.heading2.copyWith(fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            // Hero Icon
            SizedBox(
              width: 144,
              height: 144,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 144,
                    height: 144,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF4263EB).withOpacity(0.5), width: 2),
                    ),
                  ),
                  Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF5F7FE),
                    ),
                    child: const Icon(LucideIcons.check, size: 44, color: Color(0xFF4263EB)),
                  ),
                  // Stars
                  const Positioned(
                    top: -4,
                    left: 0,
                    child: Icon(LucideIcons.star, size: 20, color: Color(0xFF4263EB)),
                  ),
                  const Positioned(
                    top: 16,
                    right: -4,
                    child: Icon(LucideIcons.star, size: 16, color: Color(0xFF4263EB)),
                  ),
                  Positioned(
                    bottom: 16,
                    left: -4,
                    child: Icon(LucideIcons.star, size: 12, color: const Color(0xFF4263EB).withOpacity(0.3)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Text content
            Text(
              'Your application is under review',
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Our team is currently verifying your business details. This usually takes 24–48 business hours. We'll notify you once it's complete.",
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Buttons
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _refreshing ? null : _handleRefresh,
                icon: _refreshing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(LucideIcons.refreshCw, size: 18),
                label: Text(_refreshing ? 'Checking...' : 'Refresh status'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                  disabledForegroundColor: Colors.white,
                  textStyle: AppTextStyles.buttonText,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _showToast('Opening support chat...'),
                icon: const Icon(LucideIcons.messageSquare, size: 18, color: AppColors.textPrimary),
                label: Text('Contact support', style: AppTextStyles.buttonText.copyWith(color: AppColors.textPrimary)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.border,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: _goToDashboard,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Go to Dashboard', style: AppTextStyles.buttonText.copyWith(color: AppColors.primary)),
                    const SizedBox(width: 8),
                    const Icon(LucideIcons.arrowRight, size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Business Summary
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Business Summary', style: AppTextStyles.heading3),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.surfaceSecondary),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF9C3),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEAB308),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'PENDING REVIEW',
                                      style: AppTextStyles.captionBold.copyWith(
                                        color: const Color(0xFFA16207),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Your Business', style: AppTextStyles.subtitle),
                              Text('Restaurant / Food', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(LucideIcons.mapPin, size: 12, color: AppColors.textTertiary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Address on file',
                                    style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(LucideIcons.building2, size: 28, color: AppColors.border),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
