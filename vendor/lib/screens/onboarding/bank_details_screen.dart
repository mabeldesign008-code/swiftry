import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/top_bar.dart';
import '../../widgets/common/primary_button.dart';
import 'under_review_screen.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  
  // Payment Method Selection
  bool _isMobileMoney = true;
  
  // Mobile Money Provider Selection
  String _selectedProvider = 'MTN'; // MTN, Telecel, AT

  void _onContinue() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const UnderReviewScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: TopBar(
          title: 'Vendor Setup',
          step: 5,
          total: 5,
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment Setup', style: AppTextStyles.heading2),
                          const SizedBox(height: 4),
                          Text(
                            'How would you like to receive payments?',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),

                    // Payment Method Selection
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _PaymentMethodToggle(
                                label: 'Mobile Money',
                                icon: LucideIcons.smartphone,
                                isSelected: _isMobileMoney,
                                onTap: () => setState(() => _isMobileMoney = true),
                              ),
                            ),
                            Expanded(
                              child: _PaymentMethodToggle(
                                label: 'Bank Account',
                                icon: LucideIcons.building2,
                                isSelected: !_isMobileMoney,
                                onTap: () => setState(() => _isMobileMoney = false),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Dynamic Fields based on method
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isMobileMoney) ...[
                            Text('Select Provider', style: AppTextStyles.subtitleMedium.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _ProviderButton(
                                  label: 'MTN',
                                  isSelected: _selectedProvider == 'MTN',
                                  onTap: () => setState(() => _selectedProvider = 'MTN'),
                                ),
                                const SizedBox(width: 8),
                                _ProviderButton(
                                  label: 'Telecel',
                                  isSelected: _selectedProvider == 'Telecel',
                                  onTap: () => setState(() => _selectedProvider = 'Telecel'),
                                ),
                                const SizedBox(width: 8),
                                _ProviderButton(
                                  label: 'AT',
                                  isSelected: _selectedProvider == 'AT',
                                  onTap: () => setState(() => _selectedProvider = 'AT'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Phone Number Input
                            Text('Phone Number', style: AppTextStyles.subtitleMedium.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  height: 56,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceSecondary,
                                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('+233', style: AppTextStyles.inputText.copyWith(color: AppColors.textSecondary)),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                                      border: Border(
                                        top: BorderSide(color: AppColors.border),
                                        right: BorderSide(color: AppColors.border),
                                        bottom: BorderSide(color: AppColors.border),
                                      ),
                                    ),
                                    child: FormBuilderTextField(
                                      name: 'momoNumber',
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: '24 123 4567',
                                        hintStyle: AppTextStyles.inputText.copyWith(color: AppColors.textTertiary),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            // Bank Account Fields
                            Text('Bank Name', style: AppTextStyles.subtitleMedium.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            FormBuilderTextField(
                              name: 'bankName',
                              decoration: InputDecoration(
                                hintText: 'Select your bank',
                                hintStyle: AppTextStyles.inputText.copyWith(color: AppColors.textTertiary),
                                fillColor: AppColors.surface,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text('Account Number', style: AppTextStyles.subtitleMedium.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            FormBuilderTextField(
                              name: 'accountNumber',
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter 10-14 digit account number',
                                hintStyle: AppTextStyles.inputText.copyWith(color: AppColors.textTertiary),
                                fillColor: AppColors.surface,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),

                          // Account Name
                          Text('Account Name', style: AppTextStyles.subtitleMedium.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          FormBuilderTextField(
                            name: 'accountName',
                            decoration: InputDecoration(
                              hintText: 'Enter account holder name',
                              hintStyle: AppTextStyles.inputText.copyWith(color: AppColors.textTertiary),
                              fillColor: AppColors.surface,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: AppColors.border),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Must match the name registered with your provider.',
                            style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Settlement Info Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTransparent5,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.primaryTransparent20),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(LucideIcons.fileText, size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  'SETTLEMENT INFORMATION',
                                  style: AppTextStyles.captionBold.copyWith(
                                    color: AppColors.primary,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _SettlementRow(
                              label: 'Food orders',
                              value: 'Every 7 days',
                            ),
                            const SizedBox(height: 12),
                            _SettlementRow(
                              label: 'High-value goods',
                              value: 'Every 30 days',
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(height: 1, color: AppColors.primaryTransparent20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Minimum payout', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                                Text('GHS 50.00', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    PrimaryButton(
                      label: 'Continue',
                      onPressed: _onContinue,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'By clicking continue, you agree to our Vendor Payment Terms.',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodToggle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodToggle({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 1, offset: const Offset(0, 1))]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: isSelected
                  ? AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)
                  : AppTextStyles.subtitleMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProviderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProviderButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryTransparent5 : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTextStyles.subtitleMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettlementRow extends StatelessWidget {
  final String label;
  final String value;

  const _SettlementRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 1, offset: const Offset(0, 1)),
            ],
          ),
          child: Text(
            value,
            style: AppTextStyles.subtitleMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
