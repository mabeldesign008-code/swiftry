import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

// ── Mock route coordinates (Kumasi, Nigeria) ────────────────────────────────
// These match the static coordinates already used in order_tracking_screen.dart
const _kPickup      = LatLng(6.6884, -1.6244); // vendor / pickup
const _kDestination = LatLng(6.7012, -1.6080); // customer drop-off

// Intermediate waypoint to make the route feel realistic
const _kWaypoint    = LatLng(6.6960, -1.6150);

/// All the points the rider passes through in order
const _kRoute = [_kPickup, _kWaypoint, _kDestination];

// ── Notifier ──────────────────────────────────────────────────────────────

class RiderLocationNotifier extends Notifier<LatLng> {
  Timer? _timer;
  int _tick = 0;
  int _segmentIndex = 0;        // which segment of _kRoute we're on

  // How many ticks per route segment — feel free to tune
  static const _ticksPerSegment = 20;
  static const _tickInterval = Duration(seconds: 3);

  @override
  LatLng build() => _kPickup; // start at vendor

  /// Kick off (or restart) the rider journey from pickup to destination.
  void startJourney() {
    _timer?.cancel();
    _tick = 0;
    _segmentIndex = 0;
    state = _kPickup;

    _timer = Timer.periodic(_tickInterval, (_) => _advance());
  }

  void _advance() {
    if (_segmentIndex >= _kRoute.length - 1) {
      _timer?.cancel();
      state = _kDestination;
      return;
    }

    _tick++;
    final t = (_tick / _ticksPerSegment).clamp(0.0, 1.0);
    final from = _kRoute[_segmentIndex];
    final to   = _kRoute[_segmentIndex + 1];

    state = LatLng(
      from.latitude  + (to.latitude  - from.latitude)  * t,
      from.longitude + (to.longitude - from.longitude) * t,
    );

    if (_tick >= _ticksPerSegment) {
      _tick = 0;
      _segmentIndex++;
    }
  }

  /// Stop the journey (e.g. on order cancellation).
  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}

final riderLocationProvider =
    NotifierProvider<RiderLocationNotifier, LatLng>(RiderLocationNotifier.new);
