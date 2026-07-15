import 'package:uuid/uuid.dart';
import 'address.dart';
import 'service_type.dart';

/// Lifecycle status of a placed order.
/// Maps to vendor stages via OrderStatusMapper.
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

  String get apiValue {
    switch (this) {
      case OrderStatus.placed:
        return 'placed';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.inTransit:
        return 'in_transit';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  static OrderStatus fromApi(String? value) {
    switch (value?.toLowerCase()) {
      case 'placed':
      case 'new':
        return OrderStatus.placed;
      case 'confirmed':
      case 'accepted':
        return OrderStatus.confirmed;
      case 'in_transit':
      case 'in transit':
      case 'on_the_way':
        return OrderStatus.inTransit;
      case 'processing':
      case 'preparing':
      case 'ready':
        return OrderStatus.processing;
      case 'delivered':
      case 'completed':
        return OrderStatus.delivered;
      case 'cancelled':
      case 'rejected':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.placed;
    }
  }
}

/// A single purchased line in an [Order].
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

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'unit_price': unitPrice,
        'quantity': quantity,
        'image_url': imageUrl,
      };

  factory OrderLineItem.fromJson(Map<String, dynamic> json) => OrderLineItem(
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        unitPrice: (json['unit_price'] as num?)?.toDouble() ?? (json['unitPrice'] as num?)?.toDouble() ?? 0,
        quantity: json['quantity'] as int? ?? 1,
        imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      );
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

/// Order ID generator - frontend temporary IDs.
/// TODO Backend: Replace with server-generated IDs (UUID v4 from backend).
/// For now generates client-side IDs but marks them as temporary.
class OrderIdGenerator {
  static int _counter = 0;
  static const _uuid = Uuid();

  /// Generates client-side temporary ID.
  /// Backend should replace with server ID on POST /orders response.
  static String next(ServiceType serviceType) {
    _counter += 1;
    final ms = DateTime.now().millisecondsSinceEpoch;
    final suffix = '${ms % 1000000}${_counter.toString().padLeft(2, '0')}';
    return '#${serviceType.orderPrefix}-$suffix';
  }

  /// Generates proper UUID for new orders (preferred for backend).
  static String uuid() => _uuid.v4();

  /// Generates temp order ID with service prefix + uuid suffix (more unique)
  static String nextUuid(ServiceType serviceType) {
    return '${serviceType.orderPrefix}-${_uuid.v4().substring(0, 8).toUpperCase()}';
  }
}

/// Parcel details for parcel service type
class ParcelDetails {
  final String category; // Documents, Small Package, etc.
  final double? weightKg;
  final double? lengthCm;
  final double? widthCm;
  final double? heightCm;
  final String? description;
  final bool isFragile;
  final double? declaredValue;

