import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/service_type.dart';
import '../providers/order_history_provider.dart';
import 'checkout_screen.dart';
import 'order_detail_screen.dart';
import 'order_tracking_screen.dart';

/// "My Orders". Previously this rendered two hardcoded, static lists of
/// fake orders that never reflected anything the user actually placed, and
/// never changed when an order was cancelled. It now reads from
/// [orderHistoryProvider], the same provider `CheckoutScreen` writes to when
/// an order is placed and `OrderDetailScreen`/`OrderTrackingScreen` write to
/// when an order is cancelled.
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderHistoryProvider);
    final activeOrders = orders.where((o) => o.isActive).toList();
    final pastOrders = orders.where((o) => !o.isActive).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'My Orders',
          style: AppFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF0068FF),
              indicatorWeight: 3,
              labelColor: const Color(0xFF0068FF),
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.bold),
              unselectedLabelStyle: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Past Orders'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(activeOrders, isActive: true),
          _buildOrderList(pastOrders, isActive: false),
        ],
      ),
    );
  }

  /// Rebuilds a cart from a past order's items and jumps straight to
  /// checkout. Previously "Reorder" was a "coming soon" snackbar stub.
  void _reorder(BuildContext context, Order order) {
    if (order.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This order has no item details to reorder.', style: AppFonts.inter(color: Colors.white)),
          backgroundColor: const Color(0xFF0F172A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final cartItems = order.items
        .map((item) => CartItem(
              title: item.title,
              description: item.description,
              price: item.unitPrice,
              quantity: item.quantity,
              imageUrl: item.imageUrl,
              vendorName: order.vendorName,
            ))
        .toList();
    final subtotal = cartItems.fold(0.0, (sum, i) => sum + i.lineTotal);
    final totalItems = cartItems.fold(0, (sum, i) => sum + i.quantity);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          serviceType: order.serviceType,
          cartItems: cartItems,
          subtotal: subtotal,
          totalItems: totalItems,
          vendorName: order.vendorName,
          onPlaceOrder: () {},
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders, {required bool isActive}) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.receipt_long_outlined, size: 48, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 16),
            Text(
              'No ${isActive ? 'active' : 'past'} orders',
              style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            Text(
              'When you place an order, it will appear here.',
              style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16).copyWith(bottom: 120), // Padding for bottom nav
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isCancelled = order.status == OrderStatus.cancelled;
        final color = order.serviceType.color;
        final icon = order.serviceType.icon;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailScreen(order: order),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: color, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    order.vendorName,
                                    style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(order.id, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF64748B))),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(order.itemsSummary, style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                // Footer
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  color: isCancelled ? const Color(0xFF94A3B8) : (isActive ? const Color(0xFF0068FF) : const Color(0xFF16A34A)),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                order.status.label,
                                style: AppFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isCancelled ? const Color(0xFF64748B) : (isActive ? const Color(0xFF0068FF) : const Color(0xFF16A34A)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isActive ? order.eta : order.placedAtLabel,
                            style: AppFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                      if (isActive)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderTrackingScreen(
                                  serviceType: order.serviceType,
                                  orderId: order.id,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF1F5F9),
                            foregroundColor: const Color(0xFF0F172A),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                          ),
                          child: Text('Track', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                        )
                      else if (!isCancelled)
                        OutlinedButton(
                          onPressed: () => _reorder(context, order),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0068FF), side: const BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                          ),
                          child: Text('Reorder', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
