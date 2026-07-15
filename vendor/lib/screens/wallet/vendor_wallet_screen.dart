import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'withdraw_funds_screen.dart';
import 'earnings_dashboard_screen.dart';

class VendorWalletScreen extends StatelessWidget {
  const VendorWalletScreen({super.key});

  Widget _transactionItem({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String date,
    required String amount,
    required String status,
    required bool isPositive,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(24)),
            alignment: Alignment.center,
            child: Icon(icon, size: 20, color: const Color(0xFF475569)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.subtitleMedium),
                const SizedBox(height: 2),
                Text(date, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyles.subtitleMedium.copyWith(color: isPositive ? AppColors.success : AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                status,
                style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Container(
                  color: AppColors.background.withOpacity(0.9),
                  padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Vendor Wallet', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Balance Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Balance', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.8))),
                            const SizedBox(height: 4),
                            Text('GHS 3,200', style: AppTextStyles.heading2.copyWith(fontSize: 36, color: Colors.white)),
                            const SizedBox(height: 24),
                            Container(height: 1, color: Colors.white.withOpacity(0.2)),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('AVAILABLE', style: AppTextStyles.captionBold.copyWith(color: Colors.white.withOpacity(0.7), letterSpacing: 0.6)),
                                      const SizedBox(height: 4),
                                      Text('GHS 1,750', style: AppTextStyles.subtitleMedium.copyWith(fontSize: 18, color: Colors.white)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('PENDING', style: AppTextStyles.captionBold.copyWith(color: Colors.white.withOpacity(0.7), letterSpacing: 0.6)),
                                      const SizedBox(height: 4),
                                      Text('GHS 1,450', style: AppTextStyles.subtitleMedium.copyWith(fontSize: 18, color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Quick Actions
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const WithdrawFundsScreen(),
                                ));
                              },
                              icon: const Icon(LucideIcons.arrowUpRight, size: 16, color: Colors.white),
                              label: const Text('Withdraw', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(LucideIcons.creditCard, size: 16, color: AppColors.textPrimary),
                              label: const Text('Methods', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE2E8F0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Balance Breakdown
                      Text('Balance Breakdown', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border)),
                        child: Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: const Icon(LucideIcons.check, size: 20, color: AppColors.success),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Settled Sales', style: AppTextStyles.subtitleMedium),
                                  Text('Ready for withdrawal', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Text('GHS 1,750', style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border)),
                        child: Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: const BoxDecoration(color: Color(0xFFFEF3C7), shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: const Icon(LucideIcons.clock, size: 20, color: Color(0xFFD97706)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Escrowed Funds', style: AppTextStyles.subtitleMedium),
                                  Text('Processing delivery', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Text('GHS 1,450', style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const EarningsDashboardScreen(),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('See Earnings Dashboard', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                              const SizedBox(width: 8),
                              const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Recent History
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent History', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                          TextButton(
                            onPressed: () {},
                            child: Text('See All', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _transactionItem(
                        icon: LucideIcons.package,
                        iconBg: const Color(0xFFF1F5F9),
                        title: 'Order #YDO-78430',
                        date: 'Yesterday, 4:20 PM',
                        amount: '+ GHS 450',
                        status: 'COMPLETED',
                        isPositive: true,
                      ),
                      _transactionItem(
                        icon: LucideIcons.arrowDownLeft,
                        iconBg: const Color(0xFFF1F5F9),
                        title: 'Withdrawal to Bank',
                        date: '22 Oct, 10:15 AM',
                        amount: '- GHS 1,200',
                        status: 'PROCESSED',
                        isPositive: false,
                      ),
                      _transactionItem(
                        icon: LucideIcons.package,
                        iconBg: const Color(0xFFF1F5F9),
                        title: 'Order #YDO-78429',
                        date: '20 Oct, 2:45 PM',
                        amount: '+ GHS 820',
                        status: 'COMPLETED',
                        isPositive: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
