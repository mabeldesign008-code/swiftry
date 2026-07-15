import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'withdraw_funds_screen.dart';

class EarningsDashboardScreen extends StatelessWidget {
  const EarningsDashboardScreen({super.key});

  Widget _metricCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.subtitleMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
              child: const Icon(LucideIcons.wallet, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text('Balance', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.calendar, size: 20, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0052CC), Color(0xFF1D4ED8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Revenue Summary', style: AppTextStyles.subtitleMedium.copyWith(color: Colors.white.withOpacity(0.9))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.trendingUp, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text('18%', style: AppTextStyles.captionBold.copyWith(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('GHS 4,250.00', style: AppTextStyles.heading2.copyWith(fontSize: 32, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Calculated from last 7 days', style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.8))),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const WithdrawFundsScreen(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                          child: Text('Withdraw Funds', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                        child: const Icon(LucideIcons.arrowUpRight, size: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Metrics
            Row(
              children: [
                _metricCard('Avg. Order', 'GHS 142', LucideIcons.barChart2),
                const SizedBox(width: 12),
                _metricCard('Rating', '4.8 / 5.0', LucideIcons.star),
                const SizedBox(width: 12),
                _metricCard('Top Item', 'Eco-Bag', LucideIcons.award),
              ],
            ),
            const SizedBox(height: 24),

            // Daily Revenue Chart Placeholder
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily Revenue', style: AppTextStyles.subtitleMedium),
                  const SizedBox(height: 24),
                  // Mock Chart
                  SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _chartBar(50, 'Mon'),
                        _chartBar(75, 'Tue'),
                        _chartBar(105, 'Wed', isMax: true),
                        _chartBar(65, 'Thu'),
                        _chartBar(85, 'Fri'),
                        _chartBar(40, 'Sat'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Earnings Breakdown
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Earnings Breakdown', style: AppTextStyles.subtitleMedium),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.wallet, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text('Gross Earnings', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                      Text('GHS 5,000.00', style: AppTextStyles.subtitleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.percent, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text('Commission (10%)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                      Text('- GHS 500.00', style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFFDC2626))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: AppColors.border),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.checkCircle2, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text('Net Earnings', style: AppTextStyles.subtitleMedium),
                        ],
                      ),
                      Text('GHS 4,500.00', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Next Settlement
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(LucideIcons.calendarClock, size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NEXT SETTLEMENT', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary, letterSpacing: 0.6)),
                        const SizedBox(height: 2),
                        Text('Wednesday, Oct 25', style: AppTextStyles.subtitleMedium),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Pending', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 2),
                      Text('GHS 1,450.00', style: AppTextStyles.subtitleMedium),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _chartBar(double height, String label, {bool isMax = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 32,
          height: height,
          decoration: BoxDecoration(
            color: isMax ? AppColors.primary : AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
