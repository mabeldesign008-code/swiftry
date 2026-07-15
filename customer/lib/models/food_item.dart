/// A selectable option within an addon group (e.g., "Grilled Chicken" in the Protein group).
class AddonOption {
  final String name;
  final double priceAdjustment; // 0.0 means included, positive = extra charge

  const AddonOption(this.name, this.priceAdjustment);

  /// Display string, e.g., "Grilled Chicken" or "Fried Fish (+₵3.00)"
  String get displayLabel {
    if (priceAdjustment <= 0) return name;
    return '$name (+₵${priceAdjustment.toStringAsFixed(2)})';
  }
}

/// A group of addon options (e.g., "Choose your protein", "Add extras").
class AddonGroup {
  final String name;           // e.g., "Choose your protein"
  final bool isRequired;       // true = customer MUST pick at least one
  final int minSelections;     // minimum selections required (usually 1 if isRequired)
  final int maxSelections;     // maximum selections allowed (1 = radio, >1 = multi-checkbox)
  final List<AddonOption> options;

  const AddonGroup({
    required this.name,
    required this.isRequired,
    required this.minSelections,
    required this.maxSelections,
    required this.options,
  });

  bool get isSingleSelect => maxSelections == 1;
}
