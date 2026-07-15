class OrderStage {
  final String id;
  final String label;

  const OrderStage({required this.id, required this.label});
}

class VendorConfig {
  final String id;
  final String label;
  final String icon;
  final String catalogLabel;
  final String itemLabel;
  final String itemLabelPlural;
  final List<String> categories;
  final List<Map<String, dynamic>> defaultCategories;
  final List<OrderStage> orderStages;
  final List<String> pricingTypes;
  final Map<String, bool> fields;
  final String prepTimeLabel;
  final List<String> prepTimeOptions;
  final String analyticsItemLabel;
  final String analyticsTopLabel;
  final String searchPlaceholder;
  final bool hasRxFlow;
  final bool hasPickingFlow;
  final bool hasConditionLog;
  final bool hasDailyPricing;

  const VendorConfig({
    required this.id,
    required this.label,
    required this.icon,
    required this.catalogLabel,
    required this.itemLabel,
    required this.itemLabelPlural,
    required this.categories,
    required this.defaultCategories,
    required this.orderStages,
    required this.pricingTypes,
    required this.fields,
    required this.prepTimeLabel,
    required this.prepTimeOptions,
    required this.analyticsItemLabel,
    required this.analyticsTopLabel,
    required this.searchPlaceholder,
    required this.hasRxFlow,
    required this.hasPickingFlow,
    required this.hasConditionLog,
    required this.hasDailyPricing,
  });
}

