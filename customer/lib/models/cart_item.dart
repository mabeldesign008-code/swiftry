/// A single item in the food / shop cart.
class CartItem {
  final String title;
  final String description;
  final double price;
  final int quantity;
  final String? imageUrl;
  final String? restaurantId;
  final String? specialInstructions;

  // Vendor tracking — used for one-vendor-per-cart enforcement.
  final String? vendorId;
  final String? vendorName;

  // Structured addon and variant selections.
  // e.g. selectedAddons: [{'name': 'Grilled Chicken', 'price': 15.0}]
  // e.g. selectedVariants: [{'group': 'Color', 'option': 'Black', 'priceAdjustment': 0.0}]
  final List<Map<String, dynamic>> selectedAddons;
  final List<Map<String, dynamic>> selectedVariants;

  const CartItem({
    required this.title,
    required this.description,
    required this.price,
    this.quantity = 1,
    this.imageUrl,
    this.restaurantId,
    this.specialInstructions,
    this.vendorId,
    this.vendorName,
    this.selectedAddons = const [],
    this.selectedVariants = const [],
  });

  CartItem copyWith({
    int? quantity,
    double? price,
    String? description,
    String? imageUrl,
    String? specialInstructions,
    String? vendorId,
    String? vendorName,
    List<Map<String, dynamic>>? selectedAddons,
    List<Map<String, dynamic>>? selectedVariants,
  }) {
    return CartItem(
      title: title,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      restaurantId: restaurantId,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      selectedVariants: selectedVariants ?? this.selectedVariants,
    );
  }

  double get addonsTotal =>
      selectedAddons.fold(0.0, (sum, a) => sum + (a['price'] as num).toDouble());

  double get variantsTotal => selectedVariants.fold(
        0.0,
        (sum, v) => sum + ((v['priceAdjustment'] as num?)?.toDouble() ?? 0.0),
      );

  double get unitPrice => price + addonsTotal + variantsTotal;


  /// Stable identity for this exact product + customization combination.
  ///
  /// Two items with the same [customizationKey] represent the *same* cart
  /// line and should have their quantities merged. Items that differ in
  /// vendor, addons, variants, or special instructions are distinct lines
  /// even if they share a [title] — previously `FoodCartNotifier.addItem`
  /// merged purely on title+restaurantId, which silently discarded the
  /// addons/variants/instructions of whichever add came second.
  String get customizationKey {
    final addons = selectedAddons
        .map((a) => '${a['group'] ?? ''}:${a['name'] ?? ''}:${a['price'] ?? 0}')
        .toList()
      ..sort();
    final variants = selectedVariants
        .map((v) => '${v['group'] ?? ''}:${v['option'] ?? ''}:${v['priceAdjustment'] ?? 0}')
        .toList()
      ..sort();
    return [
      vendorId ?? restaurantId ?? '',
      title,
      addons.join('|'),
      variants.join('|'),
      specialInstructions ?? '',
    ].join('::');
  }

  double get lineTotal => unitPrice * quantity;
}
