import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../ratings/respond_to_review_screen.dart';
import '../dashboard/report_order_issue_sheet.dart';

class CompletedOrderDetailScreen extends StatefulWidget {
  const CompletedOrderDetailScreen({super.key});

  @override
  State<CompletedOrderDetailScreen> createState() => _CompletedOrderDetailScreenState();
}

class _CompletedOrderDetailScreenState extends State<CompletedOrderDetailScreen> {
  String? _toast;

  void _showToast(String msg) {
    setState(() => _toast = msg);
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _toast = null);
    });
  }

  final List<Map<String, dynamic>> _timeline = [
    {'label': 'Received', 'time': '2:45 PM', 'done': true},
    {'label': 'Accepted', 'time': '2:46 PM', 'done': true},
    {'label': 'Ready for pickup', 'time': '3:02 PM', 'done': true},
    {'label': 'Picked up', 'time': '3:08 PM', 'done': true},
    {'label': 'Delivered', 'time': '3:25 PM', 'done': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              SafeArea(
                bottom: false,
                child: Container(
                  color: const Color(0xFFF8F6F6),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text('Order #YDO-78430', style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(20)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle)),
                                          const SizedBox(width: 6),
                                          Text('Delivered', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF15803D))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 48), // spacer for alignment
                          ],
                        ),
                      ),
                      Container(height: 1, color: const Color(0xFFE8E4E4)),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16).copyWith(bottom: 32),
                  child: Column(
                    children: [
                      // Order Items
                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ORDER ITEMS', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8))),
                            const Divider(height: 20),
                            _orderItem('2× Jollof Rice with Chicken', 'Extra spicy · fried plantain', 'GHS 70.00'),
                            const Divider(height: 16),
                            _orderItem('1× Coca-Cola', '330ml chilled', 'GHS 15.00'),
                          ],
                        ),
                      ),

                      // Earnings Breakdown
                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('EARNINGS BREAKDOWN', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8))),
                            const SizedBox(height: 16),
                            _summaryRow('Order Total', 'GHS 85.00'),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Commission (15%)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                                Text('−GHS 12.75', style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFFDC2626))),
                              ],
                            ),
                            const Divider(height: 24),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1463FF).withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Your Earnings', style: AppTextStyles.subtitle),
                                  Text('GHS 72.25', style: AppTextStyles.heading2.copyWith(fontSize: 20, color: const Color(0xFF1463FF))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.wallet, size: 14, color: Color(0xFF94A3B8)),
                                  const SizedBox(width: 8),
                                  RichText(
                                    text: TextSpan(
                                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                                      children: const [
                                        TextSpan(text: 'Settlement scheduled for '),
                                        TextSpan(text: 'Mar 9, 2026', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Order Timeline
                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('TIMELINE', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8), letterSpacing: 0.7)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
                                  child: Text('40 min total', style: AppTextStyles.caption.copyWith(color: const Color(0xFF64748B), fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Grid-style timeline matching Container27 exactly
                            ...List.generate(_timeline.length, (i) {
                              final step = _timeline[i];
                              final isLast = i == _timeline.length - 1;
                              return IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Left column: icon + connector line
                                    SizedBox(
                                      width: 40,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF1463FF),
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: const Icon(LucideIcons.check, size: 11, color: Colors.white),
                                          ),
                                          if (!isLast)
                                            Expanded(
                                              child: Container(
                                                width: 2,
                                                margin: const EdgeInsets.symmetric(vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFEC5B13).withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(1),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Right column: step info
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: isLast ? 0 : 24, top: 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              step['label'],
                                              style: AppTextStyles.bodyMedium.copyWith(
                                                fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
                                                color: isLast ? AppColors.textPrimary : const Color(0xFF0F172A),
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              step['time'],
                                              style: AppTextStyles.caption.copyWith(
                                                color: const Color(0xFF64748B),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      // Customer Review
                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CUSTOMER REVIEW', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8))),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                ...List.generate(5, (i) => const Icon(LucideIcons.star, size: 18, color: Color(0xFFF59E0B))),
                                const SizedBox(width: 6),
                                Text('5.0', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '"Food was delicious and arrived hot! The plantain was perfectly done. Will definitely order again."',
                              style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF334155), fontStyle: FontStyle.italic, height: 1.5),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const RespondToReviewScreen(),
                                ));
                              },
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.messageSquare, size: 14, color: Color(0xFF1463FF)),
                                  const SizedBox(width: 6),
                                  Text('Respond to review', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF1463FF))),
                                  const SizedBox(width: 4),
                                  const Icon(LucideIcons.arrowRight, size: 13, color: Color(0xFF1463FF)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () {
                            ReportOrderIssueSheet.show(context, orderId: 'YDO-78430');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Report an Issue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (_toast != null)
            Positioned(
              bottom: 24, left: 32, right: 32,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(16)),
                child: Text(_toast!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E4E4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
      ),
      child: child,
    );
  }

  Widget _orderItem(String name, String mod, String price) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.subtitle),
              Text(mod, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        Text(price, style: AppTextStyles.subtitle),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTextStyles.subtitleMedium),
      ],
    );
  }
}
