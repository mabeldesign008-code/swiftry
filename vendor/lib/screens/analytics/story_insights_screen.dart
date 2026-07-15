import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StoryInsightsScreen extends StatelessWidget {
  const StoryInsightsScreen({super.key});

  Widget _statRow(String label, String value, String subText) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.textSecondary)),
          Row(
            children: [
              Text(value, style: AppTextStyles.heading2.copyWith(fontSize: 18)),
              const SizedBox(width: 8),
              Text(subText, style: AppTextStyles.captionBold.copyWith(color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: AppColors.border,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Story Insights', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(LucideIcons.image, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Active - 18h remaining', style: AppTextStyles.subtitleMedium.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Posted yesterday at 4:00 PM', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text('CORE PERFORMANCE', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.6)),
            const SizedBox(height: 8),
            _statRow('Views', '450', '+25%'),
            _statRow('Unique Viewers', '380', ''),
            _statRow('Product Taps', '85', '19% rate'),
            _statRow('Orders from Story', '12', '₵450.00'),
          ],
        ),
      ),
    );
  }
}
