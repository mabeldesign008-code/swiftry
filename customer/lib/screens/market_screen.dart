import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';
import 'order_confirmation_screen.dart';
import '../models/address.dart';
import '../models/order.dart';
import '../models/service_type.dart';
import '../providers/active_order_provider.dart';
import '../providers/order_history_provider.dart';
import '../widgets/address_modal.dart';
import '../services/order_simulation_service.dart';

/// Parses a display price like '₵30' into a double.
double _parsePrice(String price) =>
    double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

// ─────────────────────────────────────────────────────────────────────────────
// File-private data models
// ─────────────────────────────────────────────────────────────────────────────

class _MarketVendorData {
  final String name;
  final String imageUrl;
  final String categories;
  final String rating;
  final String distance;
  final String time;
  final String fee;
  final String market;

  const _MarketVendorData({
    required this.name,
    required this.imageUrl,
    required this.categories,
    required this.rating,
    required this.distance,
    required this.time,
    required this.fee,
    required this.market,
  });
}

class _StoreItem {
  final String name;
  final String price;
  final String unit;

  const _StoreItem({
    required this.name,
    required this.price,
    required this.unit,
  });
}

class _ShoppingItem {
  final TextEditingController nameCtrl;
  final TextEditingController descCtrl;
  final TextEditingController budgetCtrl;

  _ShoppingItem({
    String name = '',
    String desc = '',
    String budget = '',
  })  : nameCtrl = TextEditingController(text: name),
        descCtrl = TextEditingController(text: desc),
        budgetCtrl = TextEditingController(text: budget);

  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    budgetCtrl.dispose();
  }

  double get budgetValue => double.tryParse(budgetCtrl.text) ?? 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// MarketScreen
