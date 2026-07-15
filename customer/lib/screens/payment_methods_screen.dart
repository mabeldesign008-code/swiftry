import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import '../models/payment_method.dart';
import '../providers/payment_methods_provider.dart';
import '../widgets/add_payment_method_modal.dart';

const Color _primary = Color(0xFF0068FF);
const Color _dark = Color(0xFF0F172A);
const Color _mid = Color(0xFF64748B);
const Color _border = Color(0xFFE8EDF2);

/// Manage saved MoMo numbers / cards. Previously Profile's "Payment
/// Methods" menu item opened the wallet screen instead of anything that let
/// you actually add/remove a payment method.
class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  void _addMethod(BuildContext context, WidgetRef ref) async {
    final method = await showModalBottomSheet<PaymentMethod>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddPaymentMethodModal(),
    );
    if (method != null) {
      ref.read(paymentMethodsProvider.notifier).add(method);
    }
  }

  void _confirmRemove(BuildContext context, WidgetRef ref, PaymentMethod method) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Remove ${method.label}?', style: AppFonts.inter(fontWeight: FontWeight.w700, fontSize: 17)),
        content: Text('You can add it again anytime.', style: AppFonts.inter(fontSize: 14, color: _mid)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppFonts.inter(fontWeight: FontWeight.w600, color: _mid)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(paymentMethodsProvider.notifier).remove(method.id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Remove', style: AppFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.watch(paymentMethodsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Payment Methods', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: _border, height: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        children: [
          // System methods — always available, not user-removable.
          _staticCard(
            icon: Icons.account_balance_wallet_rounded,
            gradient: LinearGradient(colors: [_primary, _primary.withOpacity(0.7)]),
            label: 'swiftree Wallet',
            sub: 'Always available',
          ),
          const SizedBox(height: 10),
          _staticCard(
            icon: Icons.money_rounded,
            gradient: const LinearGradient(colors: [Color(0xFF22C55E), Color(0xFF16A34A)]),
            label: 'Cash on Delivery',
            sub: 'Pay the rider in cash',
          ),
          const SizedBox(height: 20),
          Text('SAVED METHODS', style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: _mid, letterSpacing: 0.8)),
          const SizedBox(height: 10),
          if (methods.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No saved payment methods yet', style: AppFonts.inter(fontSize: 14, color: _mid)),
              ),
            )
          else
            ...methods.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _methodCard(context, ref, m),
                )),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _addMethod(context, ref),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text('Add payment method', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
            style: OutlinedButton.styleFrom(
              foregroundColor: _primary,
              side: const BorderSide(color: _primary),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              minimumSize: const Size(double.infinity, 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _staticCard({required IconData icon, required LinearGradient gradient, required String label, required String sub}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: _dark)),
                const SizedBox(height: 2),
                Text(sub, style: AppFonts.inter(fontSize: 12, color: _mid)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _methodCard(BuildContext context, WidgetRef ref, PaymentMethod method) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: method.isDefault ? _primary : _border, width: method.isDefault ? 1.5 : 1),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(gradient: method.gradient, borderRadius: BorderRadius.circular(13)),
            child: Icon(method.icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(method.label, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: _dark)),
                    if (method.isDefault) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: _primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: Text('Default', style: AppFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _primary)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(method.detail, style: AppFonts.inter(fontSize: 12, color: _mid)),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: _mid),
            onSelected: (value) {
              if (value == 'default') {
                ref.read(paymentMethodsProvider.notifier).setDefault(method.id);
              } else if (value == 'remove') {
                _confirmRemove(context, ref, method);
              }
            },
            itemBuilder: (ctx) => [
              if (!method.isDefault)
                PopupMenuItem(value: 'default', child: Text('Set as default', style: AppFonts.inter(fontSize: 13))),
              PopupMenuItem(value: 'remove', child: Text('Remove', style: AppFonts.inter(fontSize: 13, color: const Color(0xFFEF4444)))),
            ],
          ),
        ],
      ),
    );
  }
}
