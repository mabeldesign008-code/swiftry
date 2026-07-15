/// Business type model matching BUSINESS_TYPES from React app
class BusinessType {
  final String id;
  final String label;
  final String sub;

  const BusinessType({
    required this.id,
    required this.label,
    required this.sub,
  });

  /// All available business types - matching React BUSINESS_TYPES array exactly
  static const List<BusinessType> all = [
    BusinessType(
      id: 'restaurant',
      label: 'Restaurant / Food',
      sub: 'Restaurants, chop bars, fast food, home kitchens',
    ),
    BusinessType(
      id: 'groceries',
      label: 'Groceries',
      sub: 'Supermarkets, mini-marts, provision stores',
    ),
    BusinessType(
      id: 'market',
      label: 'Market Vendor',
      sub: 'Fresh produce, bulk goods, market stalls',
    ),
    BusinessType(
      id: 'pharmacy',
      label: 'Pharmacy',
      sub: 'Licensed pharmacies, health stores',
    ),
    BusinessType(
      id: 'retail',
      label: 'Shop / Retail',
      sub: 'Electronics, fashion, beauty, general retail',
    ),
    BusinessType(
      id: 'laundry',
      label: 'Laundry Services',
      sub: 'Laundry, dry cleaning, wash & fold',
    ),
  ];

  /// Get business type by ID
  static BusinessType? getById(String id) {
    try {
      return all.firstWhere((bt) => bt.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get business type label by ID
  static String getLabel(String id) {
    return getById(id)?.label ?? 'Unknown';
  }
}
