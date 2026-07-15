import 'package:flutter/material.dart';

enum ServiceType {
  food,
  groceries,
  market,
  pharmacy,
  parcel,
  errand,
  laundry,
  shop,
  bill,
  queue,
}

extension ServiceTypeX on ServiceType {
  /// Human-readable display label.
  String get label {
    switch (this) {
      case ServiceType.food:
        return 'Food';
      case ServiceType.groceries:
        return 'Groceries';
      case ServiceType.market:
        return 'Market';
      case ServiceType.pharmacy:
        return 'Pharmacy';
      case ServiceType.parcel:
        return 'Parcel';
      case ServiceType.errand:
        return 'Errand';
      case ServiceType.laundry:
        return 'Laundry';
      case ServiceType.shop:
        return 'Shop';
      case ServiceType.bill:
        return 'Bill Payment';
      case ServiceType.queue:
        return 'Queue Service';
    }
  }

  /// Short order-number prefix (e.g. FOD-48291).
  String get orderPrefix {
    switch (this) {
      case ServiceType.food:
        return 'FOD';
      case ServiceType.groceries:
        return 'GRC';
      case ServiceType.market:
        return 'MKT';
      case ServiceType.pharmacy:
        return 'PHR';
      case ServiceType.parcel:
        return 'PCL';
      case ServiceType.errand:
        return 'ERR';
      case ServiceType.laundry:
        return 'LND';
      case ServiceType.shop:
        return 'SHP';
      case ServiceType.bill:
        return 'BIL';
      case ServiceType.queue:
        return 'QUE';
    }
  }

  /// Representative icon for UI tiles.
  IconData get icon {
    switch (this) {
      case ServiceType.food:
        return Icons.restaurant_rounded;
      case ServiceType.groceries:
        return Icons.local_grocery_store_rounded;
      case ServiceType.market:
        return Icons.storefront_rounded;
      case ServiceType.pharmacy:
        return Icons.local_pharmacy_rounded;
      case ServiceType.parcel:
        return Icons.inventory_2_rounded;
      case ServiceType.errand:
        return Icons.directions_run_rounded;
      case ServiceType.laundry:
        return Icons.local_laundry_service_rounded;
      case ServiceType.shop:
        return Icons.shopping_bag_rounded;
      case ServiceType.bill:
        return Icons.receipt_long_rounded;
      case ServiceType.queue:
        return Icons.people_alt_rounded;
    }
  }

  /// Brand accent colour for each service type.
  Color get color {
    switch (this) {
      case ServiceType.food:
        return const Color(0xFF0068FF);
      case ServiceType.groceries:
        return const Color(0xFF00A86B);
      case ServiceType.market:
        return const Color(0xFFFF6B35);
      case ServiceType.pharmacy:
        return const Color(0xFF9B59B6);
      case ServiceType.parcel:
        return const Color(0xFF27AE60);
      case ServiceType.errand:
        return const Color(0xFFE74C3C);
      case ServiceType.laundry:
        return const Color(0xFF3498DB);
      case ServiceType.shop:
        return const Color(0xFFE67E22);
      case ServiceType.bill:
        return const Color(0xFF6366F1);
      case ServiceType.queue:
        return const Color(0xFF0EA5E9);
    }
  }

  /// Whether this service uses a chat-style tracking UI.
  bool get isChatBased => false;

  /// Whether an agent must verify a receipt before completion.
  bool get requiresReceipt =>
      this == ServiceType.errand || this == ServiceType.market;

  /// Whether this is an agent/errand-based service (no restaurant flow).
  bool get isAgentBased =>
      this == ServiceType.errand ||
      this == ServiceType.market ||
      this == ServiceType.queue;

  /// Default post-checkout status message shown on the confirmation screen
  /// and the home-screen active-order banner, before any real-time status
  /// update arrives.
  String get defaultStatusMessage {
    switch (this) {
      case ServiceType.food:
        return 'Your order is being prepared';
      case ServiceType.groceries:
        return 'Your order is being picked';
      case ServiceType.shop:
        return 'Your order is being packed';
      case ServiceType.pharmacy:
        return 'Pharmacist is preparing your items';
      case ServiceType.laundry:
        return 'Rider on the way for pickup';
      case ServiceType.errand:
        return 'Agent heading to location';
      case ServiceType.market:
        return 'Agent heading to the market';
      case ServiceType.parcel:
        return 'Rider assigned for pickup';
      case ServiceType.bill:
        return 'Payment is being processed';
      case ServiceType.queue:
        return 'Agent heading to join the queue';
    }
  }

  /// Default estimated time shown until a real rider/vendor ETA is known.
  String get defaultEta {
    switch (this) {
      case ServiceType.food:
        return 'Est. 20-30 mins';
      case ServiceType.groceries:
        return 'Est. 30-45 mins';
      case ServiceType.shop:
        return 'Est. 30-45 mins';
      case ServiceType.pharmacy:
        return 'Est. 20-30 mins';
      case ServiceType.laundry:
        return 'Ready in 24-48 hrs';
      case ServiceType.errand:
        return 'Est. 30-45 mins';
      case ServiceType.market:
        return 'Est. 45-60 mins';
      case ServiceType.parcel:
        return 'Est. same-day';
      case ServiceType.bill:
        return 'Est. 5-10 mins';
      case ServiceType.queue:
        return 'Est. 1-2 hours';
    }
  }

  /// Serialize to JSON string.
  String toJson() => name;

  /// Deserialize from a JSON string; falls back to [ServiceType.food].
  static ServiceType fromString(String value) {
    return ServiceType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ServiceType.food,
    );
  }
}
