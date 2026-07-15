/// Rider Order model - mirrors customer order but from rider perspective
/// Frontend contract for backend integration

enum OrderStatus { assigned, headingToPickup, arrivedAtPickup, pickedUp, headingToDropoff, arrivedAtDropoff, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.assigned: return 'Assigned';
      case OrderStatus.headingToPickup: return 'Heading to Pickup';
      case OrderStatus.arrivedAtPickup: return 'Arrived at Pickup';
      case OrderStatus.pickedUp: return 'Picked Up';
      case OrderStatus.headingToDropoff: return 'Heading to Dropoff';
      case OrderStatus.arrivedAtDropoff: return 'Arrived at Dropoff';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }

  bool get isTerminal => this == OrderStatus.delivered || this == OrderStatus.cancelled;
}

enum ServiceType { food, groceries, market, pharmacy, parcel, errand, laundry, shop, bill, queue }

class RiderOrder {
  final String id;
  final ServiceType serviceType;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final double customerLat;
  final double customerLng;

  final String vendorName;
  final String vendorAddress;
  final double vendorLat;
  final double vendorLng;

  final List<OrderItem> items;
  final double total;
  final double deliveryFee;
  final double riderEarning;

  final OrderStatus status;
  final DateTime assignedAt;
  final String? deliveryOtp;
  final String? specialInstructions;
  final bool isScheduled;
  final DateTime? scheduledFor;
  final String paymentMethod;
  final bool isPaid;

  // Parcel specific
  final ParcelInfo? parcelInfo;
  // Laundry specific
  final LaundryInfo? laundryInfo;

  const RiderOrder({
    required this.id,
    required this.serviceType,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerLat,
    required this.customerLng,
    required this.vendorName,
    required this.vendorAddress,
    required this.vendorLat,
    required this.vendorLng,
    required this.items,
    required this.total,
    this.deliveryFee = 0,
    this.riderEarning = 0,
    this.status = OrderStatus.assigned,
    required this.assignedAt,
    this.deliveryOtp,
    this.specialInstructions,
    this.isScheduled = false,
    this.scheduledFor,
    this.paymentMethod = 'Cash',
    this.isPaid = false,
    this.parcelInfo,
    this.laundryInfo,
  });

  RiderOrder copyWith({OrderStatus? status, String? deliveryOtp}) {
    return RiderOrder(
      id: id,
      serviceType: serviceType,
      customerName: customerName,
      customerPhone: customerPhone,
      customerAddress: customerAddress,
      customerLat: customerLat,
      customerLng: customerLng,
      vendorName: vendorName,
      vendorAddress: vendorAddress,
      vendorLat: vendorLat,
      vendorLng: vendorLng,
      items: items,
      total: total,
      deliveryFee: deliveryFee,
      riderEarning: riderEarning,
      status: status ?? this.status,
      assignedAt: assignedAt,
      deliveryOtp: deliveryOtp ?? this.deliveryOtp,
      specialInstructions: specialInstructions,
      isScheduled: isScheduled,
      scheduledFor: scheduledFor,
      paymentMethod: paymentMethod,
      isPaid: isPaid,
      parcelInfo: parcelInfo,
      laundryInfo: laundryInfo,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'service_type': serviceType.name,
        'customer': {
          'name': customerName,
          'phone': customerPhone,
          'address': customerAddress,
          'lat': customerLat,
          'lng': customerLng,
        },
        'vendor': {
          'name': vendorName,
          'address': vendorAddress,
          'lat': vendorLat,
          'lng': vendorLng,
        },
        'items': items.map((e) => e.toJson()).toList(),
        'total': total,
        'delivery_fee': deliveryFee,
        'rider_earning': riderEarning,
        'status': status.name,
        'assigned_at': assignedAt.toIso8601String(),
        'payment_method': paymentMethod,
        'is_paid': isPaid,
      };

  factory RiderOrder.fromJson(Map<String, dynamic> json) {
    final cust = json['customer'] as Map<String, dynamic>? ?? {};
    final vend = json['vendor'] as Map<String, dynamic>? ?? {};
    return RiderOrder(
      id: json['id'] as String,
      serviceType: ServiceType.values.firstWhere(
        (e) => e.name == json['service_type'],
        orElse: () => ServiceType.food,
      ),
      customerName: cust['name'] as String? ?? '',
      customerPhone: cust['phone'] as String? ?? '',
      customerAddress: cust['address'] as String? ?? '',
      customerLat: (cust['lat'] as num?)?.toDouble() ?? 0,
      customerLng: (cust['lng'] as num?)?.toDouble() ?? 0,
      vendorName: vend['name'] as String? ?? '',
      vendorAddress: vend['address'] as String? ?? '',
      vendorLat: (vend['lat'] as num?)?.toDouble() ?? 0,
      vendorLng: (vend['lng'] as num?)?.toDouble() ?? 0,
      items: (json['items'] as List? ?? []).map((e) => OrderItem.fromJson(e)).toList(),
      total: (json['total'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0,
      riderEarning: (json['rider_earning'] as num?)?.toDouble() ?? 0,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.assigned,
      ),
      assignedAt: json['assigned_at'] != null ? DateTime.parse(json['assigned_at']) : DateTime.now(),
      paymentMethod: json['payment_method'] as String? ?? 'Cash',
      isPaid: json['is_paid'] as bool? ?? false,
    );
  }
}

class OrderItem {
  final String title;
  final int quantity;
  final double price;

  const OrderItem({required this.title, this.quantity = 1, this.price = 0});

  Map<String, dynamic> toJson() => {'title': title, 'quantity': quantity, 'price': price};
  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        title: json['title'] as String,
        quantity: json['quantity'] as int? ?? 1,
        price: (json['price'] as num?)?.toDouble() ?? 0,
      );
}

class ParcelInfo {
  final String category;
  final double? weightKg;
  final String? description;
  final bool isFragile;

  const ParcelInfo({required this.category, this.weightKg, this.description, this.isFragile = false});
}

class LaundryInfo {
  final int itemCount;
  final double? estimatedWeightKg;

  const LaundryInfo({required this.itemCount, this.estimatedWeightKg});
}
