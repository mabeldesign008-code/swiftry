import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_type.dart';

class ActiveOrder {
  final String orderId;
  final ServiceType serviceType;
  final String statusMessage; // e.g. "Your jollof rice is being prepared"
  final String vendorName;    // e.g. "Papaye Fast Food"
  final String eta;           // e.g. "20-30 min"

  const ActiveOrder({
    required this.orderId,
    required this.serviceType,
    required this.statusMessage,
    required this.vendorName,
    this.eta = '',
  });
}

class ActiveOrderNotifier extends Notifier<ActiveOrder?> {
  @override
  ActiveOrder? build() => null;

  void setOrder(ActiveOrder order) {
    state = order;
  }

  void updateStatus(String newMessage) {
    if (state == null) return;
    state = ActiveOrder(
      orderId: state!.orderId,
      serviceType: state!.serviceType,
      statusMessage: newMessage,
      vendorName: state!.vendorName,
      eta: state!.eta,
    );
  }

  void clearOrder() {
    state = null;
  }
}

final activeOrderProvider =
    NotifierProvider<ActiveOrderNotifier, ActiveOrder?>(ActiveOrderNotifier.new);
