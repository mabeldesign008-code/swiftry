import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';

// Re-export so existing screens that import this file still get CartItem.
export '../models/cart_item.dart';

class FoodCartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void addItem(CartItem item) {
    // Merge only when the item is truly identical (same vendor, addons,
    // variants, and instructions) — see CartItem.customizationKey. Two adds
    // of the same dish with different customizations become distinct lines
    // instead of silently discarding one add's addons/instructions.
    final key = item.customizationKey;
    final existingIndex = state.indexWhere((i) => i.customizationKey == key);
    if (existingIndex >= 0) {
      final updated = [...state];
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + item.quantity,
      );
      state = updated;
    } else {
      state = [...state, item];
    }
  }

  /// Updates the quantity of a specific cart line, identified by its
  /// [CartItem.customizationKey] (not just its title — two lines can share a
  /// title but differ in addons/variants/instructions).
  void updateQuantity(String customizationKey, int delta) {
    final updated = <CartItem>[];
    for (final item in state) {
      if (item.customizationKey == customizationKey) {
        final newQty = item.quantity + delta;
        if (newQty > 0) updated.add(item.copyWith(quantity: newQty));
      } else {
        updated.add(item);
      }
    }
    state = updated;
  }

  void removeItem(String customizationKey) {
    state = state.where((item) => item.customizationKey != customizationKey).toList();
  }

  void clearCart() {
    state = [];
  }

  /// Clears the cart and adds the new item. Used after user confirms "Start new cart".
  void replaceCart(CartItem item) {
    state = [item];
  }

  double get subtotal =>
      state.fold(0, (sum, item) => sum + item.lineTotal);

  int get totalItems =>
      state.fold(0, (sum, item) => sum + item.quantity);

  /// Returns null if cart is empty, otherwise the vendorId of all current items.
  String? get currentVendorId {
    if (state.isEmpty) return null;
    return state.first.restaurantId ?? state.first.vendorId;
  }

  /// Returns the vendor name of current cart items, or null if empty.
  String? get currentVendorName {
    if (state.isEmpty) return null;
    return state.first.vendorName;
  }

  /// Returns true if adding an item from [vendorId] would cause a vendor conflict.
  bool hasVendorConflict(String? vendorId) {
    if (state.isEmpty) return false;
    final current = currentVendorId;
    if (current == null) return false;
    return current != vendorId;
  }

  /// Human-readable summary of the cart, e.g. "3 items from Papaye Fast Food".
  String get cartSummary {
    if (state.isEmpty) return 'Empty cart';
    return '$totalItems item${totalItems == 1 ? '' : 's'} from ${currentVendorName ?? 'vendor'}';
  }
}

final foodCartProvider =
    NotifierProvider<FoodCartNotifier, List<CartItem>>(FoodCartNotifier.new);