const Map<String, VendorConfig> vendorConfigs = {
  'restaurant': VendorConfig(
    id: 'restaurant',
    label: 'Restaurant',
    icon: 'utensils',
    catalogLabel: 'Menu',
    itemLabel: 'Dish',
    itemLabelPlural: 'Dishes',
    categories: ['All', 'Starters', 'Mains', 'Desserts', 'Drinks', 'Specials'],
    defaultCategories: [
      {'name': 'Starters', 'items': 4},
      {'name': 'Mains', 'items': 12},
      {'name': 'Drinks', 'items': 8},
      {'name': 'Specials', 'items': 2},
    ],
    orderStages: [
      OrderStage(id: 'new', label: 'New'),
      OrderStage(id: 'preparing', label: 'Preparing'),
      OrderStage(id: 'ready', label: 'Ready'),
      OrderStage(id: 'completed', label: 'Completed'),
    ],
    pricingTypes: ['Standard', 'Variable (Sizes)'],
    fields: {
      'prepTime': true, 'turnaround': false, 'rxRequired': false, 'weightUnit': false,
      'variants': true, 'expiryDate': false, 'dailyPrice': false, 'garmentType': false,
      'dietary': true, 'sku': false, 'stockQty': true,
    },
    prepTimeLabel: 'Preparation Time',
    prepTimeOptions: ['5-10 mins', '15-20 mins', '30-45 mins', '60+ mins'],
    analyticsItemLabel: 'Dishes Sold',
    analyticsTopLabel: 'Top Dishes',
    searchPlaceholder: 'Search menu...',
    hasRxFlow: false, hasPickingFlow: false, hasConditionLog: false, hasDailyPricing: false,
  ),
  'groceries': VendorConfig(
    id: 'groceries',
    label: 'Groceries',
    icon: 'shopping-cart',
    catalogLabel: 'Inventory',
    itemLabel: 'Product',
    itemLabelPlural: 'Products',
    categories: ['All', 'Produce', 'Dairy', 'Meat', 'Pantry', 'Beverages', 'Snacks'],
    defaultCategories: [
      {'name': 'Produce', 'items': 45},
      {'name': 'Dairy', 'items': 24},
      {'name': 'Pantry', 'items': 112},
      {'name': 'Beverages', 'items': 38},
    ],
    orderStages: [
      OrderStage(id: 'new', label: 'New'),
      OrderStage(id: 'picking', label: 'Picking'),
      OrderStage(id: 'packed', label: 'Packed'),
      OrderStage(id: 'completed', label: 'Completed'),
    ],
    pricingTypes: ['Standard', 'By Weight'],
    fields: {
      'prepTime': false, 'turnaround': false, 'rxRequired': false, 'weightUnit': true,
      'variants': true, 'expiryDate': true, 'dailyPrice': false, 'garmentType': false,
      'dietary': true, 'sku': true, 'stockQty': true,
    },
    prepTimeLabel: 'Fulfillment Time',
    prepTimeOptions: ['Immediate', 'Same Day', 'Next Day'],
    analyticsItemLabel: 'Items Sold',
    analyticsTopLabel: 'Top Products',
    searchPlaceholder: 'Search inventory...',
    hasRxFlow: false, hasPickingFlow: true, hasConditionLog: false, hasDailyPricing: false,
  ),
  'market': VendorConfig(
    id: 'market',
    label: 'Market Vendor',
    icon: 'store',
    catalogLabel: 'Stall Items',
    itemLabel: 'Item',
    itemLabelPlural: 'Items',
    categories: ['All', 'Vegetables', 'Fruits', 'Grains', 'Spices', 'Tubers'],
    defaultCategories: [
      {'name': 'Vegetables', 'items': 18},
      {'name': 'Tubers', 'items': 5},
      {'name': 'Spices', 'items': 22},
    ],
    orderStages: [
      OrderStage(id: 'new', label: 'New'),
      OrderStage(id: 'weighing', label: 'Weighing/Packing'),
      OrderStage(id: 'ready', label: 'Ready'),
      OrderStage(id: 'completed', label: 'Completed'),
    ],
    pricingTypes: ['Per Item', 'Per Kg/Olonka', 'Daily Market Rate'],
    fields: {
      'prepTime': false, 'turnaround': false, 'rxRequired': false, 'weightUnit': true,
      'variants': false, 'expiryDate': false, 'dailyPrice': true, 'garmentType': false,
      'dietary': false, 'sku': false, 'stockQty': false,
    },
    prepTimeLabel: 'Packing Time',
    prepTimeOptions: ['15 mins', '30 mins', '1 hour'],
    analyticsItemLabel: 'Items Sold',
    analyticsTopLabel: 'Best Sellers',
    searchPlaceholder: 'Search stall...',
    hasRxFlow: false, hasPickingFlow: true, hasConditionLog: false, hasDailyPricing: true,
  ),
  'pharmacy': VendorConfig(
    id: 'pharmacy',
    label: 'Pharmacy',
    icon: 'pill',
    catalogLabel: 'Medicines',
    itemLabel: 'Medicine',
    itemLabelPlural: 'Medicines',
    categories: ['All', 'OTC', 'Prescription', 'Vitamins', 'First Aid', 'Personal Care'],
    defaultCategories: [
      {'name': 'OTC', 'items': 85},
      {'name': 'Prescription', 'items': 142},
      {'name': 'Vitamins', 'items': 34},
    ],
    orderStages: [
      OrderStage(id: 'new', label: 'New'),
      OrderStage(id: 'rx-check', label: 'Rx Check'),
      OrderStage(id: 'approved', label: 'Approved'),
      OrderStage(id: 'completed', label: 'Completed'),
    ],
    pricingTypes: ['Standard'],
    fields: {
      'prepTime': false, 'turnaround': false, 'rxRequired': true, 'weightUnit': false,
      'variants': true, 'expiryDate': true, 'dailyPrice': false, 'garmentType': false,
      'dietary': false, 'sku': true, 'stockQty': true,
    },
    prepTimeLabel: 'Dispensing Time',
    prepTimeOptions: ['Immediate', '10 mins', '30 mins'],
    analyticsItemLabel: 'Units Dispensed',
    analyticsTopLabel: 'Top Medicines',
    searchPlaceholder: 'Search medicines...',
    hasRxFlow: true, hasPickingFlow: true, hasConditionLog: false, hasDailyPricing: false,
  ),
  'retail': VendorConfig(
    id: 'retail',
    label: 'Retail',
    icon: 'shopping-bag',
    catalogLabel: 'Products',
    itemLabel: 'Product',
    itemLabelPlural: 'Products',
    categories: ['All', 'Electronics', 'Clothing', 'Home', 'Beauty', 'Accessories'],
    defaultCategories: [
      {'name': 'Electronics', 'items': 45},
      {'name': 'Accessories', 'items': 120},
    ],
    orderStages: [
      OrderStage(id: 'new', label: 'New'),
      OrderStage(id: 'packing', label: 'Packing'),
      OrderStage(id: 'ready', label: 'Ready for Dispatch'),
      OrderStage(id: 'completed', label: 'Completed'),
    ],
    pricingTypes: ['Standard', 'Variable (Color/Size)'],
    fields: {
      'prepTime': false, 'turnaround': false, 'rxRequired': false, 'weightUnit': false,
      'variants': true, 'expiryDate': false, 'dailyPrice': false, 'garmentType': false,
      'dietary': false, 'sku': true, 'stockQty': true,
    },
    prepTimeLabel: 'Packing Time',
    prepTimeOptions: ['Same Day', '1-2 Days', '3-5 Days'],
    analyticsItemLabel: 'Items Sold',
    analyticsTopLabel: 'Top Products',
    searchPlaceholder: 'Search products...',
    hasRxFlow: false, hasPickingFlow: true, hasConditionLog: false, hasDailyPricing: false,
  ),
  'laundry': VendorConfig(
    id: 'laundry',
    label: 'Laundry & Dry Cleaning',
    icon: 'shirt',
    catalogLabel: 'Services',
    itemLabel: 'Service',
    itemLabelPlural: 'Services',
    categories: ['All', 'Wash & Fold', 'Dry Cleaning', 'Ironing', 'Express', 'Stain Treatment'],
    defaultCategories: [
      {'name': 'Wash & Fold', 'items': 3},
      {'name': 'Dry Cleaning', 'items': 8},
      {'name': 'Ironing', 'items': 2},
      {'name': 'Express', 'items': 4},
    ],
    orderStages: [
      OrderStage(id: 'collected', label: 'Collected'),
      OrderStage(id: 'sorting', label: 'Sorting'),
      OrderStage(id: 'washing', label: 'Washing'),
      OrderStage(id: 'drying', label: 'Drying'),
      OrderStage(id: 'qc', label: 'QC Check'),
      OrderStage(id: 'completed', label: 'Completed'),
    ],
    pricingTypes: ['Per Kg', 'Per Piece', 'Per Garment Type'],
    fields: {
      'prepTime': false, 'turnaround': true, 'rxRequired': false, 'weightUnit': false,
      'variants': false, 'expiryDate': false, 'dailyPrice': false, 'garmentType': true,
      'dietary': false, 'sku': false, 'stockQty': false,
    },
    prepTimeLabel: 'Turnaround Time',
    prepTimeOptions: ['Express (24h)', 'Standard (3 days)', 'Extended (5 days)'],
    analyticsItemLabel: 'Orders Processed',
    analyticsTopLabel: 'Popular Services',
    searchPlaceholder: 'Search services...',
    hasRxFlow: false, hasPickingFlow: false, hasConditionLog: true, hasDailyPricing: false,
  ),
};

VendorConfig getVendorConfig([String vendorType = 'restaurant']) {
  return vendorConfigs[vendorType] ?? vendorConfigs['restaurant']!;
}
