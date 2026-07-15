import '../../models/order.dart';
import '../../models/service_type.dart';

/// Maps between customer-facing OrderStatus and vendor-facing order stages.
/// Backend team MUST implement this mapping consistently across services.
/// This is now the single source of truth.

class OrderStatusMapper {
  OrderStatusMapper._();

  /// Customer status -> Vendor stage (generic)
  static String toVendorStage(OrderStatus status, ServiceType serviceType) {
    switch (serviceType) {
      case ServiceType.food:
      case ServiceType.groceries:
      case ServiceType.shop:
        switch (status) {
          case OrderStatus.placed:
            return 'new';
          case OrderStatus.confirmed:
            return 'preparing'; // or picking/packing depending on type
          case OrderStatus.processing:
            return 'ready';
          case OrderStatus.inTransit:
            return 'ready'; // rider picked
          case OrderStatus.delivered:
            return 'completed';
          case OrderStatus.cancelled:
            return 'cancelled';
        }
      case ServiceType.market:
        switch (status) {
          case OrderStatus.placed:
            return 'new';
          case OrderStatus.confirmed:
            return 'weighing';
          case OrderStatus.processing:
            return 'packed';
          case OrderStatus.inTransit:
            return 'packed';
          case OrderStatus.delivered:
            return 'completed';
          case OrderStatus.cancelled:
            return 'cancelled';
        }
      case ServiceType.pharmacy:
        switch (status) {
          case OrderStatus.placed:
            return 'new';
          case OrderStatus.confirmed:
            return 'rx_check';
          case OrderStatus.processing:
            return 'dispensing';
          case OrderStatus.inTransit:
            return 'dispensing';
          case OrderStatus.delivered:
            return 'completed';
          case OrderStatus.cancelled:
            return 'cancelled';
        }
      case ServiceType.laundry:
        switch (status) {
          case OrderStatus.placed:
            return 'collected';
          case OrderStatus.confirmed:
            return 'sorting';
          case OrderStatus.processing:
            return 'washing'; // could be washing|drying|qc
          case OrderStatus.inTransit:
            return 'completed'; // return trip
          case OrderStatus.delivered:
            return 'completed';
          case OrderStatus.cancelled:
            return 'cancelled';
        }
      case ServiceType.parcel:
      case ServiceType.errand:
      case ServiceType.queue:
      case ServiceType.bill:
        switch (status) {
          case OrderStatus.placed:
            return 'new';
          case OrderStatus.confirmed:
            return 'confirmed';
          case OrderStatus.processing:
            return 'processing';
          case OrderStatus.inTransit:
            return 'in_transit';
          case OrderStatus.delivered:
            return 'completed';
          case OrderStatus.cancelled:
            return 'cancelled';
        }
    }
  }

  /// Vendor stage -> Customer status
  static OrderStatus fromVendorStage(String vendorStage) {
    final normalized = vendorStage.toLowerCase().trim();
    switch (normalized) {
      case 'new':
      case 'placed':
        return OrderStatus.placed;
      case 'confirmed':
      case 'accepted':
      case 'preparing':
      case 'picking':
      case 'packing':
      case 'weighing':
      case 'rx_check':
      case 'approved':
      case 'collected':
      case 'sorting':
        return OrderStatus.confirmed;
      case 'ready':
      case 'packed':
      case 'dispensing':
      case 'qc':
      case 'washing':
      case 'drying':
      case 'in_kitchen':
        return OrderStatus.processing;
      case 'in_transit':
      case 'on_the_way':
      case 'rider_assigned':
      case 'out_for_delivery':
        return OrderStatus.inTransit;
      case 'delivered':
      case 'completed':
        return OrderStatus.delivered;
      case 'cancelled':
      case 'rejected':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.confirmed;
    }
  }

  /// Human-readable timeline steps for customer tracking UI
  static List<TrackingStep> timelineFor(ServiceType type, OrderStatus current) {
    // Generic timeline for most services
    final base = [
      TrackingStep(status: OrderStatus.placed, label: 'Order Placed', icon: 'placed'),
      TrackingStep(status: OrderStatus.confirmed, label: 'Confirmed', icon: 'confirmed'),
      TrackingStep(status: OrderStatus.processing, label: 'Processing', icon: 'processing'),
      TrackingStep(status: OrderStatus.inTransit, label: 'On the way', icon: 'transit'),
      TrackingStep(status: OrderStatus.delivered, label: 'Delivered', icon: 'delivered'),
    ];

    if (type == ServiceType.laundry) {
      return [
        TrackingStep(status: OrderStatus.placed, label: 'Pickup Requested', icon: 'placed'),
        TrackingStep(status: OrderStatus.confirmed, label: 'Laundry Collected', icon: 'confirmed'),
        TrackingStep(status: OrderStatus.processing, label: 'Cleaning', icon: 'processing'),
        TrackingStep(status: OrderStatus.inTransit, label: 'Returning', icon: 'transit'),
        TrackingStep(status: OrderStatus.delivered, label: 'Delivered', icon: 'delivered'),
      ];
    }

    if (type == ServiceType.errand || type == ServiceType.market || type == ServiceType.queue) {
      return [
        TrackingStep(status: OrderStatus.placed, label: 'Request Placed', icon: 'placed'),
        TrackingStep(status: OrderStatus.confirmed, label: 'Agent Assigned', icon: 'confirmed'),
        TrackingStep(status: OrderStatus.processing, label: 'At Location', icon: 'processing'),
        TrackingStep(status: OrderStatus.delivered, label: 'Completed', icon: 'delivered'),
      ];
    }

    if (type == ServiceType.bill) {
      return [
        TrackingStep(status: OrderStatus.placed, label: 'Request Placed', icon: 'placed'),
        TrackingStep(status: OrderStatus.confirmed, label: 'Processing', icon: 'confirmed'),
        TrackingStep(status: OrderStatus.delivered, label: 'Payment Successful', icon: 'delivered'),
      ];
    }

    return base;
  }
}

class TrackingStep {
  final OrderStatus status;
  final String label;
  final String icon;

  const TrackingStep({
    required this.status,
    required this.label,
    required this.icon,
  });
}
