import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_type.dart';

/// Active order for home banner + tracking
/// Updated to support MULTIPLE active orders (e.g., food + laundry simultaneously)
/// Backward compatible: activeOrderProvider still returns single for legacy screens,
/// but new activeOrdersProvider returns list.

class ActiveOrder {
  final String orderId;
  final ServiceType serviceType;
  final String statusMessage; // e.g. "Your jollof rice is being prepared"
  final String vendorName;    // e.g. "Papaye Fast Food"
  final String eta;           // e.g. "20-30 min"
  final DateTime? placedAt;
  final double? total;

  const ActiveOrder({
    required this.orderId,
    required this.serviceType,
    required this.statusMessage,
    required this.vendorName,
    this.eta = '',
    this.placedAt,
    this.total,
  });

  ActiveOrder copyWith({String? statusMessage, String? eta}) {
    return ActiveOrder(
      orderId: orderId,
      serviceType: serviceType,
      statusMessage: statusMessage ?? this.statusMessage,
      vendorName: vendorName,
      eta: eta ?? this.eta,
      placedAt: placedAt,
      total: total,
    );
  }

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'service_type': serviceType.name,
        'status_message': statusMessage,
        'vendor_name': vendorName,
        'eta': eta,
        'placed_at': placedAt?.toIso8601String(),
        'total': total,
      };

  factory ActiveOrder.fromJson(Map<String, dynamic> json) => ActiveOrder(
        orderId: json['order_id'] as String,
        serviceType: ServiceType.values.firstWhere(
          (e) => e.name == json['service_type'],
          orElse: () => ServiceType.food,
        ),
        statusMessage: json['status_message'] as String? ?? '',
        vendorName: json['vendor_name'] as String? ?? '',
        eta: json['eta'] as String? ?? '',
        placedAt: json['placed_at'] != null ? DateTime.tryParse(json['placed_at']) : null,
        total: (json['total'] as num?)?.toDouble(),
      );
}

// --- Multi-order notifier (new, preferred) ---

class ActiveOrdersNotifier extends Notifier<List<ActiveOrder>> {
  @override
  List<ActiveOrder> build() => [];

  void setOrder(ActiveOrder order) {
    // Replace if same orderId exists, else add
    final existing = state.indexWhere((o) => o.orderId == order.orderId);
    if (existing >= 0) {
      final updated = [...state];
      updated[existing] = order;
      state = updated;
    } else {
      state = [...state, order];
    }
    // TODO Backend: Persist to secure storage + sync with GET /orders/active
  }

  void updateStatus(String orderId, String newMessage) {
    state = [
      for (final o in state)
        if (o.orderId == orderId) o.copyWith(statusMessage: newMessage) else o,
    ];
  }

  void updateStatusForAll(String newMessage) {
    // Legacy: update first only for backward compat
    if (state.isEmpty) return;
    updateStatus(state.first.orderId, newMessage);
  }

  void clearOrder(String orderId) {
    state = state.where((o) => o.orderId != orderId).toList();
  }

  void clearAll() {
    state = [];
  }

  ActiveOrder? getById(String orderId) {
    try {
      return state.firstWhere((o) => o.orderId == orderId);
    } catch (_) {
      return null;
    }
  }
}

final activeOrdersProvider =
    NotifierProvider<ActiveOrdersNotifier, List<ActiveOrder>>(ActiveOrdersNotifier.new);

// --- Legacy single-order provider (backward compat) ---
// Existing screens watch activeOrderProvider (single). Now it proxies to multi list first item.

class ActiveOrderNotifier extends Notifier<ActiveOrder?> {
  @override
  ActiveOrder? build() {
    final multi = ref.watch(activeOrdersProvider);
    return multi.isEmpty ? null : multi.first;
  }

  void setOrder(ActiveOrder order) {
    ref.read(activeOrdersProvider.notifier).setOrder(order);
  }

  void updateStatus(String newMessage) {
    final multi = ref.read(activeOrdersProvider);
    if (multi.isEmpty) return;
    ref.read(activeOrdersProvider.notifier).updateStatus(multi.first.orderId, newMessage);
  }

  void clearOrder() {
    final multi = ref.read(activeOrdersProvider);
    if (multi.isEmpty) return;
    ref.read(activeOrdersProvider.notifier).clearOrder(multi.first.orderId);
  }
}

final activeOrderProvider =
    NotifierProvider<ActiveOrderNotifier, ActiveOrder?>(ActiveOrderNotifier.new);
