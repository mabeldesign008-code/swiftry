import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SettlementScheduleScreen extends StatelessWidget {
  const SettlementScheduleScreen({super.key});

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
        title: Text('Settlements', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Next Payout
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
                  Text('Next Payout', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ESTIMATED AMOUNT', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.6)),
                          const SizedBox(height: 4),
                          Text('GHS 3,200', style: AppTextStyles.heading2.copyWith(fontSize: 30, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('UPCOMING', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text('Period: Feb 24 - Mar 2', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Visual Timeline
                  SizedBox(
                    height: 50,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Line
                        Positioned(
                          left: 0, right: 0,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0, width: MediaQuery.of(context).size.width * 0.3,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Nodes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _timelineNode('ORDER PERIOD', AppColors.primary, true),
                            _timelineNode('HOLD PERIOD', AppColors.primary, true),
                            _timelineNode('SETTLEMENT', const Color(0xFFE2E8F0), false),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('View Detailed Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Past Settlements
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Past Settlements', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                TextButton(
                  onPressed: () {},
                  child: Text('See All', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _pastSettlementItem('Feb 17 - Feb 23', 'Paid on Feb 25, 2024', 'GHS 2,840.50'),
            const SizedBox(height: 12),
            _pastSettlementItem('Feb 10 - Feb 16', 'Paid on Feb 18, 2024', 'GHS 4,120.00'),
            const SizedBox(height: 12),
            _pastSettlementItem('Feb 03 - Feb 09', 'Paid on Feb 11, 2024', 'GHS 1,950.25'),
          ],
        ),
      ),
    );
  }

  Widget _timelineNode(String label, Color color, bool filled) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: filled ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.captionBold.copyWith(color: color, fontSize: 10)),
      ],
    );
  }

  Widget _pastSettlementItem(String period, String dateStr, String amount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(LucideIcons.check, size: 20, color: AppColors.success),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(period, style: AppTextStyles.subtitleMedium),
                const SizedBox(height: 4),
                Text(dateStr, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: AppTextStyles.subtitleMedium),
              const SizedBox(height: 4),
              Text('SUCCESS', style: AppTextStyles.captionBold.copyWith(color: AppColors.success, letterSpacing: 1.0)),
            ],
          ),
        ],
      ),
    );
  }
}
