import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/animated_press.dart';
import '../widgets/cancel_reason_modal.dart';
import '../models/service_type.dart';
import '../providers/active_order_provider.dart';
import '../providers/order_history_provider.dart';
import '../providers/rider_location_provider.dart';
import 'chat_screen.dart';
import 'help_support_screen.dart';
import 'rate_review_screen.dart';

// Mock coordinates around Kumasi, Nigeria
const _pickup = LatLng(6.6884, -1.6244); // Kumasi city centre
const _rider = LatLng(6.6960, -1.6150); // Rider en route
const _destination = LatLng(6.7012, -1.6080); // Oforikrom

// ── Laundry timeline helpers ──────────────────────────────────────────────

enum _TLStatus { done, current, pending }

class _TimelineItem {
  final String label;
  final _TLStatus status;
  final bool isProcessing;
  const _TimelineItem(this.label,
      {required this.status, this.isProcessing = false});
}

// ── Screen ────────────────────────────────────────────────────────────────

class OrderTrackingScreen extends ConsumerStatefulWidget {
  final ServiceType serviceType;
  // The id of the order being tracked. When set, cancelling here actually
  // cancels that order in orderHistoryProvider (and clears it from the
  // active-order banner) instead of just showing a snackbar.
  final String? orderId;

  const OrderTrackingScreen({
    super.key,
    this.serviceType = ServiceType.food,
    this.orderId,
  });

  @override
  ConsumerState<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  bool _receiptApproved = false;
  // 0 = pickup trip, 1 = processing, 2 = return trip
  int _laundryPhase = 1;

  // ── Delivery step progression (non-laundry) ───────────────────────────
  // Steps: 0=Order confirmed, 1=Rider assigned, 2=Rider at store,
  //        3=Heading to you, 4=Delivered
  int _deliveryStep = 1;

  static const _stepLabels = [
    'Order confirmed',
    'Rider assigned',
    'Rider at store',
    'Heading to you',
    'Delivered',
  ];
  static const _stepSubtitles = [
    '10:00 AM',
    '10:15 AM',
    'Purchasing items',
    'Arriving soon',
    'Order complete!',
  ];

