import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/rider_provider.dart';
import '../../models/order.dart';
import '../delivery/delivery_map_screen.dart';

class OrdersListScreen extends ConsumerStatefulWidget {
  final int initialTab;
  const OrdersListScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends ConsumerState<OrdersListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(riderOrdersProvider);
    final incoming = orders.where((o) => o.status == OrderStatus.assigned).toList();
    final active = orders.where((o) => o.status != OrderStatus.assigned && !o.status.isTerminal).toList();
    final delivered = orders.where((o) => o.status.isTerminal).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Deliveries'),
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(text: 'Incoming (${incoming.length})'),
          Tab(text: 'Active (${active.length})'),
          Tab(text: 'History (${delivered.length})'),
        ]),
      ),
      body: TabBarView(controller: _tabController, children: [
        _buildList(incoming, true),
        _buildList(active, false),
        _buildList(delivered, false, isHistory: true),
      ]),
    );
  }

  Widget _buildList(List<RiderOrder> list, bool isIncoming, {bool isHistory = false}) {
    if (list.isEmpty) {
      return Center(child: Text(isHistory ? 'No history yet' : 'No ${isIncoming ? 'incoming' : 'active'} orders'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final order = list[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: _serviceColor(order.serviceType).withOpacity(0.1), child: Icon(_serviceIcon(order.serviceType), color: _serviceColor(order.serviceType))),
            title: Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${order.vendorName} → ${order.customerName}\n${order.status.label}', style: const TextStyle(fontSize: 12)),
            trailing: Text('₵${order.riderEarning.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            onTap: isIncoming ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => DeliveryMapScreen(order: order))),
          ),
        );
      },
    );
  }

  Color _serviceColor(ServiceType t) {
    switch (t) {
      case ServiceType.food: return AppColors.primary;
      case ServiceType.parcel: return AppColors.success;
      default: return AppColors.primary;
    }
  }

  IconData _serviceIcon(ServiceType t) {
    switch (t) {
      case ServiceType.food: return Icons.restaurant;
      case ServiceType.parcel: return Icons.inventory_2;
      case ServiceType.laundry: return Icons.local_laundry_service;
      default: return Icons.delivery_dining;
    }
  }
}
