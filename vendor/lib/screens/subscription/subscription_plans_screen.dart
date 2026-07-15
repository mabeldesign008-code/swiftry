import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  final VoidCallback onCheckout;

  const SubscriptionPlansScreen({super.key, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Subscription Plans', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        actions: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            alignment: Alignment.center,
            child: Text('?', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary, fontSize: 14)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Upgrade & Grow', style: AppTextStyles.heading1.copyWith(fontSize: 24, letterSpacing: -0.5)),
            const SizedBox(height: 4),
            Text('Choose the best plan for your business needs.', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 20),

            // Free Plan
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FREE', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8), letterSpacing: 1.4)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('GHS 0', style: AppTextStyles.heading1.copyWith(fontSize: 36)),
                      const SizedBox(width: 4),
                      Text('/mo', style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF94A3B8))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: Text('Current Plan', style: AppTextStyles.buttonText.copyWith(color: const Color(0xFF94A3B8))),
                  ),
                  const SizedBox(height: 20),
                  _FeatureRow('Standard visibility', isPremium: false),
                  const SizedBox(height: 12),
                  _FeatureRow('15% Commission per sale', isPremium: false),
                  const SizedBox(height: 12),
                  _FeatureRow('Basic seller support', isPremium: false),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Premium Plan
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -24,
                    right: -24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), topRight: Radius.circular(22)),
                      ),
                      child: Text('POPULAR', style: AppTextStyles.captionBold.copyWith(color: Colors.white, fontSize: 10, letterSpacing: 1)),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PREMIUM', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary, letterSpacing: 1.4)),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('GHS 99', style: AppTextStyles.heading1.copyWith(fontSize: 36)),
                          const SizedBox(width: 4),
                          Text('/mo', style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF94A3B8))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: onCheckout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            textStyle: AppTextStyles.buttonText,
                            elevation: 8,
                            shadowColor: AppColors.primary.withOpacity(0.35),
                          ),
                          child: const Text('Subscribe to Premium'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _FeatureRow('Reduced 12% commission', isPremium: true),
                      const SizedBox(height: 12),
                      _FeatureRow('Business Stories access', isPremium: true),
                      const SizedBox(height: 12),
                      _FeatureRow('Priority seller support', isPremium: true),
                    ],
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

class _FeatureRow extends StatelessWidget {
  final String label;
  final bool isPremium;

  const _FeatureRow(this.label, {required this.isPremium});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isPremium
            ? Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(LucideIcons.check, size: 10, color: Colors.white),
              )
            : const Icon(LucideIcons.circleCheck, size: 16, color: Color(0xFFCBD5E1)),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isPremium ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isPremium ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
