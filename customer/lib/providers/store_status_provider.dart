import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Enum ──────────────────────────────────────────────────────────────────

enum StoreStatus { open, closingSoon, closed }

extension StoreStatusX on StoreStatus {
  String get label {
    switch (this) {
      case StoreStatus.open:        return 'Open';
      case StoreStatus.closingSoon: return 'Closing Soon';
      case StoreStatus.closed:      return 'Closed';
    }
  }

  Color get color {
    switch (this) {
      case StoreStatus.open:        return const Color(0xFF16A34A);
      case StoreStatus.closingSoon: return const Color(0xFFD97706);
      case StoreStatus.closed:      return const Color(0xFFDC2626);
    }
  }

  Color get bgColor {
    switch (this) {
      case StoreStatus.open:        return const Color(0xFFDCFCE7);
      case StoreStatus.closingSoon: return const Color(0xFFFEF3C7);
      case StoreStatus.closed:      return const Color(0xFFFEE2E2);
    }
  }

  IconData get icon {
    switch (this) {
      case StoreStatus.open:        return Icons.check_circle_outline_rounded;
      case StoreStatus.closingSoon: return Icons.schedule_rounded;
      case StoreStatus.closed:      return Icons.cancel_outlined;
    }
  }

  bool get isOrderable => this != StoreStatus.closed;
}

// ── Operating hours config ────────────────────────────────────────────────
// (openHour, closeHour) in 24-hour local time.

const Map<String, ({int open, int close})> _kVendorHours = {
  // Food
  'papaye':              (open: 7,  close: 22),
  'papaye fast food':    (open: 7,  close: 22),
  'kfc':                 (open: 9,  close: 23),
  'burger king':         (open: 9,  close: 22),
  'breakfo':             (open: 6,  close: 18),  // closes early
  'pizza hut':           (open: 11, close: 23),
  'nana\'s kitchen':     (open: 8,  close: 21),
  // Groceries / Shop
  'maxmart supermarket': (open: 7,  close: 22),
  'shoprite - osu':      (open: 8,  close: 22),
  'melcom shopping centre': (open: 9, close: 21),
  'tech hub Nigeria':      (open: 9,  close: 20),
  'kantanka fashion':    (open: 10, close: 21),
  'beauty palace':       (open: 9,  close: 20),
  // Laundry
  'cleanpro laundry':    (open: 7,  close: 19),
  'sparkle wash':        (open: 6,  close: 20),
  'fresh & clean':       (open: 8,  close: 18),  // closes early
  'laundroking':         (open: 7,  close: 21),
  // Pharmacy
  'ernest chemists':     (open: 7,  close: 22),
  'kinapharma pharmacy': (open: 8,  close: 21),
  'alliance pharma':     (open: 8,  close: 22),
  'oncat':               (open: 8,  close: 21),
  'pharmco':             (open: 8,  close: 22),
};

// Default hours for unknown vendors
const _kDefaultHours = (open: 8, close: 22);

// ── Pure calculation (no state needed) ───────────────────────────────────

StoreStatus computeStoreStatus(String vendorName, DateTime now) {
  final key = vendorName.toLowerCase().trim();
  final hours = _kVendorHours[key] ?? _kDefaultHours;
  final currentMinutes = now.hour * 60 + now.minute;
  final openMinutes  = hours.open  * 60;
  final closeMinutes = hours.close * 60;

  if (currentMinutes < openMinutes || currentMinutes >= closeMinutes) {
    return StoreStatus.closed;
  }
  // Within 30 minutes of closing
  if (closeMinutes - currentMinutes <= 30) {
    return StoreStatus.closingSoon;
  }
  return StoreStatus.open;
}

/// Returns a human-readable next-open string, e.g. "Opens at 9:00 AM"
String nextOpenLabel(String vendorName) {
  final key = vendorName.toLowerCase().trim();
  final hours = _kVendorHours[key] ?? _kDefaultHours;
  final h = hours.open;
  final ampm = h >= 12 ? 'PM' : 'AM';
  final hour12 = h % 12 == 0 ? 12 : h % 12;
  return 'Opens at $hour12:00 $ampm';
}

// ── Clock provider (ticks every minute) ──────────────────────────────────

class _ClockNotifier extends Notifier<DateTime> {
  Timer? _timer;

  @override
  DateTime build() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      state = DateTime.now();
    });
    return DateTime.now();
  }
}

/// Ticks every minute. Consumers watch this to get live store status.
final clockProvider =
    NotifierProvider<_ClockNotifier, DateTime>(_ClockNotifier.new);

// ── Per-vendor derived provider ───────────────────────────────────────────

/// Returns the current [StoreStatus] for a given vendor name.
/// Rebuilds automatically every minute (driven by [clockProvider]).
final storeStatusProvider =
    Provider.family<StoreStatus, String>((ref, vendorName) {
  final now = ref.watch(clockProvider);
  return computeStoreStatus(vendorName, now);
});
