import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Single source of truth for the "swiftree Wallet" balance.
///
/// Previously the checkout screen and the wallet screen each hardcoded their
/// own, different, fake balance (₵150.00 vs ₵125.00) and neither ever
/// validated or deducted anything — a wallet payment would "succeed" no
/// matter the balance. This notifier fixes both problems.
class WalletNotifier extends Notifier<double> {
  @override
  double build() => 150.00;

  bool hasSufficientBalance(double amount) => state >= amount;

  void deduct(double amount) {
    state = (state - amount).clamp(0, double.infinity);
  }

  void topUp(double amount) {
    state = state + amount;
  }
}

final walletProvider = NotifierProvider<WalletNotifier, double>(WalletNotifier.new);
