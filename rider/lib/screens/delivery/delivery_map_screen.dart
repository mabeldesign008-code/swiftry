import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../models/order.dart';
import '../../providers/rider_provider.dart';
import 'delivery_proof_screen.dart';

/// Rider delivery map - shows pickup -> dropoff with stage progression
/// Frontend mock with flutter_map OSM, ready for backend real-time tracking

class DeliveryMapScreen extends ConsumerStatefulWidget {
  final RiderOrder order;

  const DeliveryMapScreen({super.key, required this.order});

  @override
  ConsumerState<DeliveryMapScreen> createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends ConsumerState<DeliveryMapScreen> {
  OrderStatus _status = OrderStatus.headingToPickup;
  late RiderOrder _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    _status = _order.status;
  }

  String get _stageLabel {
    switch (_status) {
      case OrderStatus.headingToPickup: return 'Heading to Pickup';
      case OrderStatus.arrivedAtPickup: return 'Arrived at Pickup';
      case OrderStatus.pickedUp: return 'Picked Up • Heading to Customer';
      case OrderStatus.headingToDropoff: return 'Heading to Customer';
      case OrderStatus.arrivedAtDropoff: return 'Arrived at Customer';
      default: return _status.label;
    }
  }

  String get _actionLabel {
    switch (_status) {
      case OrderStatus.headingToPickup: return 'Arrived at ${widget.order.vendorName}';
      case OrderStatus.arrivedAtPickup: return 'Confirm Pickup';
      case OrderStatus.pickedUp: return 'Heading to Customer';
      case OrderStatus.headingToDropoff: return 'Arrived at Customer';
      case OrderStatus.arrivedAtDropoff: return 'Complete Delivery';
      default: return 'Update Status';
    }
  }

  void _nextStage() {
    OrderStatus next;
    switch (_status) {
      case OrderStatus.headingToPickup: next = OrderStatus.arrivedAtPickup; break;
      case OrderStatus.arrivedAtPickup: next = OrderStatus.pickedUp; break;
      case OrderStatus.pickedUp: next = OrderStatus.headingToDropoff; break;
      case OrderStatus.headingToDropoff: next = OrderStatus.arrivedAtDropoff; break;
      case OrderStatus.arrivedAtDropoff:
        // Go to proof screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DeliveryProofScreen(order: _order.copyWith(status: OrderStatus.arrivedAtDropoff))));
        return;
      default: next = OrderStatus.delivered;
    }
    setState(() => _status = next);
    ref.read(riderOrdersProvider.notifier).updateStatus(_order.id, next);
    // TODO Backend: POST /rider/orders/:id/stage {stage, lat, lng, timestamp}
  }

  @override
  Widget build(BuildContext context) {
    final isPickupPhase = _status == OrderStatus.headingToPickup || _status == OrderStatus.arrivedAtPickup;
    final targetLatLng = isPickupPhase ? LatLng(_order.vendorLat, _order.vendorLng) : LatLng(_order.customerLat, _order.customerLng);
    final targetName = isPickupPhase ? _order.vendorName : _order.customerName;
    final targetAddress = isPickupPhase ? _order.vendorAddress : _order.customerAddress;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(initialCenter: targetLatLng, initialZoom: 14),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'swiftree.rider'),
              MarkerLayer(
                markers: [
                  Marker(point: LatLng(_order.vendorLat, _order.vendorLng), width: 40, height: 40, child: const Icon(Icons.store, color: AppColors.primary, size: 36)),
                  Marker(point: LatLng(_order.customerLat, _order.customerLng), width: 40, height: 40, child: const Icon(Icons.location_on, color: AppColors.error, size: 36)),
                  Marker(point: const LatLng(5.6080, -0.1900), width: 50, height: 50, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)), child: const Icon(Icons.delivery_dining, color: Colors.white, size: 24))),
                ],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(points: [LatLng(_order.vendorLat, _order.vendorLng), LatLng(_order.customerLat, _order.customerLng)], color: AppColors.primary, strokeWidth: 4),
                ],
              ),
            ],
          ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(6)), child: Text(_stageLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary))),
                      const Spacer(),
                      Text(_order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(targetName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(targetAddress, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(isPickupPhase ? _order.customerName : _order.customerName, style: const TextStyle(fontSize: 12)),
                      const Spacer(),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: AppColors.primary)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.message, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildTimelineStep('Pickup', isPickupPhase ? 2 : 3),
                      Expanded(child: Container(height: 2, color: isPickupPhase ? AppColors.border : AppColors.success)),
                      _buildTimelineStep('On the way', _status == OrderStatus.headingToDropoff ? 2 : (_status.index > OrderStatus.headingToDropoff.index ? 3 : 1)),
                      Expanded(child: Container(height: 2, color: _status == OrderStatus.arrivedAtDropoff ? AppColors.success : AppColors.border)),
                      _buildTimelineStep('Delivered', _status == OrderStatus.delivered ? 3 : 1),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_order.specialInstructions != null) ...[
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondaryLight, borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.info, size: 16), const SizedBox(width: 6), Expanded(child: Text(_order.specialInstructions!, style: const TextStyle(fontSize: 12)))])),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextStage,
                      child: Text(_actionLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(onPressed: () => _showIssueSheet(context), child: const Text('Report Issue', style: TextStyle(color: AppColors.error))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String label, int state) {
    // state 1 = future, 2 = current, 3 = done
    Color color = state == 1 ? AppColors.border : (state == 2 ? AppColors.primary : AppColors.success);
    return Column(
      children: [
        Container(width: 24, height: 24, decoration: BoxDecoration(color: color, shape: BoxShape.circle), child: Icon(state == 3 ? Icons.check : Icons.circle, size: 12, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: state == 1 ? AppColors.textTertiary : AppColors.textPrimary, fontWeight: state == 2 ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  void _showIssueSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Report Issue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            ...['Customer not reachable', 'Wrong address', 'Road blocked', 'Order damaged'].map((e) => ListTile(title: Text(e), onTap: () => Navigator.pop(context))),
          ],
        ),
      ),
    );
  }
}
