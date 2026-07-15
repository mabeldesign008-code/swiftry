import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ReportOrderIssueSheet extends StatefulWidget {
  final String orderId;
  const ReportOrderIssueSheet({super.key, required this.orderId});

  static Future<void> show(BuildContext context, {required String orderId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportOrderIssueSheet(orderId: orderId),
    );
  }

  @override
  State<ReportOrderIssueSheet> createState() => _ReportOrderIssueSheetState();
}

class _ReportOrderIssueSheetState extends State<ReportOrderIssueSheet> {
  String _selectedIssue = 'Customer didn\'t show up';

  final List<String> _issues = [
    'Customer didn\'t show up',
    'Rider issue',
    'Wrong items in order',
    'Other issue',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Report an Issue', style: AppTextStyles.heading2.copyWith(fontSize: 24)),
                  const SizedBox(height: 16),
                  Text('ORDER REFERENCE', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary, letterSpacing: 0.6)),
                  const SizedBox(height: 4),
                  Text('Order #${widget.orderId}', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                  const SizedBox(height: 24),
                  Text('Select Issue Category', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: _issues.map((issue) {
                  final isSelected = _selectedIssue == issue;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIssue = issue),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(issue, style: AppTextStyles.subtitleMedium),
                          Container(
                            width: 24, height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              border: Border.all(color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.3), width: 2),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Submit Report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
