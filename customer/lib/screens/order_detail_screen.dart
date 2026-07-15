import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/order.dart';
import '../models/service_type.dart';
import '../widgets/address_modal.dart';
import '../widgets/cancel_reason_modal.dart';
import '../providers/active_order_provider.dart';
import '../providers/order_history_provider.dart';
import 'order_tracking_screen.dart';
import 'chat_screen.dart';
import 'rate_review_screen.dart';
import 'help_support_screen.dart';
import 'report_issue_screen.dart';

/// Order details. Previously this screen ignored the [order] map it was
/// given for anything beyond id/store/status/time/type — items, address,
/// and the price breakdown were all hardcoded mock values, so the total
/// shown here would routinely contradict the total shown on the order list
/// tile for the very same order. It now renders everything from the real
/// [Order] placed at checkout, and reads the live copy from
/// [orderHistoryProvider] so a cancellation made from `OrderTrackingScreen`
/// (or vice versa) is reflected immediately.
class OrderDetailScreen extends ConsumerStatefulWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  bool _isCancelling = false;

  // ── Status helpers ──────────────────────────────────────────────────────

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.inTransit:
        return const Color(0xFF0068FF);
      case OrderStatus.processing:
        return const Color(0xFFEA580C);
      case OrderStatus.delivered:
        return const Color(0xFF16A34A);
      case OrderStatus.cancelled:
        return const Color(0xFF64748B);
      case OrderStatus.placed:
      case OrderStatus.confirmed:
        return const Color(0xFF0068FF);
    }
  }

  Color _statusBg(OrderStatus status) {
    switch (status) {
      case OrderStatus.inTransit:
        return const Color(0xFFEFF6FF);
      case OrderStatus.processing:
        return const Color(0xFFFFF7ED);
      case OrderStatus.delivered:
        return const Color(0xFFF0FDF4);
      case OrderStatus.cancelled:
        return const Color(0xFFF1F5F9);
      case OrderStatus.placed:
      case OrderStatus.confirmed:
        return const Color(0xFFEFF6FF);
    }
  }

  /// Number of fully-completed steps (0–4).
  /// The step at index == completedSteps is the current/active one.
  int _progressStep(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return 4; // all done
      case OrderStatus.inTransit:
        return 2;
      case OrderStatus.processing:
        return 1;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.cancelled:
        return 1;
      case OrderStatus.placed:
        return 0;
    }
  }

  // ── Reusable card wrapper ────────────────────────────────────────────────

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: AppFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0F172A),
        ),
      );

  // ── Section 1: Order header card ─────────────────────────────────────────

  Widget _buildHeaderCard(Order order) {
    final isHomeDelivery = order.serviceType != ServiceType.shop;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID + status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: AppFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _statusBg(order.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status.label,
                  style: AppFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(order.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Vendor name
          Text(
            order.vendorName,
            style: AppFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),
          // Date/time
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 15, color: Color(0xFF94A3B8)),
              const SizedBox(width: 8),
              Text(
                order.placedAtLabel,
                style: AppFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Delivery type
          Row(
            children: [
              Icon(
                isHomeDelivery
                    ? Icons.delivery_dining_outlined
                    : Icons.store_outlined,
                size: 15,
                color: const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 8),
              Text(
                isHomeDelivery ? 'Home Delivery' : 'Pickup',
                style: AppFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Section 2: Progress timeline ─────────────────────────────────────────

  Widget _buildTimeline(Order order) {
    final completedSteps = _progressStep(order.status);
    final isDelivered = order.status == OrderStatus.delivered;

    // Estimated timestamps derived from when the order was actually placed,
    // instead of a fixed '2:28 PM' shown for every single order regardless
    // of when it was placed.
    String at(Duration offset) => _fmtTime(order.placedAt.add(offset));

    final steps = <Map<String, String>>[
      {'title': 'Order Placed', 'subtitle': at(Duration.zero)},
      {'title': 'Confirmed', 'subtitle': at(const Duration(minutes: 5))},
      {'title': 'In Transit', 'subtitle': at(const Duration(minutes: 12))},
      {'title': 'Delivered', 'subtitle': isDelivered ? at(const Duration(minutes: 30)) : 'Est. ${order.eta}'},
    ];

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Order Progress'),
          const SizedBox(height: 16),
          ...List.generate(steps.length, (i) {
            final isDone = i < completedSteps;
            final isCurrent = !isDelivered && i == completedSteps;
            final isFuture = !isDone && !isCurrent;
            return _timelineStep(
              title: steps[i]['title']!,
              subtitle: steps[i]['subtitle']!,
              isDone: isDone,
              isCurrent: isCurrent,
              isFuture: isFuture,
              isLast: i == steps.length - 1,
            );
          }),
        ],
      ),
    );
  }

  String _fmtTime(DateTime dt) {
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour12:$minute $ampm';
  }

  Widget _timelineStep({
    required String title,
    required String subtitle,
    required bool isDone,
    required bool isCurrent,
    required bool isFuture,
    required bool isLast,
  }) {
    const blue = Color(0xFF0068FF);
    const grey = Color(0xFFCBD5E1);

    Widget dot;
    if (isDone) {
      dot = Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(color: blue, shape: BoxShape.circle),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 13),
      );
    } else if (isCurrent) {
      // Blue ring with inner filled dot
      dot = Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: blue, width: 2.5),
        ),
        child: Center(
          child: Container(
            width: 9,
            height: 9,
            decoration: const BoxDecoration(color: blue, shape: BoxShape.circle),
          ),
        ),
      );
    } else {
      // Future step — empty grey ring
      dot = Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: grey, width: 2),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column: dot + connector line
        SizedBox(
          width: 22,
          child: Column(
            children: [
              dot,
              if (!isLast)
                Container(
                  width: 2,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDone ? blue : grey,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.inter(
                    fontSize: 14,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                    color: isFuture
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppFonts.inter(
                    fontSize: 12,
                    color: isFuture
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Section 3: Items ordered ─────────────────────────────────────────────

  Widget _buildItemsCard(Order order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Items Ordered'),
          const SizedBox(height: 12),
          if (order.items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'No item details available for this order.',
                style: AppFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
              ),
            )
          else
            ...order.items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              return Column(
                children: [
                  if (i != 0)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0068FF),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${item.title} x${item.quantity}',
                                style: AppFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF0F172A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₵${item.lineTotal.toStringAsFixed(2)}',
                        style: AppFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
        ],
      ),
    );
  }

  // ── Section 4: Delivery address ──────────────────────────────────────────

  Widget _buildAddressCard(BuildContext context, Order order) {
    final address = order.address;
    final line1 = address.type.isNotEmpty ? address.type : 'Address';
    final line2 = address.street.isNotEmpty ? address.street : address.displayLabel;

    return _card(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.home_outlined, color: Color(0xFF0068FF), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line1,
                  style: AppFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  line2,
                  style: AppFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              final result = await showModalBottomSheet<Address>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => AddressModal(initial: address),
              );
              if (result != null) {
                ref.read(orderHistoryProvider.notifier).updateAddress(order.id, result);
              }
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Change',
              style: AppFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0068FF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section 5: Price breakdown ───────────────────────────────────────────

  Widget _buildPriceBreakdown(Order order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Price Breakdown'),
          const SizedBox(height: 14),
          _priceRow('Subtotal', order.subtotal),
          const SizedBox(height: 10),
          _priceRow('Delivery Fee', order.deliveryFee),
          if (order.returnDeliveryFee > 0) ...[
            const SizedBox(height: 10),
            _priceRow('Return Delivery Fee', order.returnDeliveryFee),
          ],
          const SizedBox(height: 10),
          _priceRow('Service Fee', order.serviceFee),
          if (order.discount > 0) ...[
            const SizedBox(height: 10),
            _priceRow('Discount', -order.discount, valueColor: const Color(0xFF16A34A)),
          ],
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 14),
          _priceRow('Total', order.total, isBold: true),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double amount, {bool isBold = false, Color? valueColor}) {
    final formatted = amount < 0
        ? '-₵${(-amount).toStringAsFixed(2)}'
        : '₵${amount.toStringAsFixed(2)}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppFonts.inter(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
            color: isBold ? const Color(0xFF0F172A) : const Color(0xFF64748B),
          ),
        ),
        Text(
          formatted,
          style: AppFonts.inter(
            fontSize: isBold ? 15 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  // ── Section 6: Rider info (active orders only) ───────────────────────────

  Widget _buildRiderCard(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Your Rider'),
          const SizedBox(height: 14),
          Row(
            children: [
              // Avatar
              const CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage('assets/images/user_placeholder.png'),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kofi Mensah',
                      style: AppFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF59E0B),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '4.8',
                          style: AppFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '• 231 deliveries',
                          style: AppFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Chat — outlined blue
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatScreen()),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 17),
                  label: Text(
                    'Chat',
                    style: AppFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0068FF),
                    side: const BorderSide(color: Color(0xFF0068FF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Call — filled blue
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final uri = Uri(scheme: 'tel', path: '+233500000000');
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                  icon: const Icon(Icons.phone_outlined, size: 17),
                  label: Text(
                    'Call',
                    style: AppFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0068FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── AppBar ───────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context, Order order) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Order Details',
        style: AppFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0F172A),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.flag_outlined, color: Color(0xFF64748B)),
          tooltip: 'Report an issue',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ReportIssueScreen(order: order)),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.help_outline_rounded, color: Color(0xFF64748B)),
          tooltip: 'Help',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: const Color(0xFFE2E8F0), height: 1.0),
      ),
    );
  }

  // ── Cancel flow ──────────────────────────────────────────────────────────

  void _showCancelDialog(BuildContext context, Order order) async {
    // Ask *why* first — previously this went straight to Yes/No with no
    // reason captured at all.
    final reason = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CancelReasonModal(),
    );
    if (reason == null || !context.mounted) return;

    final isPenalty = order.status == OrderStatus.processing;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isPenalty ? 'Cancel with penalty?' : 'Cancel this order?',
          style: AppFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPenalty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFEA580C), size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    'The vendor has already started preparing your order. A 50% cancellation fee applies.',
                    style: AppFonts.inter(fontSize: 13, color: const Color(0xFF92400E)),
                  )),
                ]),
              ),
              const SizedBox(height: 12),
              Text('You will receive a 50% refund to your swiftree Wallet.', style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B))),
            ] else
              Text('Your order will be cancelled and you\'ll receive a full refund to your swiftree Wallet within a few minutes.', style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Keep Order', style: AppFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _onConfirmCancel(context, order);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(isPenalty ? 'Cancel Anyway' : 'Yes, Cancel', style: AppFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _onConfirmCancel(BuildContext context, Order order) async {
    setState(() => _isCancelling = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    // Actually cancel the order — previously this only showed a snackbar
    // and popped, with no state change anywhere.
    ref.read(orderHistoryProvider.notifier).cancelOrder(order.id);
    final active = ref.read(activeOrderProvider);
    if (active != null && active.orderId == order.id) {
      ref.read(activeOrderProvider.notifier).clearOrder();
    }

    setState(() => _isCancelling = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order cancelled. Refund processing...', style: AppFonts.inter(color: Colors.white)),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
    Navigator.pop(context);
  }

  // ── Bottom action bar ────────────────────────────────────────────────────

  Widget _buildBottomBar(BuildContext context, Order order, bool isActive) {
    final isCancelled = order.status == OrderStatus.cancelled;

    // Cancelled orders — show an informational bar instead of an action button
    if (isCancelled) {
      return SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'This order was cancelled',
              textAlign: TextAlign.center,
              style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF64748B)),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (isActive) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderTrackingScreen(
                          serviceType: order.serviceType,
                          orderId: order.id,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RateReviewScreen(
                          storeName: order.vendorName,
                          orderId: order.id,
                          storeIcon: order.serviceType.icon,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0068FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isActive ? 'Track Order' : 'Rate Order',
                  style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            // Cancel link — only shown when order can be cancelled
            if (isActive && order.status != OrderStatus.inTransit) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: _isCancelling
                  ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                  : TextButton(
                      onPressed: () => _showCancelDialog(context, order),
                      child: Text('Cancel Order', style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFEF4444))),
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Read the live copy from history so a cancellation/address change made
    // elsewhere (e.g. from OrderTrackingScreen) is reflected here too.
    final orders = ref.watch(orderHistoryProvider);
    final order = orders.firstWhere(
      (o) => o.id == widget.order.id,
      orElse: () => widget.order,
    );
    final bool isActive = order.isActive;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(context, order),
      bottomNavigationBar: _buildBottomBar(context, order, isActive),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(order),
            const SizedBox(height: 12),
            _buildTimeline(order),
            const SizedBox(height: 12),
            _buildItemsCard(order),
            const SizedBox(height: 12),
            _buildAddressCard(context, order),
            const SizedBox(height: 12),
            _buildPriceBreakdown(order),
            if (isActive) ...[
              const SizedBox(height: 12),
              _buildRiderCard(context),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
