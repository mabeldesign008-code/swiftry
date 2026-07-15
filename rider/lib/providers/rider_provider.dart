import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/rider.dart';
import '../models/order.dart';
import '../core/storage/secure_storage_service.dart';

/// Rider state - online/offline, earnings, current orders

class RiderNotifier extends Notifier<Rider?> {
  @override
  Rider? build() => null;

  void setRider(Rider rider) {
    state = rider;
  }

  void setOnline(bool online) {
    if (state == null) return;
    state = Rider(
      id: state!.id,
      name: state!.name,
      phone: state!.phone,
      email: state!.email,
      photoUrl: state!.photoUrl,
      rating: state!.rating,
      totalDeliveries: state!.totalDeliveries,
      isOnline: online,
      isVerified: state!.isVerified,
      vehicleType: state!.vehicleType,
    );
    // TODO Backend: POST /rider/availability {is_online: online}
    SecureStorageService().setOnline(online);
  }

  void clear() {
    state = null;
  }
}

final riderProvider = NotifierProvider<RiderNotifier, Rider?>(RiderNotifier.new);

class RiderOrdersNotifier extends Notifier<List<RiderOrder>> {
  @override
  List<RiderOrder> build() => _mockIncomingOrders();

  static List<RiderOrder> _mockIncomingOrders() {
    return [
      RiderOrder(
        id: '#FOD-123456',
        serviceType: ServiceType.food,
        customerName: 'Ama Owusu',
        customerPhone: '+233 24 123 4567',
        customerAddress: 'Osu, Accra - Behind MTN mast, blue gate',
        customerLat: 5.6143,
        customerLng: -0.2050,
        vendorName: 'Papaye Fast Food',
        vendorAddress: 'Osu Oxford Street',
        vendorLat: 5.6037,
        vendorLng: -0.1870,
        items: const [
          OrderItem(title: 'Jollof Rice with Chicken', quantity: 2, price: 45),
          OrderItem(title: 'Coca-Cola', quantity: 1, price: 10),
        ],
        total: 100,
        deliveryFee: 15,
        riderEarning: 18,
        assignedAt: DateTime.now().subtract(const Duration(minutes: 2)),
        specialInstructions: 'Call when you arrive',
        paymentMethod: 'MoMo',
        isPaid: true,
      ),
      RiderOrder(
        id: '#PCL-789012',
        serviceType: ServiceType.parcel,
        customerName: 'Kwame Mensah',
        customerPhone: '+233 55 987 6543',
        customerAddress: 'East Legon, Near A&C Mall',
        customerLat: 5.6350,
        customerLng: -0.1625,
        vendorName: 'Pickup: Accra Mall',
        vendorAddress: 'Accra Mall, Tetteh Quarshie',
        vendorLat: 5.6250,
        vendorLng: -0.1730,
        items: const [OrderItem(title: 'Documents - Small Package', quantity: 1, price: 0)],
        total: 25,
        deliveryFee: 25,
        riderEarning: 20,
        assignedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        paymentMethod: 'Cash',
        isPaid: false,
        parcelInfo: const ParcelInfo(category: 'Documents', weightKg: 0.5, isFragile: false),
      ),
      RiderOrder(
        id: '#LND-345678',
        serviceType: ServiceType.laundry,
        customerName: 'Abena S.',
        customerPhone: '+233 20 111 2222',
        customerAddress: 'Dzorwulu, Accra',
        customerLat: 5.6090,
        customerLng: -0.1960,
        vendorName: 'CleanPro Laundry',
        vendorAddress: 'Dzorwulu Junction',
        vendorLat: 5.6080,
        vendorLng: -0.1965,
        items: const [OrderItem(title: 'Laundry Pickup - 5 items', quantity: 5, price: 8)],
        total: 40,
        deliveryFee: 10,
        riderEarning: 15,
        assignedAt: DateTime.now().subtract(const Duration(minutes: 8)),
        laundryInfo: const LaundryInfo(itemCount: 5, estimatedWeightKg: 2.5),
      ),
    ];
  }

  void acceptOrder(String orderId) {
    state = [
      for (final o in state)
        if (o.id == orderId) o.copyWith(status: OrderStatus.headingToPickup) else o,
    ];
    // TODO Backend: POST /rider/orders/:id/accept
  }

  void rejectOrder(String orderId) {
    state = state.where((o) => o.id != orderId).toList();
    // TODO Backend: POST /rider/orders/:id/reject {reason}
  }

  void updateStatus(String orderId, OrderStatus status) {
    state = [
      for (final o in state)
        if (o.id == orderId) o.copyWith(status: status) else o,
    ];
    // TODO Backend: POST /rider/orders/:id/stage {stage: status.name, lat, lng}
  }

  List<RiderOrder> get incoming => state.where((o) => o.status == OrderStatus.assigned).toList();
  List<RiderOrder> get active => state.where((o) => o.status != OrderStatus.assigned && !o.status.isTerminal).toList();
  List<RiderOrder> get history => state.where((o) => o.status.isTerminal).toList();
}

final riderOrdersProvider = NotifierProvider<RiderOrdersNotifier, List<RiderOrder>>(RiderOrdersNotifier.new);

class EarningsNotifier extends Notifier<Earnings> {
  @override
  Earnings build() => const Earnings(today: 125.0, thisWeek: 780.0, thisMonth: 2450.0, balance: 340.0, deliveriesToday: 6);

  void addEarning(double amount) {
    state = Earnings(
      today: state.today + amount,
      thisWeek: state.thisWeek + amount,
      thisMonth: state.thisMonth + amount,
      balance: state.balance + amount,
      deliveriesToday: state.deliveriesToday + 1,
    );
  }
}

final earningsProvider = NotifierProvider<EarningsNotifier, Earnings>(EarningsNotifier.new);