  void _advanceDeliveryStep() {
    if (_deliveryStep >= _stepLabels.length - 1) return;
    setState(() => _deliveryStep++);
    if (_deliveryStep == _stepLabels.length - 1) {
      // Reached "Delivered" — clear active order then show completion sheet
      final active = ref.read(activeOrderProvider);
      if (active != null) {
        ref.read(activeOrderProvider.notifier).clearOrder();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showDeliveredSheet();
      });
    }
  }

  void _showDeliveredSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(
            24, 20, 24, MediaQuery.of(context).padding.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF16A34A), size: 52),
            ),
            const SizedBox(height: 20),
            Text(
              'Order Delivered! 🎉',
              style: AppFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order has arrived. Hope you enjoy it!',
              textAlign: TextAlign.center,
              style: AppFonts.inter(
                  fontSize: 14, color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close sheet
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RateReviewScreen(
                        storeName: widget.orderId != null
                            ? 'Your Order'
                            : 'Your Order',
                        orderId: widget.orderId ?? '',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0068FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Rate Your Order',
                    style: AppFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // close sheet
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text(
                  'Back to Home',
                  style: AppFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelOrderSheet() async {
    // Ask *why* first — previously this went straight to a Keep/Cancel
    // confirmation sheet with no reason captured.
    final reason = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CancelReasonModal(),
    );
    if (reason == null || !mounted) return;
    _showCancelConfirmSheet();
  }

  void _showCancelConfirmSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(
          24, 20, 24, MediaQuery.of(context).padding.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Icon
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.cancel_outlined, color: Colors.red[600], size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              'Cancel this order?',
              style: AppFonts.inter(
                  fontSize: 20, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order is being accepted by the vendor.',
              style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Refund Policy card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Color(0xFF16A34A), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Refund Policy',
                            style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF16A34A))),
                        const SizedBox(height: 4),
                        Text(
                          'Since the vendor has accepted but not started preparing, you will receive a 100% refund to your swiftree Wallet.',
                          style: AppFonts.inter(fontSize: 12, color: const Color(0xFF166534), height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F172A),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('Keep Order', style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final orderId = widget.orderId;
                      if (orderId != null) {
                        ref.read(orderHistoryProvider.notifier).cancelOrder(orderId);
                        final active = ref.read(activeOrderProvider);
                        if (active != null && active.orderId == orderId) {
                          ref.read(activeOrderProvider.notifier).clearOrder();
                        }
                      }
                      Navigator.popUntil(context, (route) => route.isFirst);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Order cancelled. Refund sent to your Wallet.',
                              style: AppFonts.inter(color: Colors.white)),
                          backgroundColor: const Color(0xFF16A34A),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('Cancel Order',
                        style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLaundry = widget.serviceType == ServiceType.laundry;
    if (isLaundry) return _buildLaundryTrackingView();

    final bool isChatBased = false;
    final bool requiresReceipt = widget.serviceType == ServiceType.errand ||
        widget.serviceType == ServiceType.market;

    // Watch activeOrderProvider so the status card reflects live simulation
    final activeOrder = ref.watch(activeOrderProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Map or Chat Background
          if (isChatBased)
            Container(color: const Color(0xFFF1F5F9))
          else
            Positioned.fill(
              child: Builder(builder: (ctx) {
                // Watch live rider position — rebuilds only this subtree
                final riderPos = ref.watch(riderLocationProvider);
                return FlutterMap(
                  options: MapOptions(
                    initialCenter: riderPos,
                    initialZoom: 14,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'swiftree.app',
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: [_pickup, riderPos, _destination],
                          color: const Color(0xFF0068FF),
                          strokeWidth: 4,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        // Pickup marker
                        Marker(
                          point: _pickup,
                          width: 40,
                          height: 40,
                          child: Image.asset(
                            'assets/images/pickup.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Rider / driver marker — moves live
                        Marker(
                          point: riderPos,
                          width: 48,
                          height: 48,
                          child: Image.asset(
                            'assets/images/food_delivery.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Dropoff / destination marker
                        Marker(
                          point: _destination,
                          width: 40,
                          height: 40,
                          child: Image.asset(
                            'assets/images/dropoff.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),

          // Header Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white.withValues(alpha: 0.9),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x1A000000), blurRadius: 4)
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close,
                              color: Color(0xFF334155)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const Spacer(),
                      RichText(
                        text: TextSpan(
                          style: AppFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                          children: const [
                            TextSpan(text: 'Order '),
                            TextSpan(text: '#YDO-78432'),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Help + Cancel menu
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x1A000000), blurRadius: 4)
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.help_outline,
                                  color: Color(0xFF334155)),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HelpSupportScreen()),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x1A000000), blurRadius: 4)
                              ],
                            ),
                            child: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert,
                                  color: Color(0xFF334155)),
                              onSelected: (v) {
                                if (v == 'cancel') _showCancelOrderSheet();
                              },
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                  value: 'cancel',
                                  child: Row(
                                    children: [
                                      Icon(Icons.cancel_outlined,
                                          color: Colors.red, size: 20),
                                      SizedBox(width: 10),
                                      Text('Cancel Order',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (isChatBased)
            _buildChatInterface()
          else
            // Bottom Sheet
            DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.3,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 10,
                          offset: Offset(0, -4))
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Order Summary
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Color(0xFF475569)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text('Order details',
                                      style: AppFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0F172A))),
                                  Text('Items and quantities',
                                      style: AppFonts.inter(
                                          fontSize: 12,
                                          color: const Color(0xFF64748B))),
                                ],
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down,
                                color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (requiresReceipt && !_receiptApproved)
                        _buildReceiptVerification()
                      else
                        // Rider Status Card
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0068FF),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x330052CC),
                                    blurRadius: 10,
                                    offset: Offset(0, 4))
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: -32,
                                  top: -32,
                                  child: Container(
                                    width: 128,
                                    height: 128,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.05),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                              _deliveryStep == 0
                                                  ? 'CONFIRMED'
                                                  : _deliveryStep == 1
                                                      ? 'RIDER ASSIGNED'
                                                      : _deliveryStep == 2
                                                          ? 'AT STORE'
                                                          : _deliveryStep == 3
                                                              ? 'IN TRANSIT'
                                                              : 'DELIVERED',
                                              style: AppFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 0.7)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Live status from simulation or fallback to step label
                                      Text(
                                          activeOrder?.statusMessage ??
                                              (_deliveryStep == 0
                                                  ? 'Order confirmed'
                                                  : _deliveryStep == 1
                                                      ? 'Rider has been assigned'
                                                      : _deliveryStep == 2
                                                          ? 'Rider at store'
                                                          : _deliveryStep == 3
                                                              ? 'Rider heading to you'
                                                              : 'Order delivered!'),
                                          style: AppFonts.inter(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      const SizedBox(height: 4),
                                      Text(
                                          activeOrder?.eta.isNotEmpty == true
                                              ? activeOrder!.eta
                                              : (_deliveryStep == 3
                                                  ? 'Arriving in ~8 min'
                                                  : widget.serviceType.defaultEta),
                                          style: AppFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white
                                                  .withValues(alpha: 0.8))),
                                      const SizedBox(height: 16),
                                      Container(
                                          height: 1,
                                          color: Colors.white
                                              .withValues(alpha: 0.1)),
                                      const SizedBox(height: 16),
                                      Text('Service Provider',
                                          style: AppFonts.inter(
                                              fontSize: 14,
                                              color: Colors.white
                                                  .withValues(alpha: 0.8))),
                                      const SizedBox(height: 4),
                                      Text(
                                          activeOrder?.vendorName ?? 'Local Store',
                                          style: AppFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Rider Info
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: const Color(0xFFF1F5F9)),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0x0D000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 1))
                            ],
                          ),
                          child: Row(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: const Color(0x1A1E3B8A),
                                          width: 2),
                                      image: const DecorationImage(
                                          image: NetworkImage(
                                              'https://i.pravatar.cc/150?img=33'),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -2,
                                    right: -2,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF22C55E),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white,
                                              width: 2)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('Kwame A.',
                                        style: AppFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF0F172A))),
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Color(0xFFEAB308),
                                            size: 14),
                                        const SizedBox(width: 4),
                                        Text('4.8',
                                            style: AppFonts.inter(
                                                fontSize: 14,
                                                color: const Color(
                                                    0xFF64748B))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  AnimatedPress(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const ChatScreen()),
                                    ),
                                    child: _iconButton(
                                      Icons.chat_bubble_outline,
                                      const Color(0xFF1E3B8A)
                                          .withValues(alpha: 0.1),
                                      const Color(0xFF0068FF),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  AnimatedPress(
                                    onTap: () => launchUrl(Uri(
                                        scheme: 'tel',
                                        path: '+233500000000')),
                                    child: _iconButton(Icons.phone,
                                        const Color(0xFF0068FF),
                                        Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Tracking Timeline
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Phase',
                                style: AppFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF94A3B8),
                                    letterSpacing: 1.2)),
                            const SizedBox(height: 16),
                            ...List.generate(_stepLabels.length, (i) {
                              return _buildTimelineStep(
                                title: _stepLabels[i],
                                subtitle: i <= _deliveryStep
                                    ? _stepSubtitles[i]
                                    : '',
                                isCompleted: i < _deliveryStep,
                                isCurrent: i == _deliveryStep,
                                isPending: i > _deliveryStep,
                                isLast: i == _stepLabels.length - 1,
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Demo controls ─────────────────────────────
                      if (_deliveryStep < _stepLabels.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DEMO CONTROLS',
                                style: AppFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF94A3B8),
                                    letterSpacing: 1.2),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _advanceDeliveryStep,
                                  icon: const Icon(
                                      Icons.skip_next_rounded,
                                      size: 18),
                                  label: Text(
                                    'Advance to: ${_stepLabels[(_deliveryStep + 1).clamp(0, _stepLabels.length - 1)]}',
                                    style: AppFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        const Color(0xFF0068FF),
                                    side: const BorderSide(
                                        color: Color(0xFF0068FF)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ── Laundry tracking view ─────────────────────────────────────────────────

  Widget _buildLaundryTrackingView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildLaundryHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPhaseStepper(),
                  const SizedBox(height: 20),
                  _buildPhaseStatusCard(),
                  const SizedBox(height: 16),
                  _buildRiderOrVendorCard(),
                  const SizedBox(height: 20),
                  _buildLaundryTimeline(),
                  const SizedBox(height: 28),
                  _buildDemoPhaseSwitcher(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaundryHeader() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(color: Color(0x1A000000), blurRadius: 4)
                  ],
                ),
                child: IconButton(
                  icon:
                      const Icon(Icons.close, color: Color(0xFF334155)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  style: AppFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                  children: const [
                    TextSpan(text: 'Order '),
                    TextSpan(text: '#LND-78432'),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(color: Color(0x1A000000), blurRadius: 4)
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.help_outline,
                      color: Color(0xFF334155)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HelpSupportScreen()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseStepper() {
    const stepLabels = ['Pickup', 'Processing', 'Return'];
    const stepIcons = [
      Icons.local_shipping_outlined,
      Icons.local_laundry_service_outlined,
      Icons.home_outlined,
    ];

    // Generates 5 items: step, line, step, line, step (indices 0-4)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: List.generate(stepLabels.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector line — segment 0 connects step 0→1, segment 1 connects step 1→2
            final segmentIndex = index ~/ 2;
            final isComplete = _laundryPhase > segmentIndex;
            return Expanded(
              child: Container(
                height: 2,
                color: isComplete
                    ? const Color(0xFF0068FF)
                    : const Color(0xFFE2E8F0),
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final isCompleted = _laundryPhase > stepIndex;
          final isCurrent = _laundryPhase == stepIndex;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCurrent)
                // Pulse ring for current step
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0068FF).withValues(alpha: 0.15),
                  ),
                  child: Center(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF0068FF),
                      ),
                      child: Icon(stepIcons[stepIndex],
                          color: Colors.white, size: 18),
                    ),
                  ),
                )
              else
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? const Color(0xFF0068FF)
                        : const Color(0xFFE2E8F0),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check,
                          color: Colors.white, size: 18)
                      : Icon(stepIcons[stepIndex],
                          color: const Color(0xFF94A3B8), size: 18),
                ),
              const SizedBox(height: 6),
              Text(
                stepLabels[stepIndex],
                style: AppFonts.inter(
                  fontSize: 11,
                  fontWeight: (isCompleted || isCurrent)
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: (isCompleted || isCurrent)
                      ? const Color(0xFF0068FF)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPhaseStatusCard() {
    final String badge;
    final String title;
    final String subtitle;
    final String etaOrInfo;
    final bool isProcessingPhase = _laundryPhase == 1;

    switch (_laundryPhase) {
      case 0:
        badge = 'TRIP 1 — PICKUP';
        title = 'Rider heading to you';
        subtitle = 'Your rider is on the way to collect your laundry';
        etaOrInfo = 'Arriving in ~10 min';
        break;
      case 2:
        badge = 'TRIP 2 — RETURN';
        title = 'Clean laundry on the way!';
        subtitle = 'Your rider is bringing your clean clothes back';
        etaOrInfo = 'Arriving in ~15 min';
        break;
      default: // 1 — processing
        badge = 'PROCESSING';
        title = 'Your laundry is being cleaned';
        subtitle = 'Your clothes are being washed and prepared';
        etaOrInfo = 'Est. ready: Tomorrow, 2:00 PM';
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0068FF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
              color: Color(0x330052CC),
              blurRadius: 10,
              offset: Offset(0, 4))
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -32,
            top: -32,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      badge,
                      style: AppFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.85)),
                ),
                const SizedBox(height: 16),
                Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.15)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      isProcessingPhase
                          ? Icons.schedule
                          : Icons.directions_bike,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      etaOrInfo,
                      style: AppFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                if (isProcessingPhase) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.storefront_outlined,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'CleanPro Laundry',
                        style: AppFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiderOrVendorCard() {
    if (_laundryPhase == 1) {
      // Vendor card while laundry is being processed
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 4,
                offset: Offset(0, 1))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF5FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_laundry_service,
                  color: Color(0xFF0068FF), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CleanPro Laundry',
                    style: AppFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A)),
                  ),
                  Text(
                    'Processing your items',
                    style: AppFonts.inter(
                        fontSize: 13, color: const Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const HelpSupportScreen()),
              ),
              child: Text(
                'Contact Support',
                style: AppFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0068FF)),
              ),
            ),
          ],
        ),
      );
    }

    // Rider card for phases 0 (pickup) and 2 (return)
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 4,
              offset: Offset(0, 1))
        ],
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0x1A1E3B8A), width: 2),
                  image: const DecorationImage(
                      image: NetworkImage(
                          'https://i.pravatar.cc/150?img=33'),
                      fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kwame A.',
                    style: AppFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A))),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: Color(0xFFEAB308), size: 14),
                    const SizedBox(width: 4),
                    Text('4.8',
                        style: AppFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF64748B))),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              AnimatedPress(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()),
                ),
                child: _iconButton(
                  Icons.chat_bubble_outline,
                  const Color(0xFF1E3B8A).withValues(alpha: 0.1),
                  const Color(0xFF0068FF),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedPress(
                onTap: () =>
                    launchUrl(Uri(scheme: 'tel', path: '+233500000000')),
                child: _iconButton(
                    Icons.phone, const Color(0xFF0068FF), Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLaundryTimeline() {
    final List<_TimelineItem> items;

    switch (_laundryPhase) {
      case 0:
        items = const [
          _TimelineItem('Order placed', status: _TLStatus.done),
          _TimelineItem('Rider assigned', status: _TLStatus.done),
          _TimelineItem('Rider heading to you', status: _TLStatus.current),
          _TimelineItem('Items collected', status: _TLStatus.pending),
          _TimelineItem('Delivered to laundry', status: _TLStatus.pending),
          _TimelineItem('Processing', status: _TLStatus.pending),
          _TimelineItem('Ready for return', status: _TLStatus.pending),
          _TimelineItem('Delivered to you', status: _TLStatus.pending),
        ];
        break;
      case 2:
        items = const [
          _TimelineItem('Order placed', status: _TLStatus.done),
          _TimelineItem('Items collected from you', status: _TLStatus.done),
          _TimelineItem('Processed & ready', status: _TLStatus.done),
          _TimelineItem('Return rider assigned', status: _TLStatus.done),
          _TimelineItem('On the way back to you',
              status: _TLStatus.current),
          _TimelineItem('Delivered', status: _TLStatus.pending),
        ];
        break;
      default: // 1 — processing
        items = const [
          _TimelineItem('Order placed', status: _TLStatus.done),
          _TimelineItem('Rider assigned', status: _TLStatus.done),
          _TimelineItem('Items collected from you', status: _TLStatus.done),
          _TimelineItem('Delivered to laundry', status: _TLStatus.done),
          _TimelineItem('Being processed',
              status: _TLStatus.current, isProcessing: true),
          _TimelineItem('Ready for return', status: _TLStatus.pending),
          _TimelineItem('Return rider assigned', status: _TLStatus.pending),
          _TimelineItem('Delivered to you', status: _TLStatus.pending),
        ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TIMELINE',
          style: AppFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF94A3B8),
              letterSpacing: 1.2),
        ),
        const SizedBox(height: 16),
        ...List.generate(items.length, (i) {
          return _buildLaundryTimelineStep(items[i],
              isLast: i == items.length - 1);
        }),
      ],
    );
  }

  Widget _buildLaundryTimelineStep(_TimelineItem item,
      {required bool isLast}) {
    final Color dotColor;
    final Color lineColor;
    final Color titleColor;

    switch (item.status) {
      case _TLStatus.done:
        dotColor = const Color(0xFF22C55E);
        lineColor = const Color(0xFF22C55E);
        titleColor = const Color(0xFF0F172A);
        break;
      case _TLStatus.current:
        dotColor = const Color(0xFF0068FF);
        lineColor = const Color(0xFFE2E8F0);
        titleColor = const Color(0xFF0068FF);
        break;
      case _TLStatus.pending:
        dotColor = const Color(0xFF94A3B8);
        lineColor = const Color(0xFFE2E8F0);
        titleColor = const Color(0xFF94A3B8);
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: item.status == _TLStatus.current
                        ? Colors.white
                        : (item.status == _TLStatus.done
                            ? dotColor
                            : const Color(0xFFE2E8F0)),
                    shape: BoxShape.circle,
                    border: item.status == _TLStatus.current
                        ? Border.all(color: const Color(0xFF0068FF), width: 3)
                        : null,
                  ),
                  child: Center(
                    child: item.status == _TLStatus.done
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 13)
                        : (item.status == _TLStatus.current
                            ? (item.isProcessing
                                ? const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              Color(0xFF0068FF)),
                                    ),
                                  )
                                : Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFF0068FF),
                                        shape: BoxShape.circle),
                                  ))
                            : Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: dotColor,
                                    shape: BoxShape.circle),
                              )),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: lineColor),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Text(
                item.label,
                style: AppFonts.inter(
                  fontSize: 14,
                  fontWeight: item.status == _TLStatus.current
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: titleColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoPhaseSwitcher() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Demo phases:',
          style: AppFonts.inter(
              fontSize: 11, color: const Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _demoPhaseChip('Trip 1 (Pickup)', 0),
            _demoPhaseChip('Processing', 1),
            _demoPhaseChip('Trip 2 (Return)', 2),
          ],
        ),
      ],
    );
  }

  Widget _demoPhaseChip(String label, int phase) {
    final bool active = _laundryPhase == phase;
    return GestureDetector(
      onTap: () => setState(() => _laundryPhase = phase),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEFF5FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: active
                ? const Color(0xFF0068FF)
                : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          label,
          style: AppFonts.inter(
            fontSize: 11,
            fontWeight:
                active ? FontWeight.w600 : FontWeight.w400,
            color: active
                ? const Color(0xFF0068FF)
                : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  // ── Existing helpers ──────────────────────────────────────────────────────

  Widget _buildReceiptVerification() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFFECACA)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.receipt_long,
                color: Color(0xFFDC2626), size: 40),
            const SizedBox(height: 12),
            Text('Receipt Verification Required',
                style: AppFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF991B1B))),
            const SizedBox(height: 8),
            Text(
                'The rider has purchased your items. Please review the receipt and approve the final amount before they deliver.',
                textAlign: TextAlign.center,
                style: AppFonts.inter(
                    fontSize: 13, color: const Color(0xFFB91C1C))),
            const SizedBox(height: 16),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: const Center(
                  child: Icon(Icons.image,
                      color: Color(0xFFFCA5A5), size: 48)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Final Amount:',
                    style: AppFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF991B1B))),
                Text('₵145.50',
                    style: AppFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF7F1D1D))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _receiptApproved = true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Approve Final Amount',
                    style: AppFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInterface() {
    return Positioned.fill(
      top: 100,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0068FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text('SERVICE STATUS',
                    style: AppFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0)),
                const SizedBox(height: 8),
                Text('Agent in line at Bank',
                    style: AppFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('00:45:12',
                        style: AppFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 10,
                      offset: Offset(0, -5))
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text('Live Chat with Agent',
                      style: AppFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A))),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        _buildChatMessage(
                            'I have arrived at the bank.', false),
                        _buildChatMessage(
                            'Great, thanks! How long is the line?', true),
                        _buildChatMessage(
                            'There are about 5 people ahead of me. I will let you know when it is done.',
                            false),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                                color: Color(0xFF0068FF),
                                shape: BoxShape.circle),
                            child: const Icon(Icons.send,
                                color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isMe
              ? const Color(0xFF0068FF)
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isMe
                ? const Radius.circular(0)
                : const Radius.circular(16),
            bottomLeft: isMe
                ? const Radius.circular(16)
                : const Radius.circular(0),
          ),
        ),
        child: Text(
          text,
          style: AppFonts.inter(
            fontSize: 14,
            color: isMe ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    bool isCompleted = false,
    bool isCurrent = false,
    bool isPending = false,
    bool isLast = false,
  }) {
    Color dotColor;
    Color lineColor;
    Color titleColor;
    Color subtitleColor;

    if (isCompleted) {
      dotColor = const Color(0xFF22C55E);
      lineColor = const Color(0xFF22C55E);
      titleColor = const Color(0xFF0F172A);
      subtitleColor = const Color(0xFF64748B);
    } else if (isCurrent) {
      dotColor = const Color(0xFF0068FF);
      lineColor = const Color(0xFFE2E8F0);
      titleColor = const Color(0xFF0068FF);
      subtitleColor =
          const Color(0xFF1E3B8A).withValues(alpha: 0.7);
    } else {
      dotColor = const Color(0xFF94A3B8);
      lineColor = const Color(0xFFE2E8F0);
      titleColor = const Color(0xFF475569);
      subtitleColor = const Color(0xFF94A3B8);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? Colors.white
                        : (isCompleted
                            ? dotColor
                            : const Color(0xFFE2E8F0)),
                    shape: BoxShape.circle,
                    border: isCurrent
                        ? Border.all(
                            color: const Color(0x331E3B8A), width: 4)
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 14)
                        : (isCurrent
                            ? Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: dotColor,
                                    shape: BoxShape.circle))
                            : Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: dotColor,
                                    shape: BoxShape.circle))),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: lineColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: titleColor)),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: AppFonts.inter(
                          fontSize: 14, color: subtitleColor)),
                ],
                if (!isLast) const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
