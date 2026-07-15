import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../core/config/env.dart';

/// Mock rider location provider - frontend simulation.
/// TODO Backend: Replace with real-time rider location stream from backend via websocket/Firestore.
/// Backend should provide GET /orders/:id/rider-location and stream via WebSocket or Firebase.

// ── Mock route coordinates (Accra, Ghana - corrected) ───────────────────────
const _kPickup = LatLng(5.6037, -0.1870); // vendor / pickup - Accra
const _kDestination = LatLng(5.6143, -0.2050); // customer drop-off
const _kWaypoint = LatLng(5.6090, -0.1960);

// Legacy Kumasi coords kept for backward compat if needed
const _kKumasiPickup = LatLng(6.6884, -1.6244);
const _kKumasiDestination = LatLng(6.7012, -1.6080);

/// All the points the rider passes through in order
const _kRoute = [_kPickup, _kWaypoint, _kDestination];

// For Accra region
const _kAccraRoute = [_kPickup, _kWaypoint, _kDestination];

/// Rider location state with additional metadata for backend integration prep
class RiderLocationState {
  final LatLng position;
  final double? bearing; // degrees
  final double? speedKmh;
  final DateTime? lastUpdated;
  final bool isMock; // true = simulated, false = real GPS from backend

  const RiderLocationState({
    required this.position,
    this.bearing,
    this.speedKmh,
    this.lastUpdated,
    this.isMock = true,
  });

  factory RiderLocationState.mock(LatLng pos) => RiderLocationState(
        position: pos,
        lastUpdated: DateTime.now(),
        isMock: true,
      );

  factory RiderLocationState.fromBackendJson(Map<String, dynamic> json) => RiderLocationState(
        position: LatLng(
          (json['lat'] as num).toDouble(),
          (json['lng'] as num).toDouble(),
        ),
        bearing: (json['bearing'] as num?)?.toDouble(),
        speedKmh: (json['speed_kmh'] as num?)?.toDouble(),
        lastUpdated: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
        isMock: false,
      );
}

// ── Simple LatLng notifier (backward compat for existing tracking screens) ─

class RiderLocationNotifier extends Notifier<LatLng> {
  Timer? _timer;
  int _tick = 0;
  int _segmentIndex = 0;

  static const _ticksPerSegment = 20;
  static const _tickInterval = Duration(seconds: 3);

  @override
  LatLng build() => _kPickup;

  /// Kick off rider journey simulation.
  /// TODO Backend: Replace with startListeningToRealLocation(orderId)
  void startJourney() {
    _timer?.cancel();
    _tick = 0;
    _segmentIndex = 0;
    state = _kPickup;
    _timer = Timer.periodic(_tickInterval, (_) => _advance());
  }

  /// Start real-time tracking from backend (to be implemented by backend team)
  /// Should subscribe to websocket or poll GET /orders/:id/rider-location
  Future<void> startRealTracking(String orderId) async {
    // TODO Backend:
    // final wsUrl = '${Env.apiBaseUrl.replaceAll('https', 'wss')}/ws/orders/$orderId/track';
    // Connect to websocket, on message parse RiderLocationState.fromBackendJson
    // For now fallback to mock
    startJourney();
  }

  void stopRealTracking() {
    stop();
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
    final to = _kRoute[_segmentIndex + 1];

    state = LatLng(
      from.latitude + (to.latitude - from.latitude) * t,
      from.longitude + (to.longitude - from.longitude) * t,
    );

    if (_tick >= _ticksPerSegment) {
      _tick = 0;
      _segmentIndex++;
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Update position directly from backend (when real GPS arrives)
  void updatePosition(LatLng position) {
    state = position;
  }
}

final riderLocationProvider =
    NotifierProvider<RiderLocationNotifier, LatLng>(RiderLocationNotifier.new);

/// New enhanced provider with metadata - for future use
class RiderLocationMetadataNotifier extends Notifier<RiderLocationState> {
  Timer? _timer;
  @override
  RiderLocationState build() => RiderLocationState.mock(_kPickup);

  void startJourney() {
    _timer?.cancel();
    state = RiderLocationState.mock(_kPickup);
    // Use same logic as simple provider but wrapped
    int tick = 0;
    int seg = 0;
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (seg >= _kRoute.length - 1) {
        _timer?.cancel();
        state = RiderLocationState.mock(_kDestination);
        return;
      }
      tick++;
      final t = (tick / 20).clamp(0.0, 1.0);
      final from = _kRoute[seg];
      final to = _kRoute[seg + 1];
      final pos = LatLng(
        from.latitude + (to.latitude - from.latitude) * t,
        from.longitude + (to.longitude - from.longitude) * t,
      );
      state = RiderLocationState.mock(pos);
      if (tick >= 20) {
        tick = 0;
        seg++;
      }
    });
  }

  void updateFromBackend(Map<String, dynamic> json) {
    state = RiderLocationState.fromBackendJson(json);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}

final riderLocationMetadataProvider =
    NotifierProvider<RiderLocationMetadataNotifier, RiderLocationState>(
        RiderLocationMetadataNotifier.new);
