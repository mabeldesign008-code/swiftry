import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/rider_provider.dart';
import '../../models/order.dart';
import '../delivery/delivery_map_screen.dart';
import '../orders/orders_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    final rider = ref.watch(riderProvider);
    final orders = ref.watch(riderOrdersProvider);
    final incoming = orders.where((o) => o.status == OrderStatus.assigned).toList();
    final active = orders.where((o) => o.status != OrderStatus.assigned && !o.status.isTerminal).toList();
    final earnings = ref.watch(earningsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, ${rider?.name ?? 'Rider'}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(rider?.vehicleType.toUpperCase() ?? 'MOTOR • ACCRA', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Online toggle + earnings
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(color: _isOnline ? AppColors.online : AppColors.offline, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Text(_isOnline ? 'You are ONLINE' : 'You are OFFLINE', style: TextStyle(fontWeight: FontWeight.bold, color: _isOnline ? AppColors.online : AppColors.offline)),
                      ],
                    ),
                    Switch(
                      value: _isOnline,
                      activeColor: AppColors.online,
                      onChanged: (val) {
                        setState(() => _isOnline = val);
                        ref.read(riderProvider.notifier).setOnline(val);
                        // TODO Backend: POST /rider/availability
                      },
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat('Today', '₵${earnings.today.toStringAsFixed(0)}', '${earnings.deliveriesToday} deliveries'),
                    _stat('Week', '₵${earnings.thisWeek.toStringAsFixed(0)}', 'This week'),
                    _stat('Balance', '₵${earnings.balance.toStringAsFixed(0)}', 'Withdraw'),
                  ],
                ),
              ],
            ),
          ),

          // Active delivery banner
          if (active.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary.withOpacity(0.2))),
              child: Row(
                children: [
                  const Icon(Icons.delivery_dining, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(child: Text('${active.length} active delivery${active.length > 1 ? 'ies' : ''} - Tap to view', style: const TextStyle(fontWeight: FontWeight.w600))),
                  TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersListScreen(initialTab: 1))), child: const Text('View')),
                ],
              ),
            ),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Incoming Requests (${incoming.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (!_isOnline) const Text('Go online to receive', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: !_isOnline
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.power_settings_new, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text('You are offline', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Text('Toggle online to get orders'),
                      ],
                    ),
                  )
                : incoming.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            const Text('No incoming orders', style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text('Wait for new requests'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: incoming.length,
                        itemBuilder: (context, i) {
                          final order = incoming[i];
                          return _incomingCard(order);
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (idx) {
          if (idx == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersListScreen()));
          if (idx == 2) _showWallet(context);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Earnings'),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, String sub) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.textTertiary)),
      ],
    );
  }

  Widget _incomingCard(RiderOrder order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _serviceColor(order.serviceType).withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text(order.serviceType.name.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _serviceColor(order.serviceType)))),
              Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.store, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(child: Text(order.vendorName, style: const TextStyle(fontWeight: FontWeight.w600))),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(child: Text(order.vendorAddress, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('₵${order.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 4),
          Text(order.customerAddress, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () => ref.read(riderOrdersProvider.notifier).rejectOrder(order.id), child: const Text('Reject'))),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: ElevatedButton(onPressed: () {
                ref.read(riderOrdersProvider.notifier).acceptOrder(order.id);
                Navigator.push(context, MaterialPageRoute(builder: (_) => DeliveryMapScreen(order: order.copyWith(status: OrderStatus.headingToPickup))));
              }, child: Text('Accept • Earn ₵${order.riderEarning.toStringAsFixed(0)}'))),
            ],
          ),
        ],
      ),
    );
  }

  Color _serviceColor(ServiceType type) {
    switch (type) {
      case ServiceType.food: return const Color(0xFF0068FF);
      case ServiceType.parcel: return const Color(0xFF27AE60);
      case ServiceType.laundry: return const Color(0xFF3498DB);
      default: return AppColors.primary;
    }
  }

  void _showWallet(BuildContext context) {
    final earnings = ref.read(earningsProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Earnings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Balance: ₵${earnings.balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('Withdraw'))),
          ],
        ),
      ),
    );
  }
}
