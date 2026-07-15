/// A promotional voucher/discount code that can be browsed in the Vouchers
/// screen and applied at checkout. `discountRate` is a fraction of subtotal
/// (e.g. 0.10 == 10% off); `flatDiscount` is a flat cedi amount taken instead
/// when set (used for delivery-fee-off style vouchers).
class Voucher {
  final String code;
  final String title;
  final String description;
  final double discountRate;
  final double flatDiscount;
  final double minSpend;
  final String expiryLabel;
  final bool isRedeemed;

  const Voucher({
    required this.code,
    required this.title,
    required this.description,
    this.discountRate = 0,
    this.flatDiscount = 0,
    this.minSpend = 0,
    required this.expiryLabel,
    this.isRedeemed = false,
  });

  String get discountLabel {
    if (discountRate > 0) return '${(discountRate * 100).toStringAsFixed(0)}% OFF';
    if (flatDiscount > 0) return '₵${flatDiscount.toStringAsFixed(0)} OFF';
    return 'DEAL';
  }

  double discountFor(double subtotal) {
    if (subtotal < minSpend) return 0;
    if (discountRate > 0) return subtotal * discountRate;
    return flatDiscount;
  }
}