// ─────────────────────────────────────────────────────────────────────────────

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            _buildGradientHeader(context),
            const Expanded(
              child: TabBarView(
                children: [
                  _BrowseVendorsTab(),
                  _ShoppingListTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0068FF), Color(0xFF0052CC)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Market',
                      textAlign: TextAlign.center,
                      style: AppFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: AppFonts.inter(
                  fontWeight: FontWeight.w600, fontSize: 14),
              unselectedLabelStyle: AppFonts.inter(
                  fontWeight: FontWeight.w400, fontSize: 14),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.65),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Browse Vendors'),
                Tab(text: 'Shopping List'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 1 – Browse Vendors
// ─────────────────────────────────────────────────────────────────────────────

class _BrowseVendorsTab extends StatefulWidget {
  const _BrowseVendorsTab();

  @override
  State<_BrowseVendorsTab> createState() => _BrowseVendorsTabState();
}

class _BrowseVendorsTabState extends State<_BrowseVendorsTab>
    with AutomaticKeepAliveClientMixin {
  int _selectedFilter = 0;
  final Set<String> _favourites = {};

  static const List<String> _filters = [
    'All',
    'Fresh Produce',
    'Grains',
    'Spices',
    'Fish & Meat',
    'Wholesale',
  ];

  static const List<_MarketVendorData> _vendors = [
    _MarketVendorData(
      name: 'Auntie Ama - Makola',
      imageUrl:
          'https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=800',
      categories: 'Fresh Produce • Grains • Spices',
      rating: '4.5',
      distance: '3.2 km',
      time: '35-50 min',
      fee: '₵15 Delivery',
      market: 'Makola Market',
    ),
    _MarketVendorData(
      name: 'Kofi Boateng Fresh Foods',
      imageUrl:
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800',
      categories: 'Fish • Meat • Poultry',
      rating: '4.7',
      distance: '4.1 km',
      time: '40-60 min',
      fee: '₵18 Delivery',
      market: 'Kejetia Market',
    ),
    _MarketVendorData(
      name: 'Abena Grains & Cereals',
      imageUrl:
          'https://images.unsplash.com/photo-1612892483236-52d32a0e0ac1?w=800',
      categories: 'Rice • Corn • Millet • Beans',
      rating: '4.4',
      distance: '2.8 km',
      time: '30-45 min',
      fee: '₵12 Delivery',
      market: 'Kaneshie Market',
    ),
  ];

  List<_MarketVendorData> get _filteredVendors {
    if (_selectedFilter == 0) return _vendors;
    final kw = _filters[_selectedFilter].toLowerCase();
    return _vendors.where((v) {
      final c = v.categories.toLowerCase();
      switch (kw) {
        case 'fresh produce':
          return c.contains('produce') || c.contains('fresh');
        case 'grains':
          return c.contains('grain') ||
              c.contains('rice') ||
              c.contains('corn') ||
              c.contains('millet') ||
              c.contains('bean');
        case 'spices':
          return c.contains('spice');
        case 'fish & meat':
          return c.contains('fish') || c.contains('meat');
        case 'wholesale':
          return c.contains('bulk') || c.contains('wholesale');
        default:
          return true;
      }
    }).toList();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        // Filter chips
        SizedBox(
          height: 58,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: _filters.length,
            itemBuilder: (_, i) {
              final active = i == _selectedFilter;
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFF0068FF)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: active
                          ? Colors.transparent
                          : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: const Color(0xFF0068FF)
                                  .withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Text(
                    _filters[i],
                    style: AppFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: active
                          ? Colors.white
                          : const Color(0xFF475569),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Vendor list
        Expanded(
          child: _filteredVendors.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off_rounded,
                          size: 56, color: Color(0xFFCBD5E1)),
                      const SizedBox(height: 12),
                      Text(
                        'No vendors for this category yet',
                        style: AppFonts.inter(
                            fontSize: 16,
                            color: const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: _filteredVendors.length,
                  itemBuilder: (_, i) =>
                      _buildVendorCard(_filteredVendors[i]),
                ),
        ),
      ],
    );
  }

  Widget _buildVendorCard(_MarketVendorData vendor) {
    final isFav = _favourites.contains(vendor.name);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _MarketStoreScreen(vendor: vendor),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image + overlays
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24)),
                  child: Image.network(
                    vendor.imageUrl,
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: const Color(0xFFE8F4FD),
                      child: const Center(
                        child: Icon(Icons.storefront_outlined,
                            color: Color(0xFF0068FF), size: 40),
                      ),
                    ),
                  ),
                ),
                // Favourite button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      if (isFav) {
                        _favourites.remove(vendor.name);
                      } else {
                        _favourites.add(vendor.name);
                      }
                    }),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12, blurRadius: 4)
                        ],
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isFav
                            ? const Color(0xFFF43F5E)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
                // Delivery fee badge
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      vendor.fee,
                      style: AppFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Info section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + rating row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vendor.name,
                          style: AppFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0x1AFACC15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: AppTheme.star, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              vendor.rating,
                              style: AppFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Market badge (yellow chip)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppTheme.secondary.withOpacity(0.35)),
                    ),
                    child: Text(
                      vendor.market,
                      style: AppFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE65100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Categories
                  Text(
                    vendor.categories,
                    style: AppFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 8),

                  // Distance & time
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Color(0xFF94A3B8), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        vendor.distance,
                        style: AppFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time,
                          color: Color(0xFF94A3B8), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        vendor.time,
                        style: AppFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, color: const Color(0xFFF1F5F9)),
                  const SizedBox(height: 12),

                  // CTA
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0x1A1E3B8A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Browse Items',
                        style: AppFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E3B8A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 2 – Shopping List
// ─────────────────────────────────────────────────────────────────────────────

class _ShoppingListTab extends ConsumerStatefulWidget {
  const _ShoppingListTab();

  @override
  ConsumerState<_ShoppingListTab> createState() => _ShoppingListTabState();
}