  const ParcelDetails({
    required this.category,
    this.weightKg,
    this.lengthCm,
    this.widthCm,
    this.heightCm,
    this.description,
    this.isFragile = false,
    this.declaredValue,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'weight_kg': weightKg,
        'length_cm': lengthCm,
        'width_cm': widthCm,
        'height_cm': heightCm,
        'description': description,
        'is_fragile': isFragile,
        'declared_value': declaredValue,
      };

  factory ParcelDetails.fromJson(Map<String, dynamic> json) => ParcelDetails(
        category: json['category'] as String,
        weightKg: (json['weight_kg'] as num?)?.toDouble(),
        lengthCm: (json['length_cm'] as num?)?.toDouble(),
        widthCm: (json['width_cm'] as num?)?.toDouble(),
        heightCm: (json['height_cm'] as num?)?.toDouble(),
        description: json['description'] as String?,
        isFragile: json['is_fragile'] as bool? ?? false,
        declaredValue: (json['declared_value'] as num?)?.toDouble(),
      );
}

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
  final String? vendorId;
  final String? riderId;
  final String? riderName;
  final String? specialInstructions;
  final OrderStatus status;
  final DateTime placedAt;
  final String eta;
  final DateTime? scheduledFor;
  final bool leaveAtDoor;
  final String? recipientName;
  final String? recipientPhone;
  final String? giftMessage;
  final ParcelDetails? parcelDetails;

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
    this.vendorId,
    this.riderId,
    this.riderName,
    this.specialInstructions,
    this.status = OrderStatus.placed,
    required this.placedAt,
    this.eta = '',
    this.scheduledFor,
    this.leaveAtDoor = false,
    this.recipientName,
    this.recipientPhone,
    this.giftMessage,
    this.parcelDetails,
  });

  Order copyWith({OrderStatus? status, Address? address, String? riderId, String? riderName, String? eta}) {
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
      vendorId: vendorId,
      riderId: riderId ?? this.riderId,
      riderName: riderName ?? this.riderName,
      specialInstructions: specialInstructions,
      status: status ?? this.status,
      placedAt: placedAt,
      eta: eta ?? this.eta,
      scheduledFor: scheduledFor,
      leaveAtDoor: leaveAtDoor,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      giftMessage: giftMessage,
      parcelDetails: parcelDetails,
    );
  }

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'service_type': serviceType.name,
        'items': items.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'delivery_fee': deliveryFee,
        'return_delivery_fee': returnDeliveryFee,
        'service_fee': serviceFee,
        'discount': discount,
        'total': total,
        'payment_method': paymentMethod,
        'address': address.toJson(),
        'vendor_name': vendorName,
        'vendor_id': vendorId,
        'rider_id': riderId,
        'rider_name': riderName,
        'special_instructions': specialInstructions,
        'status': status.apiValue,
        'placed_at': placedAt.toIso8601String(),
        'eta': eta,
        'scheduled_for': scheduledFor?.toIso8601String(),
        'leave_at_door': leaveAtDoor,
        'recipient_name': recipientName,
        'recipient_phone': recipientPhone,
        'gift_message': giftMessage,
        'parcel_details': parcelDetails?.toJson(),
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String,
        serviceType: ServiceType.values.firstWhere(
          (e) => e.name == json['service_type'],
          orElse: () => ServiceType.food,
        ),
        items: (json['items'] as List? ?? []).map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>)).toList(),
        subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
        deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0,
        returnDeliveryFee: (json['return_delivery_fee'] as num?)?.toDouble() ?? 0,
        serviceFee: (json['service_fee'] as num?)?.toDouble() ?? 0,
        discount: (json['discount'] as num?)?.toDouble() ?? 0,
        total: (json['total'] as num?)?.toDouble() ?? 0,
        paymentMethod: json['payment_method'] as String? ?? json['paymentMethod'] as String? ?? 'Cash',
        address: json['address'] != null ? Address.fromJson(json['address'] as Map<String, dynamic>) : Address(street: ''),
        vendorName: json['vendor_name'] as String? ?? json['vendorName'] as String? ?? '',
        vendorId: json['vendor_id'] as String?,
        riderId: json['rider_id'] as String?,
        riderName: json['rider_name'] as String?,
        specialInstructions: json['special_instructions'] as String?,
        status: OrderStatusX.fromApi(json['status'] as String?),
        placedAt: json['placed_at'] != null ? DateTime.parse(json['placed_at'] as String) : DateTime.now(),
        eta: json['eta'] as String? ?? '',
        scheduledFor: json['scheduled_for'] != null ? DateTime.tryParse(json['scheduled_for'] as String) : null,
        leaveAtDoor: json['leave_at_door'] as bool? ?? false,
        recipientName: json['recipient_name'] as String?,
        recipientPhone: json['recipient_phone'] as String?,
        giftMessage: json['gift_message'] as String?,
        parcelDetails: json['parcel_details'] != null ? ParcelDetails.fromJson(json['parcel_details'] as Map<String, dynamic>) : null,
      );
}
