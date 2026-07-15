import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/review.dart';
import '../providers/reviews_provider.dart';
import '../providers/wallet_provider.dart';

class RateReviewScreen extends ConsumerStatefulWidget {
  final String storeName;
  final String orderId;
  final IconData storeIcon;

  const RateReviewScreen({
    super.key,
    this.storeName = 'Your Order',
    this.orderId = '',
    this.storeIcon = Icons.store_rounded,
  });

  @override
  ConsumerState<RateReviewScreen> createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends ConsumerState<RateReviewScreen> {
  double _foodRating = 0;
  double _riderRating = 0;
  final Set<String> _selectedTags = {};
  final TextEditingController _reviewCtrl = TextEditingController();
  bool _isSubmitting = false;

  // Tip the rider — previously there was no way to tip at all.
  double _tipAmount = 0;
  final TextEditingController _customTipCtrl = TextEditingController();
  final List<double> _tipOptions = const [0, 2, 5, 10];

  final List<String> _tags = [
    'Great Food',
    'Fast Delivery',
    'Good Packaging',
    'Friendly Rider',
    'Hot & Fresh',
    'Would Recommend',
    'Accurate Order',
    'Good Portions',
  ];

  @override
  void dispose() {
    _reviewCtrl.dispose();
    _customTipCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit => _foodRating > 0 && _riderRating > 0;

  Future<void> _onSubmit() async {
    if (!_canSubmit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please rate both the food and the rider.',
            style: AppFonts.inter(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: const Color(0xFFE11D48),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final customTip = double.tryParse(_customTipCtrl.text.trim());
    final tip = customTip != null && customTip > 0 ? customTip : _tipAmount;

    if (tip > 0) {
      final balance = ref.read(walletProvider);
      if (balance < tip) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Insufficient wallet balance to tip ₵${tip.toStringAsFixed(2)}.',
              style: AppFonts.inter(color: Colors.white, fontSize: 14),
            ),
            backgroundColor: const Color(0xFFE11D48),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (tip > 0) {
      ref.read(walletProvider.notifier).deduct(tip);
    }
    ref.read(reviewsProvider.notifier).addReview(
      Review(
        id: 'rev-${DateTime.now().millisecondsSinceEpoch}',
        orderId: widget.orderId,
        vendorName: widget.storeName,
        foodRating: _foodRating,
        riderRating: _riderRating,
        tags: _selectedTags,
        comment: _reviewCtrl.text.trim(),
        tip: tip,
        createdAt: DateTime.now(),
      ),
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              tip > 0
                  ? 'Thanks for your review and ₵${tip.toStringAsFixed(2)} tip! 🎉'
                  : 'Thank you for your review! 🎉',
              style: AppFonts.inter(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rate Your Order',
          style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE2E8F0), height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Order info card ─────────────────────────────────────
            _card(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.storeIcon, color: const Color(0xFF0068FF), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.storeName,
                          style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                        ),
                        if (widget.orderId.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            widget.orderId,
                            style: AppFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Food rating ─────────────────────────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppTheme.secondaryLight, borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.restaurant_rounded, color: AppTheme.secondaryDark, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Rate the food',
                        style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RatingBar.builder(
                      initialRating: _foodRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 44,
                      glow: false,
                      itemBuilder: (context, _) => Icon(
                        Icons.star_rounded,
                        color: AppTheme.star,
                      ),
                      onRatingUpdate: (rating) => setState(() => _foodRating = rating),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      _foodRating == 0
                          ? 'Tap to rate'
                          : _ratingLabel(_foodRating),
                      style: AppFonts.inter(
                        fontSize: 14,
                        color: _foodRating == 0 ? const Color(0xFF94A3B8) : const Color(0xFF0068FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Rider rating ────────────────────────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.delivery_dining_rounded, color: Color(0xFF0068FF), size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Rate the delivery',
                        style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RatingBar.builder(
                      initialRating: _riderRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 44,
                      glow: false,
                      itemBuilder: (context, _) => Icon(
                        Icons.star_rounded,
                        color: AppTheme.star,
                      ),
                      onRatingUpdate: (rating) => setState(() => _riderRating = rating),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      _riderRating == 0
                          ? 'Tap to rate'
                          : _ratingLabel(_riderRating),
                      style: AppFonts.inter(
                        fontSize: 14,
                        color: _riderRating == 0 ? const Color(0xFF94A3B8) : const Color(0xFF0068FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Tip your rider ───────────────────────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.volunteer_activism_rounded, color: Color(0xFF16A34A), size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Tip your rider',
                        style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '100% goes to your rider',
                    style: AppFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _tipOptions.map((amount) {
                      final selected = _tipAmount == amount && _customTipCtrl.text.trim().isEmpty;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _tipAmount = amount;
                          _customTipCtrl.clear();
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFF16A34A) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: selected ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0), width: selected ? 0 : 1.5),
                          ),
                          child: Text(
                            amount == 0 ? 'No tip' : '₵${amount.toStringAsFixed(0)}',
                            style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : const Color(0xFF475569)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _customTipCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Custom amount',
                      prefixText: '₵ ',
                      hintStyle: AppFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF16A34A), width: 1.5)),
                    ),
                    style: AppFonts.inter(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Quick tags ──────────────────────────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What did you love?',
                    style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Optional — select all that apply',
                    style: AppFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _tags.map((tag) {
                      final selected = _selectedTags.contains(tag);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (selected) {
                            _selectedTags.remove(tag);
                          } else {
                            _selectedTags.add(tag);
                          }
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFF0068FF) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected ? const Color(0xFF0068FF) : const Color(0xFFE2E8F0),
                              width: selected ? 0 : 1.5,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: AppFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: selected ? Colors.white : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Write a review ──────────────────────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leave a comment',
                    style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Optional — your feedback helps us improve',
                    style: AppFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _reviewCtrl,
                    maxLines: 4,
                    maxLength: 300,
                    style: AppFonts.inter(fontSize: 14, color: const Color(0xFF0F172A)),
                    decoration: InputDecoration(
                      hintText: 'E.g. The jollof was perfect, delivery was super quick...',
                      hintStyle: AppFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF0068FF), width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Submit button ───────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0068FF),
                  disabledBackgroundColor: const Color(0xFF0068FF).withValues(alpha: 0.5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : Text(
                        'Submit Review',
                        style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: child,
    );
  }

  String _ratingLabel(double rating) {
    if (rating >= 5) return 'Excellent! 🌟';
    if (rating >= 4) return 'Really Good 😊';
    if (rating >= 3) return 'It was okay 😐';
    if (rating >= 2) return 'Not great 😕';
    return 'Very Poor 😞';
  }
}
