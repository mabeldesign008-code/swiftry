import 'address.dart';
import 'service_type.dart';

/// Lifecycle status of a placed order.
enum OrderStatus { placed, confirmed, inTransit, processing, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.inTransit:
        return 'In Transit';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isTerminal => this == OrderStatus.delivered || this == OrderStatus.cancelled;
}

/// A single purchased line in an [Order]. This is the frozen, order-level
/// snapshot of a cart line — independent of whatever mutable cart model
/// (CartItem, laundry map, etc.) produced it, so an order's history is never
/// affected by later cart changes.
class OrderLineItem {
  final String title;
  final String description;
  final double unitPrice;
  final int quantity;
  final String? imageUrl;

  const OrderLineItem({
    required this.title,
    this.description = '',
    required this.unitPrice,
    this.quantity = 1,
    this.imageUrl,
  });

  double get lineTotal => unitPrice * quantity;
}

const List<String> _kOrderShortDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const List<String> _kOrderShortMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

String _formatDateTime(DateTime dt) {
  final day = _kOrderShortDays[dt.weekday - 1];
  final month = _kOrderShortMonths[dt.month - 1];
  final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  final ampm = dt.hour >= 12 ? 'PM' : 'AM';
  return '$day, $month ${dt.day} • $hour12:$minute $ampm';
}

/// A generator for order IDs that are unique per order, unlike the previous
/// hardcoded `#PREFIX-48291` used for every order of a given type.
class OrderIdGenerator {
  static int _counter = 0;

  static String next(ServiceType serviceType) {
    _counter += 1;
    final ms = DateTime.now().millisecondsSinceEpoch;
    // Millisecond timestamp (mod 10^6 to keep it short) + monotonic counter
    // guarantees uniqueness even for orders placed within the same millisecond.
    final suffix = '${ms % 1000000}${_counter.toString().padLeft(2, '0')}';
    return '#${serviceType.orderPrefix}-$suffix';
  }
}

/// A fully placed order — the single source of truth used by the
/// confirmation screen, the active-order banner, "My Orders", order detail,
/// and order tracking. Previously each of those screens rendered its own
/// hardcoded/mocked data with no relation to what the user actually ordered.
class Order {
  final String id;
  final ServiceType serviceType;
  final List<OrderLineItem> items;
  final double subtotal;
  final double deliveryFee;
  final double returnDeliveryFee;
  final double serviceFee;
  final double discount;
  final double total;
  final String paymentMethod;
  final Address address;
  final String vendorName;
  final String? specialInstructions;
  final OrderStatus status;
  final DateTime placedAt;
  final String eta;
  final DateTime? scheduledFor; // null == "deliver now"
  final bool leaveAtDoor;
  // "Send to someone" — when set, the order is a gift delivered to a
  // recipient other than the person who placed/paid for it.
  final String? recipientName;
  final String? recipientPhone;
  final String? giftMessage;

  const Order({
    required this.id,
    required this.serviceType,
    required this.items,
    required this.subtotal,
    this.deliveryFee = 0,
    this.returnDeliveryFee = 0,
    this.serviceFee = 0,
    this.discount = 0,
    required this.total,
    required this.paymentMethod,
    required this.address,
    required this.vendorName,
    this.specialInstructions,
    this.status = OrderStatus.placed,
    required this.placedAt,
    this.eta = '',
    this.scheduledFor,
    this.leaveAtDoor = false,
    this.recipientName,
    this.recipientPhone,
    this.giftMessage,
  });

  Order copyWith({OrderStatus? status, Address? address}) {
    return Order(
      id: id,
      serviceType: serviceType,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      returnDeliveryFee: returnDeliveryFee,
      serviceFee: serviceFee,
      discount: discount,
      total: total,
      paymentMethod: paymentMethod,
      address: address ?? this.address,
      vendorName: vendorName,
      specialInstructions: specialInstructions,
      status: status ?? this.status,
      placedAt: placedAt,
      eta: eta,
      scheduledFor: scheduledFor,
      leaveAtDoor: leaveAtDoor,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      giftMessage: giftMessage,
    );
  }

  /// Human-readable "placed at" timestamp, e.g. "Mon, Feb 24 • 12:30 PM".
  String get placedAtLabel => _formatDateTime(placedAt);

  bool get isGift => recipientName != null && recipientName!.trim().isNotEmpty;

  bool get isScheduled => scheduledFor != null;

  bool get isActive => !status.isTerminal;

  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);

  String get itemsSummary {
    if (items.isEmpty) return 'No items';
    if (items.length == 1) {
      return '${items.first.quantity}x ${items.first.title}';
    }
    return '$totalItems item${totalItems == 1 ? '' : 's'} • ₵${total.toStringAsFixed(2)}';
  }
}
