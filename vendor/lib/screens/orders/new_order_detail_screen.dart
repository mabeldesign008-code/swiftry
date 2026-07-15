import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class NewOrderDetailScreen extends StatefulWidget {
  const NewOrderDetailScreen({super.key});

  @override
  State<NewOrderDetailScreen> createState() => _NewOrderDetailScreenState();
}

class _NewOrderDetailScreenState extends State<NewOrderDetailScreen> {
  int _secs = 150;
  Timer? _timer;
  bool _accepted = false;
  String? _toast;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _secs > 0) setState(() => _secs--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showToast(String msg) {
    setState(() => _toast = msg);
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) setState(() => _toast = null);
    });
  }

  void _handleAccept() {
    setState(() => _accepted = true);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _handleDecline() {
    _showToast('Order declined.');
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    if (_accepted) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F6F6),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96, height: 96,
                decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(LucideIcons.circleCheck, size: 44, color: Color(0xFF16A34A)),
              ),
              const SizedBox(height: 24),
              Text('Order Accepted!', style: AppTextStyles.heading2.copyWith(fontSize: 24)),
              const SizedBox(height: 8),
              Text('Heading back to orders…', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
      );
    }

    final mins = _secs ~/ 60;
    final secs = _secs % 60;

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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Expanded(
                              child: Center(child: Text('Order #YDO-78430', style: AppTextStyles.subtitle.copyWith(fontSize: 18))),
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.moreVertical, size: 20, color: Color(0xFF334155)),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      // Quick Actions
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(LucideIcons.phone, size: 14, color: Color(0xFF475569)),
                                label: Text('Contact Rider', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF475569))),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  backgroundColor: Colors.white,
                                  minimumSize: const Size(0, 36),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(LucideIcons.fileText, size: 14, color: Color(0xFF475569)),
                                label: Text('Print Order', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF475569))),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  backgroundColor: Colors.white,
                                  minimumSize: const Size(0, 36),
                                ),
                              ),
                            ),
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
                  padding: const EdgeInsets.only(bottom: 160),
                  child: Column(
                    children: [
                      // Countdown Banner
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('NEW INCOMING ORDER', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF92400E), letterSpacing: 1)),
                                  const SizedBox(height: 2),
                                  Text('Accept within', style: AppTextStyles.subtitle.copyWith(color: const Color(0xFF78350F))),
                                ],
                              ),
                              Row(
                                children: [
                                  _timerChip(_pad(mins)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(':', style: AppTextStyles.heading2.copyWith(color: const Color(0xFF92400E))),
                                  ),
                                  _timerChip(_pad(secs)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Customer Info
                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CUSTOMER INFO', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8))),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  width: 56, height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF1463FF).withOpacity(0.15), width: 2),
                                    gradient: const LinearGradient(colors: [Color(0xFF6C56F9), Color(0xFF1463FF)]),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(LucideIcons.user, size: 22, color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Kofi Mensah', style: AppTextStyles.subtitle),
                                      Row(
                                        children: [
                                          ...List.generate(5, (i) => const Icon(LucideIcons.star, size: 11, color: Color(0xFFF59E0B))),
                                          const SizedBox(width: 4),
                                          Text('4.8', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    _iconCircle(LucideIcons.phone),
                                    const SizedBox(width: 8),
                                    _iconCircle(LucideIcons.messageSquare),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _pill('Prepaid', const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
                                const SizedBox(width: 8),
                                _pill('Menu Order', const Color(0xFF1463FF).withOpacity(0.1), const Color(0xFF1463FF)),
                                const SizedBox(width: 8),
                                _pill('2.4 km', const Color(0xFFF1F5F9), const Color(0xFF475569)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Order Items
                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ORDER DISHES', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8))),
                            const Divider(height: 20),
                            _orderItem('1× Jollof Rice with Chicken', '+ Spicy Shito Sauce\n+ Extra Fried Plantain', 'GHS 45.00'),
                            const Divider(height: 16),
                            _orderItem('2× Coca Cola 500ml', 'Chilled', 'GHS 12.00'),
                          ],
                        ),
                      ),

                      // Customer Note
                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CUSTOMER NOTE', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8))),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.only(left: 12),
                              decoration: const BoxDecoration(
                                border: Border(left: BorderSide(color: Color(0xFF1463FF), width: 4)),
                              ),
                              child: Text(
                                '"Please add extra pepper and make sure the chicken is well-done."',
                                style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF334155), height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Summary
                      _card(
                        child: Column(
                          children: [
                            _summaryRow('Subtotal', 'GHS 57.00'),
                            const SizedBox(height: 10),
                            _summaryRow('Delivery Fee', 'GHS 12.50'),
                            const SizedBox(height: 10),
                            _summaryRow('Tax & Fees', 'GHS 4.25'),
                            const Divider(height: 24),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1463FF).withOpacity(0.04),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('YOUR EARNINGS', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8), fontSize: 10)),
                                      Text('GHS 63.75', style: AppTextStyles.heading2.copyWith(fontSize: 20, color: const Color(0xFF1463FF))),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('TOTAL PAID', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8), fontSize: 10)),
                                      Text('GHS 73.75', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
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
              ),
            ],
          ),

          // Bottom Actions
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(height: 1, color: const Color(0xFFE8E4E4)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: const Text('Accept Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _handleDecline,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text('Decline', style: AppTextStyles.subtitle.copyWith(color: const Color(0xFF334155))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Toast
          if (_toast != null)
            Positioned(
              bottom: 120, left: 32, right: 32,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(_toast!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E4E4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
      ),
      child: child,
    );
  }

  Widget _timerChip(String value) {
    return Container(
      width: 48, height: 40,
      decoration: BoxDecoration(color: const Color(0xFFFBBF24), borderRadius: BorderRadius.circular(8)),
      alignment: Alignment.center,
      child: Text(value, style: const TextStyle(color: Color(0xFF78350F), fontWeight: FontWeight.bold, fontSize: 20)),
    );
  }

  Widget _iconCircle(IconData icon) {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(color: const Color(0xFF1463FF).withOpacity(0.1), shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Icon(icon, size: 16, color: const Color(0xFF1463FF)),
    );
  }

  Widget _pill(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: AppTextStyles.captionBold.copyWith(color: textColor, fontSize: 11)),
    );
  }

  Widget _orderItem(String name, String mods, String price) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.subtitle),
              ...mods.split('\n').map((m) => Text(m, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary))),
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
