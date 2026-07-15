import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class PromotionInsightsScreen extends StatelessWidget {
  const PromotionInsightsScreen({super.key});

  Widget _statCard(String label, String value, String subLabel, {bool highlight = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.6)),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.heading2.copyWith(fontSize: 24)),
          const SizedBox(height: 4),
          Text(subLabel, style: AppTextStyles.caption.copyWith(color: highlight ? AppColors.primary : AppColors.textSecondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: AppColors.border,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Promotion Insights', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(LucideIcons.tag, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Active', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary, letterSpacing: 0.6)),
                        Text('2 Live Promotions', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _statCard('VIEWS', '450', '+25%', highlight: true)),
                const SizedBox(width: 16),
                Expanded(child: _statCard('UNIQUE VIEWERS', '380', 'Past 7 days')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _statCard('PRODUCT TAPS', '85', '19% rate', highlight: true)),
                const SizedBox(width: 16),
                Expanded(child: _statCard('ORDERS', '24', '₵1,200 Revenue')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
