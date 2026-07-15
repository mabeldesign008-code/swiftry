import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_method.dart';

/// Saved payment methods (MoMo numbers / cards). This is what the Profile →
/// "Payment Methods" screen and the checkout payment-method list both read
/// from — previously "Payment Methods" in Profile just opened the wallet
/// screen, and checkout's MTN option was a hardcoded, permanent placeholder.
class PaymentMethodsNotifier extends Notifier<List<PaymentMethod>> {
  @override
  List<PaymentMethod> build() => [
        const PaymentMethod(
          id: 'momo-default',
          type: PaymentMethodType.mobileMoney,
          label: 'MTN Mobile Money',
          detail: '024 XXX XXXX',
          network: 'MTN',
          isDefault: true,
        ),
      ];

  void add(PaymentMethod method) {
    if (method.isDefault) {
      state = [
        for (final m in state) m.copyWith(isDefault: false),
        method,
      ];
    } else {
      state = [...state, method];
    }
  }

  void remove(String id) {
    state = state.where((m) => m.id != id).toList();
  }

  void setDefault(String id) {
    state = [
      for (final m in state) m.copyWith(isDefault: m.id == id),
    ];
  }

  PaymentMethod? get defaultMethod {
    for (final m in state) {
      if (m.isDefault) return m;
    }
    return state.isEmpty ? null : state.first;
  }
}

final paymentMethodsProvider =
    NotifierProvider<PaymentMethodsNotifier, List<PaymentMethod>>(PaymentMethodsNotifier.new);
