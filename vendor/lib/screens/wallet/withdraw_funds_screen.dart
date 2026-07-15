import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class WithdrawFundsScreen extends StatefulWidget {
  const WithdrawFundsScreen({super.key});

  @override
  State<WithdrawFundsScreen> createState() => _WithdrawFundsScreenState();
}

class _WithdrawFundsScreenState extends State<WithdrawFundsScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedMethod = 'mtn';
  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Widget _payoutMethod({
    required String id,
    required String title,
    required String subtitle,
    required Color iconBgColor,
    required Widget icon,
  }) {
    final isSelected = _selectedMethod == id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(16)),
              alignment: Alignment.center,
              child: icon,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.subtitleMedium),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(LucideIcons.checkCircle2, color: AppColors.primary, size: 20)
            else
              Container(
                width: 20, height: 20,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFCBD5E1))),
              ),
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
        elevation: 1,
        shadowColor: AppColors.border,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Withdraw Funds', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Available Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available Balance', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary.withOpacity(0.8))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('GHS 3,200', style: AppTextStyles.heading2.copyWith(fontSize: 30)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(16)),
                        child: Text('Verified', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF15803D))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Withdrawal Amount
            Text('Withdrawal Amount', style: AppTextStyles.subtitleMedium.copyWith(fontSize: 16)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Row(
                children: [
                  Text('GHS', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.textSecondary, fontSize: 16)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: AppTextStyles.heading2.copyWith(fontSize: 18, color: AppColors.textSecondary),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0.00',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _amountController.text = '3200.00';
                      });
                    },
                    child: Text('MAX', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text('Minimum withdrawal: GHS 10.00', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            // Payout Method
            Text('Payout Method', style: AppTextStyles.subtitleMedium.copyWith(fontSize: 16)),
            const SizedBox(height: 12),
            _payoutMethod(
              id: 'mtn',
              title: 'MTN Mobile Money',
              subtitle: '024 •••• 567',
              iconBgColor: const Color(0xFFFFCC00),
              icon: const Icon(LucideIcons.smartphone, size: 20, color: Colors.black),
            ),
            _payoutMethod(
              id: 'vodafone',
              title: 'Vodafone Cash',
              subtitle: '020 •••• 890',
              iconBgColor: const Color(0xFFDC2626),
              icon: const Icon(LucideIcons.smartphone, size: 20, color: Colors.white),
            ),
            
            // Add New Button
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid), // Should be dashed ideally
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.plus, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text('Add New Payout Method', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Withdrawal Fee', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      Text('GHS 2.50', style: AppTextStyles.subtitleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Processing Time', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      Text('Within 24 Hours', style: AppTextStyles.subtitleMedium),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: AppColors.border),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('You\'ll Receive', style: AppTextStyles.subtitleMedium),
                      Text(
                        _amountController.text.isEmpty || double.tryParse(_amountController.text) == null
                            ? 'GHS 0.00'
                            : 'GHS ${(double.parse(_amountController.text) - 2.50).toStringAsFixed(2)}',
                        style: AppTextStyles.heading2.copyWith(fontSize: 18, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120), // padding for bottom bar
          ],
        ),
      ),
      bottomSheet: Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Simulate withdrawal success
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Withdrawal request submitted successfully!')));
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 4,
                  shadowColor: AppColors.primary.withOpacity(0.4),
                ),
                child: Text('Confirm Withdrawal', style: AppTextStyles.subtitleMedium.copyWith(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.lock, size: 12, color: AppColors.textPrimary),
                const SizedBox(width: 6),
                Text(
                  'END-TO-END ENCRYPTED TRANSFER',
                  style: AppTextStyles.captionBold.copyWith(fontSize: 10, letterSpacing: 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
