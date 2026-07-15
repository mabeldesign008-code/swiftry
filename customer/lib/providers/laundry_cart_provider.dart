import 'package:flutter_riverpod/flutter_riverpod.dart';

// LaundryItem model is available for vendor screen item definitions;
// the cart itself tracks name → quantity.  Full pricing integration
// will be done in the laundry-flow milestone when vendor/cart screens
// are reworked together.
export '../models/laundry_item.dart';

class LaundryCartNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => {};

  /// [delta] > 0 adds, [delta] < 0 removes. Auto-removes at qty ≤ 0.
  void updateQuantity(String name, int delta) {
    final updated = Map<String, int>.from(state);
    final newQty = (updated[name] ?? 0) + delta;
    if (newQty <= 0) {
      updated.remove(name);
    } else {
      updated[name] = newQty;
    }
    state = updated;
  }

  void removeItem(String name) {
    final updated = Map<String, int>.from(state)..remove(name);
    state = updated;
  }

  void clearCart() {
    state = {};
  }

  int get totalItems => state.values.fold(0, (sum, qty) => sum + qty);
}

final laundryCartProvider =
    NotifierProvider<LaundryCartNotifier, Map<String, int>>(
        LaundryCartNotifier.new);
