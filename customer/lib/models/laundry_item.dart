/// A single laundry item with real price and service metadata.
class LaundryItem {
  final String name;
  final double price;
  final String serviceType; // 'Wash & Iron', 'Dry Clean', 'Wash & Fold', etc.
  final String category;    // 'Tops', 'Suits', 'Bedding', etc.

  const LaundryItem({
    required this.name,
    required this.price,
    this.serviceType = 'Wash & Iron',
    this.category = '',
  });

  LaundryItem copyWith({String? serviceType, double? price}) {
    return LaundryItem(
      name: name,
      price: price ?? this.price,
      serviceType: serviceType ?? this.serviceType,
      category: category,
    );
  }

  double get lineTotal => price;

  /// Human-friendly price string.
  String get priceLabel => '₵${price.toStringAsFixed(2)}';
}
