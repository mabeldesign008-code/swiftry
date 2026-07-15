/// Vendor configuration matching the VENDOR_CONFIG from React app
/// This defines business-type-specific settings, labels, and workflows
class VendorConfig {
  final String catalogLabel;
  final String itemLabel;
  final String itemLabelPlural;
  final List<String> categories;
  final List<CategoryItem> defaultCategories;
  final List<OrderStage> orderStages;
  final List<String> pricingTypes;
  final VendorFields fields;
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

  /// Get vendor config by business type
  static VendorConfig getConfig(String businessType) {
    return _vendorConfigs[businessType] ?? _vendorConfigs['restaurant']!;
  }

  /// All vendor configurations
  static final Map<String, VendorConfig> _vendorConfigs = {
    'restaurant': VendorConfig(
      catalogLabel: 'Menu',
      itemLabel: 'Dish',
      itemLabelPlural: 'Dishes',
      categories: ['All', 'Starters', 'Main Course', 'Sides', 'Drinks', 'Desserts'],
      defaultCategories: [
        CategoryItem(name: 'Starters', items: 8),
        CategoryItem(name: 'Main Course', items: 14),
        CategoryItem(name: 'Drinks', items: 12),
        CategoryItem(name: 'Desserts', items: 6),
      ],
      orderStages: [
        OrderStage(id: 'new', label: 'New'),
        OrderStage(id: 'preparing', label: 'Preparing'),
        OrderStage(id: 'ready', label: 'Ready'),
        OrderStage(id: 'completed', label: 'Completed'),
      ],
      pricingTypes: ['Fixed Price', 'Per Portion'],
      fields: VendorFields(
        prepTime: true,
        turnaround: false,
        rxRequired: false,
        weightUnit: false,
        variants: false,
        expiryDate: false,
        dailyPrice: false,
        garmentType: false,
        dietary: true,
        sku: false,
        stockQty: false,
      ),
      prepTimeLabel: 'Preparation Time',
      prepTimeOptions: ['5-10 min', '10-15 min', '15-20 min', '20-30 min', '30+ min'],
      analyticsItemLabel: 'Dishes Sold',
      analyticsTopLabel: 'Popular Dishes',
      searchPlaceholder: 'Search menu items...',
      hasRxFlow: false,
      hasPickingFlow: false,
      hasConditionLog: false,
      hasDailyPricing: false,
    ),
    'groceries': VendorConfig(
      catalogLabel: 'Products',
      itemLabel: 'Product',
      itemLabelPlural: 'Products',
      categories: ['All', 'Produce', 'Dairy', 'Bakery', 'Beverages', 'Frozen', 'Household'],
      defaultCategories: [
        CategoryItem(name: 'Produce', items: 42),
        CategoryItem(name: 'Dairy', items: 18),
        CategoryItem(name: 'Bakery', items: 24),
        CategoryItem(name: 'Beverages', items: 35),
      ],
      orderStages: [
        OrderStage(id: 'new', label: 'New'),
        OrderStage(id: 'picking', label: 'Picking'),
        OrderStage(id: 'packed', label: 'Packed'),
        OrderStage(id: 'completed', label: 'Completed'),
      ],
      pricingTypes: ['Per Unit', 'Per Kg', 'Per Bundle'],
      fields: VendorFields(
        prepTime: false,
        turnaround: false,
        rxRequired: false,
        weightUnit: true,
        variants: false,
        expiryDate: false,
        dailyPrice: false,
        garmentType: false,
        dietary: false,
        sku: true,
        stockQty: true,
      ),
      prepTimeLabel: 'Packing Time',
      prepTimeOptions: ['2-5 min', '5-10 min', '10-15 min', '15-20 min'],
      analyticsItemLabel: 'Items Picked',
      analyticsTopLabel: 'Top Sellers',
      searchPlaceholder: 'Search products...',
      hasRxFlow: false,
      hasPickingFlow: true,
      hasConditionLog: false,
      hasDailyPricing: false,
    ),
    'market': VendorConfig(
      catalogLabel: 'Products',
      itemLabel: 'Product',
      itemLabelPlural: 'Products',
      categories: ['All', 'Vegetables', 'Fruits', 'Grains', 'Proteins', 'Spices', 'Tubers'],
      defaultCategories: [
        CategoryItem(name: 'Vegetables', items: 28),
        CategoryItem(name: 'Fruits', items: 16),
        CategoryItem(name: 'Grains', items: 12),
        CategoryItem(name: 'Proteins', items: 8),
      ],
      orderStages: [
        OrderStage(id: 'new', label: 'New'),
        OrderStage(id: 'weighing', label: 'Weighing'),
        OrderStage(id: 'packed', label: 'Packed'),
        OrderStage(id: 'completed', label: 'Completed'),
      ],
      pricingTypes: ['Per Pile', 'Per Bunch', 'Per Kg', 'Per Crate', 'Per Head'],
      fields: VendorFields(
        prepTime: false,
        turnaround: false,
        rxRequired: false,
        weightUnit: true,
        variants: false,
        expiryDate: false,
        dailyPrice: true,
        garmentType: false,
        dietary: false,
        sku: false,
        stockQty: true,
      ),
      prepTimeLabel: 'Packing Time',
      prepTimeOptions: ['Under 5 min', '5-10 min', '10-15 min'],
      analyticsItemLabel: 'Items Sold',
      analyticsTopLabel: 'Top Items',
      searchPlaceholder: 'Search produce...',
      hasRxFlow: false,
      hasPickingFlow: false,
      hasConditionLog: false,
      hasDailyPricing: true,
    ),
    'pharmacy': VendorConfig(
      catalogLabel: 'Products',
      itemLabel: 'Product',
      itemLabelPlural: 'Products',
      categories: ['All', 'Pain Relief', 'Antibiotics', 'Vitamins', 'Skincare', 'Baby Care', 'OTC', 'Rx Only'],
      defaultCategories: [
        CategoryItem(name: 'Pain Relief', items: 18),
        CategoryItem(name: 'Antibiotics', items: 12),
        CategoryItem(name: 'Vitamins', items: 24),
        CategoryItem(name: 'OTC', items: 45),
      ],
      orderStages: [
        OrderStage(id: 'new', label: 'New'),
        OrderStage(id: 'rx_check', label: 'Rx Check'),
        OrderStage(id: 'approved', label: 'Approved'),
        OrderStage(id: 'dispensing', label: 'Dispensing'),
        OrderStage(id: 'completed', label: 'Completed'),
      ],
      pricingTypes: ['Per Unit', 'Per Pack', 'Per Strip'],
      fields: VendorFields(
        prepTime: false,
        turnaround: false,
        rxRequired: true,
        weightUnit: false,
        variants: false,
        expiryDate: true,
        dailyPrice: false,
        garmentType: false,
        dietary: false,
        sku: true,
        stockQty: true,
      ),
      prepTimeLabel: 'Dispensing Time',
      prepTimeOptions: ['Under 5 min', '5-10 min', '10-15 min', '15-30 min'],
      analyticsItemLabel: 'Prescriptions Filled',
      analyticsTopLabel: 'Top Products',
      searchPlaceholder: 'Search drugs & products...',
      hasRxFlow: true,
      hasPickingFlow: false,
      hasConditionLog: false,
      hasDailyPricing: false,
    ),
    'retail': VendorConfig(
      catalogLabel: 'Products',
      itemLabel: 'Product',
      itemLabelPlural: 'Products',
      categories: ['All', 'Electronics', 'Fashion', 'Beauty', 'Home & Living', 'Accessories'],
      defaultCategories: [
        CategoryItem(name: 'Electronics', items: 32),
        CategoryItem(name: 'Fashion', items: 48),
        CategoryItem(name: 'Beauty', items: 26),
        CategoryItem(name: 'Accessories', items: 19),
      ],
      orderStages: [
        OrderStage(id: 'new', label: 'New'),
        OrderStage(id: 'packing', label: 'Packing'),
        OrderStage(id: 'ready', label: 'Ready'),
        OrderStage(id: 'completed', label: 'Completed'),
      ],
      pricingTypes: ['Fixed Price', 'Per Variant'],
      fields: VendorFields(
        prepTime: false,
        turnaround: false,
        rxRequired: false,
        weightUnit: false,
        variants: true,
        expiryDate: false,
        dailyPrice: false,
        garmentType: false,
        dietary: false,
        sku: true,
        stockQty: true,
      ),
      prepTimeLabel: 'Packing Time',
      prepTimeOptions: ['Same Day', 'Next Day', '2-3 Days'],
      analyticsItemLabel: 'Items Sold',
      analyticsTopLabel: 'Best Sellers',
      searchPlaceholder: 'Search products...',
      hasRxFlow: false,
      hasPickingFlow: false,
      hasConditionLog: false,
      hasDailyPricing: false,
    ),
    'laundry': VendorConfig(
      catalogLabel: 'Services',
      itemLabel: 'Service',
      itemLabelPlural: 'Services',
      categories: ['All', 'Wash & Fold', 'Dry Cleaning', 'Ironing', 'Express', 'Stain Treatment'],
      defaultCategories: [
        CategoryItem(name: 'Wash & Fold', items: 3),
        CategoryItem(name: 'Dry Cleaning', items: 8),
        CategoryItem(name: 'Ironing', items: 2),
        CategoryItem(name: 'Express', items: 4),
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
      fields: VendorFields(
        prepTime: false,
        turnaround: true,
        rxRequired: false,
        weightUnit: false,
        variants: false,
        expiryDate: false,
        dailyPrice: false,
        garmentType: true,
        dietary: false,
        sku: false,
        stockQty: false,
      ),
      prepTimeLabel: 'Turnaround Time',
      prepTimeOptions: ['Express (24h)', 'Standard (3 days)', 'Extended (5 days)'],
      analyticsItemLabel: 'Orders Processed',
      analyticsTopLabel: 'Popular Services',
      searchPlaceholder: 'Search services...',
      hasRxFlow: false,
      hasPickingFlow: false,
      hasConditionLog: true,
      hasDailyPricing: false,
    ),
  };
}

/// Category with item count
class CategoryItem {
  final String name;
  final int items;

  const CategoryItem({
    required this.name,
    required this.items,
  });
}

/// Order stage definition
class OrderStage {
  final String id;
  final String label;

  const OrderStage({
    required this.id,
    required this.label,
  });
}

/// Fields that are enabled/disabled per business type
class VendorFields {
  final bool prepTime;
  final bool turnaround;
  final bool rxRequired;
  final bool weightUnit;
  final bool variants;
  final bool expiryDate;
  final bool dailyPrice;
  final bool garmentType;
  final bool dietary;
  final bool sku;
  final bool stockQty;

  const VendorFields({
    required this.prepTime,
    required this.turnaround,
    required this.rxRequired,
    required this.weightUnit,
    required this.variants,
    required this.expiryDate,
    required this.dailyPrice,
    required this.garmentType,
    required this.dietary,
    required this.sku,
    required this.stockQty,
  });
}
