import 'package:flutter/material.dart';

enum PaymentMethodType { mobileMoney, card, cash, wallet }

/// A saved payment method (mobile money number or bank card).
/// `cash` and `wallet` are implicit/system methods and aren't stored here —
/// this list only holds methods the user has explicitly added.
class PaymentMethod {
  final String id;
  final PaymentMethodType type;
  final String label; // e.g. "MTN Mobile Money" or "Visa •••• 4242"
  final String detail; // e.g. "024 XXX XXXX" or "Expires 08/28"
  final String network; // e.g. "MTN", "Vodafone", "AirtelTigo", "Visa", "Mastercard"
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.label,
    required this.detail,
    required this.network,
    this.isDefault = false,
  });

  PaymentMethod copyWith({bool? isDefault}) {
    return PaymentMethod(
      id: id,
      type: type,
      label: label,
      detail: detail,
      network: network,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  IconData get icon {
    switch (type) {
      case PaymentMethodType.mobileMoney:
        return Icons.phone_android_rounded;
      case PaymentMethodType.card:
        return Icons.credit_card_rounded;
      case PaymentMethodType.cash:
        return Icons.money_rounded;
      case PaymentMethodType.wallet:
        return Icons.account_balance_wallet_rounded;
    }
  }

  LinearGradient get gradient {
    switch (network.toLowerCase()) {
      case 'mtn':
        return const LinearGradient(colors: [Color(0xFFFFCC00), Color(0xFFFF8C00)]);
      case 'vodafone':
        return const LinearGradient(colors: [Color(0xFFE60000), Color(0xFF9E0000)]);
      case 'airteltigo':
        return const LinearGradient(colors: [Color(0xFF0068FF), Color(0xFF001A99)]);
      case 'visa':
        return const LinearGradient(colors: [Color(0xFF1A1F71), Color(0xFF0068FF)]);
      case 'mastercard':
        return const LinearGradient(colors: [Color(0xFFEB001B), Color(0xFFF79E1B)]);
      default:
        return const LinearGradient(colors: [Color(0xFF64748B), Color(0xFF334155)]);
    }
  }
}
