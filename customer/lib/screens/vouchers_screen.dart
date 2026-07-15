import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import '../models/voucher.dart';
import '../providers/voucher_provider.dart';

const Color _primary = Color(0xFF0068FF);
const Color _dark = Color(0xFF0F172A);
const Color _mid = Color(0xFF64748B);
const Color _border = Color(0xFFE8EDF2);

/// Browsable list of available vouchers/promo codes. Previously the only
/// way to use a promo code was to already know it and type it into
/// checkout's "Enter promo code" field — there was nowhere to discover one.
class VouchersScreen extends ConsumerWidget {
  const VouchersScreen({super.key});

  void _copyCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code "$code" copied — paste it at checkout', style: AppFonts.inter(color: Colors.white)),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vouchers = ref.watch(voucherProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Vouchers', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: _border, height: 1)),
      ),
      body: vouchers.isEmpty
          ? Center(child: Text('No vouchers available right now', style: AppFonts.inter(fontSize: 14, color: _mid)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vouchers.length,
              itemBuilder: (context, i) => _voucherCard(context, vouchers[i]),
            ),
    );
  }

  Widget _voucherCard(BuildContext context, Voucher v) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0068FF), Color(0xFF0052CC)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.local_offer_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(v.title, style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: _dark))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(10)),
                        child: Text(v.discountLabel, style: AppFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFFEA580C))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(v.description, style: AppFonts.inter(fontSize: 12, color: _mid, height: 1.4)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _border),
                          ),
                          child: Text(v.code, style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: _dark, letterSpacing: 1)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => _copyCode(context, v.code),
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10)),
                        child: Text('Copy', style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: _primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(v.expiryLabel, style: AppFonts.inter(fontSize: 11, color: _mid)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
