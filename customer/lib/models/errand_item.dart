/// A single item in a Buy & Deliver / errand shopping list.
class ErrandItem {
  /// Stable unique identifier so index-drift doesn't affect identity.
  final String id;
  final String name;
  final String details;
  final int quantity;

  ErrandItem({
    String? id,
    this.name = '',
    this.details = '',
    this.quantity = 1,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  ErrandItem copyWith({String? name, String? details, int? quantity}) {
    return ErrandItem(
      id: id,
      name: name ?? this.name,
      details: details ?? this.details,
      quantity: quantity ?? this.quantity,
    );
  }

  bool get isEmpty => name.trim().isEmpty;
}
