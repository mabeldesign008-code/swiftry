import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/address.dart';
import '../models/order.dart';

/// Single source of truth for every order the user has placed this session.
///
/// Previously "My Orders" (`OrdersScreen`) and `OrderDetailScreen` rendered
/// hardcoded mock lists that were completely disconnected from the checkout
/// flow — placing an order never made it show up here, and cancelling an
/// order never changed anything. This notifier is what checkout, order
/// history, order detail, and order tracking now all read from and write to.
class OrderHistoryNotifier extends Notifier<List<Order>> {
  @override
  List<Order> build() => [];

  /// Records a newly-placed order at the top of the history.
  void placeOrder(Order order) {
    state = [order, ...state];
  }

  void updateStatus(String orderId, OrderStatus status) {
    state = [
      for (final o in state)
        if (o.id == orderId) o.copyWith(status: status) else o,
    ];
  }

  /// Cancels an order (if it exists and isn't already in a terminal state).
  void cancelOrder(String orderId) => updateStatus(orderId, OrderStatus.cancelled);

  /// Updates the delivery address on an already-placed order. Previously
  /// the "Change" address button on the order detail screen opened the
  /// address modal but discarded whatever the user picked.
  void updateAddress(String orderId, Address address) {
    state = [
      for (final o in state)
        if (o.id == orderId) o.copyWith(address: address) else o,
    ];
  }

  Order? byId(String orderId) {
    for (final o in state) {
      if (o.id == orderId) return o;
    }
    return null;
  }

  List<Order> get activeOrders => state.where((o) => o.isActive).toList();

  List<Order> get pastOrders => state.where((o) => !o.isActive).toList();
}

final orderHistoryProvider =
    NotifierProvider<OrderHistoryNotifier, List<Order>>(OrderHistoryNotifier.new);
