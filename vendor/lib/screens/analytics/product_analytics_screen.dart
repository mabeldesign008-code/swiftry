import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'promotion_insights_screen.dart';

class ProductAnalyticsScreen extends StatelessWidget {
  const ProductAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 1,
        shadowColor: AppColors.border,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Analytics', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chart Area Placeholder
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeframe
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _timeTab('Week', false),
                        _timeTab('Month', true),
                        _timeTab('Year', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Chart placeholder
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text('Chart Placeholder\n(Revenue over time)', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8))),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Summary Stats
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Revenue', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Text('₵42,500.00', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(LucideIcons.trendingUp, size: 14, color: AppColors.success),
                            const SizedBox(width: 4),
                            Text('+8.2%', style: AppTextStyles.captionBold.copyWith(color: AppColors.success)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Orders', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Text('1,284', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                        const SizedBox(height: 4),
                        Text('+12%', style: AppTextStyles.captionBold.copyWith(color: AppColors.success)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Avg Rating', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('4.8', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                            const SizedBox(width: 4),
                            const Icon(LucideIcons.star, size: 16, color: Color(0xFFFBBF24)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('-0.2%', style: AppTextStyles.captionBold.copyWith(color: AppColors.error)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Link to Promotion Insights
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PromotionInsightsScreen(),
                ));
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.tag, color: Colors.white, size: 20),
                        const SizedBox(width: 12),
                        Text('View Promotion Insights', style: AppTextStyles.subtitleMedium.copyWith(color: Colors.white)),
                      ],
                    ),
                    const Icon(LucideIcons.chevronRight, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Premium Insights
            Row(
              children: [
                const Icon(LucideIcons.sparkles, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Premium Insights', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(LucideIcons.trendingUp, size: 20, color: AppColors.success),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Peak Demand Rising', style: AppTextStyles.subtitleMedium),
                        const SizedBox(height: 4),
                        Text(
                          'Orders increase by 35% between 6 PM - 9 PM on weekends. Consider increasing staff capacity.',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(LucideIcons.clock, size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Popular Ordering Times', style: AppTextStyles.subtitleMedium),
                        const SizedBox(height: 12),
                        // Mini bar chart representation
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Container(decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.3), borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6))))),
                              Expanded(flex: 5, child: Container(color: AppColors.primary)),
                              Expanded(flex: 3, child: Container(decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.3), borderRadius: const BorderRadius.only(topRight: Radius.circular(6), bottomRight: Radius.circular(6))))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Morning', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                            Text('Evening Peak', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary, fontSize: 10)),
                            Text('Late', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                          ],
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

  Widget _timeTab(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF6C56F9) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
