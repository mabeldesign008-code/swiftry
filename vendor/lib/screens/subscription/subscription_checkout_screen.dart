import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SubscriptionCheckoutScreen extends StatefulWidget {
  const SubscriptionCheckoutScreen({super.key});

  @override
  State<SubscriptionCheckoutScreen> createState() => _SubscriptionCheckoutScreenState();
}

class _SubscriptionCheckoutScreenState extends State<SubscriptionCheckoutScreen> {
  String _billingCycle = 'monthly';
  String _paymentMethod = 'visa';
  bool _agreed = false;
  bool _loading = false;
  bool _success = false;

  void _handleSubscribe() {
    if (!_agreed || _loading) return;
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _loading = false;
          _success = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_success) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(LucideIcons.circleCheck, size: 52, color: AppColors.primary),
                ),
                const SizedBox(height: 24),
                Text('Subscribed!', style: AppTextStyles.heading1.copyWith(fontSize: 30)),
                const SizedBox(height: 8),
                Text(
                  'You are now on the Premium plan. Enjoy reduced commissions and priority support.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      textStyle: AppTextStyles.buttonText,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Back to Dashboard'),
                        SizedBox(width: 8),
                        Icon(LucideIcons.arrowRight, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final subtotal = _billingCycle == 'monthly' ? 'GHS 99.00' : 'GHS 950.00';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Checkout', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Plan summary
            Text('Plan Summary', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SELECTED PLAN', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text('Premium Plan', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                        const SizedBox(height: 2),
                        Text('Reduced commission + priority support', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(LucideIcons.lock, size: 22, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Billing cycle
            Text('Billing Cycle', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            _BillingOption(
              id: 'monthly',
              label: 'Monthly',
              sub: 'Billed every month',
              price: 'GHS 99',
              isSelected: _billingCycle == 'monthly',
              onTap: () => setState(() => _billingCycle = 'monthly'),
            ),
            const SizedBox(height: 12),
            _BillingOption(
              id: 'yearly',
              label: 'Yearly',
              sub: 'Billed annually',
              price: 'GHS 950',
              original: 'GHS 1,188',
              badge: 'Save 20%',
              isSelected: _billingCycle == 'yearly',
              onTap: () => setState(() => _billingCycle = 'yearly'),
            ),
            const SizedBox(height: 24),

            // Payment method
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Payment Method', style: AppTextStyles.subtitle),
                Text('Add New', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 12),
            _PaymentOption(
              id: 'visa',
              title: '•••• •••• •••• 4242',
              subtitle: 'Visa — Expires 12/26',
              iconData: LucideIcons.creditCard,
              iconColor: const Color(0xFF475569),
              iconBg: const Color(0xFFF1F5F9),
              isSelected: _paymentMethod == 'visa',
              onTap: () => setState(() => _paymentMethod = 'visa'),
            ),
            const SizedBox(height: 12),
            _PaymentOption(
              id: 'momo',
              title: 'MTN Mobile Money',
              subtitle: '024 •••• 890',
              iconData: LucideIcons.smartphone,
              iconColor: const Color(0xFFCA8A04),
              iconBg: const Color(0xFFFEF9C3),
              isSelected: _paymentMethod == 'momo',
              onTap: () => setState(() => _paymentMethod = 'momo'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFFACC15), borderRadius: BorderRadius.circular(4)),
                child: Text('MTN', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF78350F), fontSize: 9)),
              ),
            ),
            const SizedBox(height: 24),

            // Order summary
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Summary', style: AppTextStyles.subtitle.copyWith(fontSize: 18)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      Text(subtotal, style: AppTextStyles.subtitleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax (0%)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      Text('GHS 0.00', style: AppTextStyles.subtitleMedium),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: const Color(0xFFF1F5F9)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTextStyles.subtitle.copyWith(fontSize: 18)),
                      Text(subtotal, style: AppTextStyles.heading2.copyWith(fontSize: 24, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => setState(() => _agreed = !_agreed),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: _agreed ? AppColors.primary : Colors.transparent,
                            border: Border.all(color: _agreed ? AppColors.primary : AppColors.border, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: _agreed ? const Icon(LucideIcons.check, size: 12, color: Colors.white) : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(text: 'Terms of Service', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, decoration: TextDecoration.underline)),
                                TextSpan(text: ' and authorize automatic renewal at $subtotal until cancelled.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _agreed && !_loading ? _handleSubscribe : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFCBD5E1),
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        elevation: 8,
                        shadowColor: _agreed && !_loading ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
                      ),
                      child: _loading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                                SizedBox(width: 8),
                                Text('Processing...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(LucideIcons.lock, size: 16),
                                SizedBox(width: 8),
                                Text('Subscribe Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.shield, size: 13, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 6),
                      Text('Secure SSL Encrypted Payment', style: AppTextStyles.caption.copyWith(color: const Color(0xFF94A3B8))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillingOption extends StatelessWidget {
  final String id;
  final String label;
  final String sub;
  final String price;
  final String? original;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _BillingOption({
    required this.id,
    required this.label,
    required this.sub,
    required this.price,
    this.original,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.04) : Colors.white,
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: 2),
              ),
              alignment: Alignment.center,
              child: isSelected ? const Icon(LucideIcons.check, size: 11, color: Colors.white) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(label, style: AppTextStyles.subtitle),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(16)),
                          child: Text(badge!, style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF15803D), fontSize: 10)),
                        ),
                      ],
                    ],
                  ),
                  Text(sub, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: AppTextStyles.subtitle.copyWith(fontSize: 18)),
                if (original != null)
                  Text(original!, style: AppTextStyles.caption.copyWith(color: const Color(0xFF94A3B8), decoration: TextDecoration.lineThrough)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final IconData iconData;
  final Color iconColor;
  final Color iconBg;
  final Widget? trailing;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.iconColor,
    required this.iconBg,
    this.trailing,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: 2),
              ),
              alignment: Alignment.center,
              child: isSelected ? const Icon(LucideIcons.check, size: 11, color: Colors.white) : null,
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: Icon(iconData, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.subtitleMedium.copyWith(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