class _ShoppingListTabState extends ConsumerState<_ShoppingListTab>
    with AutomaticKeepAliveClientMixin {
  int _selectedMarket = 0;

  static const List<String> _markets = [
    'Makola Market (Accra)',
    'Kejetia Market (Kumasi)',
    'Kaneshie Market (Accra)',
    'Kotokuraba Market (Cape Coast)',
    'Kumasi Central Market',
  ];

  late List<_ShoppingItem> _items;
  final _instructionsCtrl =
      TextEditingController(text: 'Pick firm tomatoes, avoid soft ones');
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _items = [
      _ShoppingItem(name: 'Tomatoes', desc: '2 big bowls', budget: '30'),
      _ShoppingItem(name: 'Onions', desc: '1 bag', budget: '25'),
    ];
  }

  @override
  void dispose() {
    for (final item in _items) {
      item.dispose();
    }
    _instructionsCtrl.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  double get _estimatedTotal {
    final itemsTotal =
        _items.fold(0.0, (sum, item) => sum + item.budgetValue);
    return itemsTotal + 15.0 + 8.0; // ₵15 service fee + ₵8 delivery
  }

  void _addItem() => setState(() => _items.add(_ShoppingItem()));

  void _removeItem(int i) {
    setState(() {
      _items[i].dispose();
      _items.removeAt(i);
    });
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final itemsTotal = _items.fold(0.0, (sum, item) => sum + item.budgetValue);
    final order = Order(
      id: OrderIdGenerator.next(ServiceType.market),
      serviceType: ServiceType.market,
      items: _items
          .where((item) => item.nameCtrl.text.trim().isNotEmpty)
          .map((item) => OrderLineItem(
                title: item.nameCtrl.text.trim(),
                description: item.descCtrl.text.trim(),
                unitPrice: item.budgetValue,
              ))
          .toList(),
      subtotal: itemsTotal,
      deliveryFee: 8.0,
      serviceFee: 15.0,
      total: _estimatedTotal,
      paymentMethod: 'swiftree Wallet',
      address: const Address(type: 'Home', street: 'Osu, Oxford Street'),
      vendorName: _markets[_selectedMarket],
      specialInstructions: _instructionsCtrl.text.trim().isEmpty ? null : _instructionsCtrl.text.trim(),
      placedAt: DateTime.now(),
      eta: ServiceType.market.defaultEta,
    );
    ref.read(orderHistoryProvider.notifier).placeOrder(order);
    ref.read(activeOrderProvider.notifier).setOrder(
      ActiveOrder(
        orderId: order.id,
        serviceType: order.serviceType,
        statusMessage: order.serviceType.defaultStatusMessage,
        vendorName: order.vendorName,
        eta: order.eta,
      ),
    );

    OrderSimulationService.start(ref: ref, context: context, order: order);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(order: order),
      ),
    );
  }

  void _showBreakdown() {
    final itemsTotal =
        _items.fold(0.0, (sum, item) => sum + item.budgetValue);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Items: ₵${itemsTotal.toStringAsFixed(2)}  +  Service fee: ₵15.00  +  Delivery: ₵8.00',
          style: AppFonts.inter(fontSize: 13, color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
          children: [
            _buildInfoBanner(),
            const SizedBox(height: 24),

            _buildSectionLabel('Target Market', Icons.store_outlined),
            const SizedBox(height: 12),
            _buildMarketSelector(),
            const SizedBox(height: 24),

            _buildSectionLabel(
                'Shopping Items', Icons.shopping_basket_outlined),
            const SizedBox(height: 12),
            _buildItemsList(),
            const SizedBox(height: 24),

            _buildSectionLabel(
                'Special Instructions', Icons.note_alt_outlined),
            const SizedBox(height: 12),
            _buildInstructions(),
            const SizedBox(height: 24),

            _buildSectionLabel(
                'Delivery Address', Icons.location_on_outlined),
            const SizedBox(height: 12),
            _buildDeliveryAddress(),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildFooter(),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0068FF), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBFD7FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Your rider will purchase these items from your chosen market. "
              "Actual cost may vary slightly. You'll be refunded any difference.",
              style: AppFonts.inter(
                fontSize: 13,
                color: const Color(0xFF1E40AF),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _markets.asMap().entries.map((e) {
        final active = e.key == _selectedMarket;
        return GestureDetector(
          onTap: () => setState(() => _selectedMarket = e.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color:
                  active ? const Color(0xFF0068FF) : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: active
                    ? const Color(0xFF0068FF)
                    : const Color(0xFFE2E8F0),
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color:
                            const Color(0xFF0068FF).withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: Text(
              e.value,
              style: AppFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color:
                    active ? Colors.white : const Color(0xFF475569),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildItemsList() {
    return Column(
      children: [
        ..._items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + remove button
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: item.nameCtrl,
                        style: AppFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Item name',
                          hintStyle: AppFonts.inter(
                              color: const Color(0xFF94A3B8),
                              fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _removeItem(i),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Icon(Icons.close,
                            size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(height: 1, color: const Color(0xFFF1F5F9)),
                const SizedBox(height: 8),

                // Description
                TextFormField(
                  controller: item.descCtrl,
                  style: AppFonts.inter(
                      fontSize: 13, color: const Color(0xFF64748B)),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Qty / description (e.g. 2 big bowls)',
                    hintStyle: AppFonts.inter(
                        color: const Color(0xFF94A3B8), fontSize: 13),
                  ),
                ),
                const SizedBox(height: 10),

                // Budget estimate
                Row(
                  children: [
                    Text(
                      '₵',
                      style: AppFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextFormField(
                        controller: item.budgetCtrl,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                                decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        onChanged: (_) => setState(() {}),
                        style: AppFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF0F172A)),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Budget estimate (optional)',
                          hintStyle: AppFonts.inter(
                              color: const Color(0xFF94A3B8),
                              fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 4),

        // Add item button
        GestureDetector(
          onTap: _addItem,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFF0068FF).withOpacity(0.35),
                  width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_circle_outline,
                    color: Color(0xFF0068FF), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Add Item',
                  style: AppFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0068FF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: _instructionsCtrl,
        maxLines: 3,
        style: AppFonts.inter(
            fontSize: 14, color: const Color(0xFF0F172A)),
        decoration: InputDecoration(
          hintText: 'Any special instructions for the rider...',
          hintStyle: AppFonts.inter(
              color: const Color(0xFF94A3B8), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return GestureDetector(
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddressModal(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF5FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home_outlined,
                  color: Color(0xFF0068FF), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Home — Osu, Oxford Street',
                    style: AppFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to change address',
                    style: AppFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0x1A0052CC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Change',
                style: AppFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0068FF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final total = _estimatedTotal;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 10,
              offset: Offset(0, -3)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ESTIMATED TOTAL',
                      style: AppFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF64748B),
                        letterSpacing: 1.1,
                      ),
                    ),
                    Text(
                      '₵${total.toStringAsFixed(2)}',
                      style: AppFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _showBreakdown,
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Color(0xFF94A3B8), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'See breakdown',
                        style: AppFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0068FF),
                  disabledBackgroundColor:
                      const Color(0xFF0068FF).withOpacity(0.7),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : Text(
                        'Submit Shopping List',
                        style: AppFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Inline market vendor store screen (navigated to from Browse Vendors)
// ─────────────────────────────────────────────────────────────────────────────

class _MarketStoreScreen extends ConsumerStatefulWidget {
  final _MarketVendorData vendor;

  const _MarketStoreScreen({required this.vendor});

  @override
  ConsumerState<_MarketStoreScreen> createState() => _MarketStoreScreenState();
}

class _MarketStoreScreenState extends ConsumerState<_MarketStoreScreen> {
  static const List<_StoreItem> _storeItems = [
    _StoreItem(name: 'Fresh Tomatoes', price: '₵30', unit: 'per bowl'),
    _StoreItem(name: 'Onions', price: '₵25', unit: 'per bag'),
    _StoreItem(name: 'Fresh Tilapia', price: '₵80', unit: 'per 3 pieces'),
    _StoreItem(name: 'Kontomire', price: '₵10', unit: 'per bundle'),
    _StoreItem(name: 'Garden Eggs', price: '₵15', unit: 'per dozen'),
  ];

  final Map<String, int> _cart = {};

  int get _totalQty => _cart.values.fold(0, (a, b) => a + b);

  void _increment(String name) =>
      setState(() => _cart[name] = (_cart[name] ?? 0) + 1);

  void _decrement(String name) => setState(() {
        if ((_cart[name] ?? 0) > 1) {
          _cart[name] = _cart[name]! - 1;
        } else {
          _cart.remove(name);
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Gradient header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0068FF), Color(0xFF0052CC)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            widget.vendor.name,
                            textAlign: TextAlign.center,
                            style: AppFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.vendor.market,
                            style: AppFonts.inter(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // Vendor meta strip
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.star,
                    color: AppTheme.star, size: 14),
                const SizedBox(width: 4),
                Text(
                  widget.vendor.rating,
                  style: AppFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.location_on,
                    color: Color(0xFF94A3B8), size: 14),
                const SizedBox(width: 4),
                Text(
                  widget.vendor.distance,
                  style: AppFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF64748B)),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time,
                    color: Color(0xFF94A3B8), size: 14),
                const SizedBox(width: 4),
                Text(
                  widget.vendor.time,
                  style: AppFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF64748B)),
                ),
              ],
            ),
          ),

          // Items list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: _storeItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final item = _storeItems[i];
                final qty = _cart[item.name] ?? 0;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: AppFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.price} ${item.unit}',
                              style: AppFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF0068FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (qty == 0)
                        GestureDetector(
                          onTap: () => _increment(item.name),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 9),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0068FF),
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Add',
                              style: AppFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => _decrement(item.name),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.remove,
                                      size: 16,
                                      color: Color(0xFF475569)),
                                ),
                              ),
                              SizedBox(
                                width: 34,
                                child: Text(
                                  '$qty',
                                  textAlign: TextAlign.center,
                                  style: AppFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _increment(item.name),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0068FF),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.add,
                                      size: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Bottom bar — visible only when cart has items
      bottomNavigationBar: _totalQty > 0
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border:
                    Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: SafeArea(
                top: false,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added! Proceed to checkout',
                          style: AppFonts.inter(
                              color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFF16A34A),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    final subtotal = _cart.entries.fold<double>(
                      0.0,
                      (sum, e) {
                        final item = _storeItems.firstWhere((i) => i.name == e.key);
                        return sum + _parsePrice(item.price) * e.value;
                      },
                    );
                    final order = Order(
                      id: OrderIdGenerator.next(ServiceType.market),
                      serviceType: ServiceType.market,
                      items: _cart.entries.map((e) {
                        final item = _storeItems.firstWhere((i) => i.name == e.key);
                        return OrderLineItem(
                          title: item.name,
                          description: item.unit,
                          unitPrice: _parsePrice(item.price),
                          quantity: e.value,
                        );
                      }).toList(),
                      subtotal: subtotal,
                      deliveryFee: 8.0,
                      serviceFee: 15.0,
                      total: subtotal + 8.0 + 15.0,
                      paymentMethod: 'swiftree Wallet',
                      address: const Address(type: 'Home', street: 'Osu, Oxford Street'),
                      vendorName: widget.vendor.name,
                      placedAt: DateTime.now(),
                      eta: ServiceType.market.defaultEta,
                    );
                    ref.read(orderHistoryProvider.notifier).placeOrder(order);
                    ref.read(activeOrderProvider.notifier).setOrder(
                      ActiveOrder(
                        orderId: order.id,
                        serviceType: order.serviceType,
                        statusMessage: order.serviceType.defaultStatusMessage,
                        vendorName: order.vendorName,
                        eta: order.eta,
                      ),
                    );
                    OrderSimulationService.start(ref: ref, context: context, order: order);
                    final nav = Navigator.of(context);
                    Future.delayed(
                      const Duration(milliseconds: 1800),
                      () {
                        if (mounted) {
                          nav.push(
                            MaterialPageRoute(
                              builder: (_) => OrderConfirmationScreen(order: order),
                            ),
                          );
                        }
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0068FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add to Shopping List / Order',
                        style: AppFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$_totalQty',
                          style: AppFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
