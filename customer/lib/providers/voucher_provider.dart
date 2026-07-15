import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/voucher.dart';

/// Available vouchers, browsable from the Vouchers screen and applicable at
/// checkout. Previously checkout's promo field only accepted two codes that
/// were hardcoded in `checkout_screen.dart` with nowhere for a user to
/// discover them; this is now the single source of truth for both.
class VoucherNotifier extends Notifier<List<Voucher>> {
  @override
  List<Voucher> build() => const [
        Voucher(
          code: 'YEN10',
          title: '10% off your order',
          description: 'Get 10% off the subtotal of any order.',
          discountRate: 0.10,
          expiryLabel: 'Expires in 14 days',
        ),
        Voucher(
          code: 'WELCOME15',
          title: 'Welcome bonus — 15% off',
          description: 'New to swiftree? Enjoy 15% off your order subtotal.',
          discountRate: 0.15,
          minSpend: 20,
          expiryLabel: 'Expires in 30 days',
        ),
        Voucher(
          code: 'FREESHIP',
          title: 'Free delivery',
          description: '₵5 off your delivery fee on orders over ₵30.',
          flatDiscount: 5,
          minSpend: 30,
          expiryLabel: 'Expires in 7 days',
        ),
      ];

  Voucher? byCode(String code) {
    final upper = code.trim().toUpperCase();
    for (final v in state) {
      if (v.code == upper) return v;
    }
    return null;
  }

  void markRedeemed(String code) {
    state = [
      for (final v in state)
        if (v.code == code)
          Voucher(
            code: v.code,
            title: v.title,
            description: v.description,
            discountRate: v.discountRate,
            flatDiscount: v.flatDiscount,
            minSpend: v.minSpend,
            expiryLabel: v.expiryLabel,
            isRedeemed: true,
          )
        else
          v,
    ];
  }
}

final voucherProvider = NotifierProvider<VoucherNotifier, List<Voucher>>(VoucherNotifier.new);
