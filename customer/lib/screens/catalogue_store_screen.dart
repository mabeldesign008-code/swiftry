import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../models/service_type.dart';
import '../providers/food_cart_provider.dart';
import 'checkout_screen.dart';

class CatalogueStoreScreen extends ConsumerStatefulWidget {
  final ServiceType serviceType;
  final Map<String, dynamic> vendor;

  const CatalogueStoreScreen({
    super.key,
    required this.serviceType,
    required this.vendor,
  });

  @override
  ConsumerState<CatalogueStoreScreen> createState() => _CatalogueStoreScreenState();
}

class _CatalogueStoreScreenState extends ConsumerState<CatalogueStoreScreen> {
  bool _isFavourite = false;

  // ── Vendor accessors ──────────────────────────────────────────────────────
  String get _vendorName => widget.vendor['name'] as String? ?? 'Store';
  String get _vendorImage => widget.vendor['image'] as String? ?? '';
  String get _vendorRating => widget.vendor['rating'] as String? ?? '4.5';
  String get _vendorTime => widget.vendor['time'] as String? ?? '20-35 min';
  String get _vendorFee => widget.vendor['fee'] as String? ?? '₵10 Delivery';
  String get _vendorCategories => widget.vendor['categories'] as String? ?? '';
  String get _vendorDistance => widget.vendor['distance'] as String? ?? '';

  // ── Menu data (lazy init) ─────────────────────────────────────────────────
  late final List<_CatalogueCategory> _categories = _buildCategories();
  late final List<bool> _expanded = List.generate(_categories.length, (_) => true);

  // Names of Rx items in this pharmacy store for reactive banner check.
  late final Set<String> _rxItemNames = _buildRxItemNames();

  Set<String> _buildRxItemNames() {
    if (widget.serviceType != ServiceType.pharmacy) return {};
    return {
      for (final cat in _categories)
        for (final item in cat.items)
          if (item.requiresPrescription) item.name,
    };
  }

  List<_CatalogueCategory> _buildCategories() {
    switch (widget.serviceType) {
      // ── GROCERIES ──────────────────────────────────────────────────────
      case ServiceType.groceries:
        return [
          _CatalogueCategory(name: 'Fresh Produce', items: [
            _CatalogueItem(
              name: 'Fresh Tomatoes',
              price: 12.00,
              imageUrl: 'https://images.unsplash.com/photo-1546470427-1ba4a39f7de0?w=400',
              unit: 'per bowl',
            ),
            _CatalogueItem(
              name: 'Onions',
              price: 8.00,
              imageUrl: 'https://images.unsplash.com/photo-1618512496248-a4a5b23e6f5e?w=400',
              unit: 'per bag',
            ),
            _CatalogueItem(
              name: 'Garden Eggs',
              price: 5.00,
              imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
              unit: 'per 10 pcs',
            ),
          ]),
          _CatalogueCategory(name: 'Dairy & Eggs', items: [
            _CatalogueItem(
              name: 'Eggs (Tray of 30)',
              price: 55.00,
              imageUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400',
              unit: 'per tray',
            ),
            _CatalogueItem(
              name: 'Peak Milk (400g)',
              price: 28.00,
              imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',
              unit: 'per tin',
            ),
          ]),
          _CatalogueCategory(name: 'Grains & Staples', items: [
            _CatalogueItem(
              name: 'Imported Rice (5kg)',
              price: 85.00,
              imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e8ac?w=400',
              unit: 'per bag',
            ),
            _CatalogueItem(
              name: 'Indomie (pack of 40)',
              price: 65.00,
              imageUrl: 'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?w=400',
              unit: 'per pack',
            ),
          ]),
        ];

      // ── SHOP ───────────────────────────────────────────────────────────
      case ServiceType.shop:
        return [
          _CatalogueCategory(name: 'Phone Accessories', items: [
            _CatalogueItem(
              name: 'iPhone Clear Case',
              price: 45.00,
              imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400',
              variants: {
                'Color': ['Black', 'Clear', 'Blue'],
              },
            ),
            _CatalogueItem(
              name: 'AirPods Clone (i12 TWS)',
              price: 120.00,
              imageUrl: 'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f37?w=400',
              variants: {
                'Color': ['White', 'Black'],
              },
            ),
          ]),
          _CatalogueCategory(name: 'Clothing', items: [
            _CatalogueItem(
              name: 'Polo T-Shirt',
              price: 80.00,
              imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
              variants: {
                'Size': ['S', 'M', 'L', 'XL'],
                'Color': ['White', 'Navy', 'Red'],
              },
            ),
            _CatalogueItem(
              name: 'Sneakers (Replica)',
              price: 180.00,
              imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
              variants: {
                'Size': ['40', '41', '42', '43', '44'],
              },
            ),
          ]),
        ];

      // ── PHARMACY ───────────────────────────────────────────────────────
      case ServiceType.pharmacy:
        return [
          _CatalogueCategory(name: 'Pain Relief', items: [
            _CatalogueItem(
              name: 'Paracetamol 500mg (Strip)',
              price: 6.00,
              imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400',
              requiresPrescription: false,
            ),
            _CatalogueItem(
              name: 'Ibuprofen 400mg (Strip)',
              price: 12.00,
              imageUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400',
              requiresPrescription: false,
            ),
          ]),
          _CatalogueCategory(name: 'Antibiotics', items: [
            _CatalogueItem(
              name: 'Amoxicillin 500mg',
              price: 35.00,
              imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400',
              requiresPrescription: true,
            ),
            _CatalogueItem(
              name: 'Ciprofloxacin 500mg',
              price: 45.00,
              imageUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400',
              requiresPrescription: true,
            ),
          ]),
          _CatalogueCategory(name: 'Supplements', items: [
            _CatalogueItem(
              name: 'Vitamin C 1000mg',
              price: 25.00,
              imageUrl: 'https://images.unsplash.com/photo-1550572017-26b5655c1c88?w=400',
              requiresPrescription: false,
            ),
            _CatalogueItem(
              name: 'Zinc Tablets',
              price: 18.00,
              imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400',
              requiresPrescription: false,
            ),
          ]),
        ];

      default:
        return [];
    }
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _onShare() {
    SharePlus.instance.share(
      ShareParams(
        text: 'Check out $_vendorName on swiftree! \uD83D\uDED2 Order now: https://swiftree.com',
      ),
    );
  }

  void _goToCheckout() {
    final cart = ref.read(foodCartProvider);
    final totalItems = cart.fold<int>(0, (s, i) => s + i.quantity);
    final subtotal = cart.fold<double>(0.0, (s, i) => s + i.lineTotal);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          // NOTE: CheckoutScreen disables Cash on Delivery when
          // serviceType == ServiceType.shop — see checkout_screen.dart.
          serviceType: widget.serviceType,
          cartItems: cart,
          subtotal: subtotal,
          totalItems: totalItems,
          vendorName: _vendorName,
          onPlaceOrder: () => ref.read(foodCartProvider.notifier).clearCart(),
        ),
      ),
    );
  }

  void _showItemSheet(_CatalogueItem item) {
    switch (widget.serviceType) {
      case ServiceType.groceries:
        _showGrocerySheet(item);
      case ServiceType.shop:
        _showShopSheet(item);
      case ServiceType.pharmacy:
        _showPharmacySheet(item);
      default:
        break;
    }
  }

  void _addedToCartSnackBar(String itemName) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$itemName added to cart',
                style: AppFonts.inter(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Enforces one-vendor-per-cart. Call from any bottom sheet's Add-to-Cart
  /// handler. Dismisses the sheet, then either adds the item or shows the
  /// vendor-conflict dialog (which offers "Start New Cart").
  void _handleAddToCart({required CartItem newItem, required String itemName}) {
    final notifier = ref.read(foodCartProvider.notifier);

    if (notifier.hasVendorConflict(_vendorName)) {
      Navigator.pop(context); // dismiss the bottom sheet first
      final currentVendor = notifier.currentVendorName ?? 'another vendor';
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (dlgCtx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Start a new cart?', style: AppFonts.inter(fontWeight: FontWeight.w700, fontSize: 18)),
          content: Text(
            'You have items from "$currentVendor" in your cart. Adding from a different store will clear your current cart.',
            style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgCtx),
              child: Text('Keep Current Cart', style: AppFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dlgCtx);
                notifier.replaceCart(newItem);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cart cleared. $itemName added!', style: AppFonts.inter(color: Colors.white)),
                    backgroundColor: const Color(0xFF0F172A),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0068FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Start New Cart', style: AppFonts.inter(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
      return;
    }

    notifier.addItem(newItem);
    Navigator.pop(context); // dismiss the bottom sheet
    _addedToCartSnackBar(itemName);
  }

  // ── Grocery bottom sheet ──────────────────────────────────────────────────
  void _showGrocerySheet(_CatalogueItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        int qty = 1;
        bool allowSubstitution = true;
        return StatefulBuilder(
          builder: (ctx, setSheet) => Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Image + name + unit + price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 80,
                              height: 80,
                              color: const Color(0xFFE2E8F0),
                              child: const Icon(Icons.local_grocery_store, color: Color(0xFF94A3B8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: AppFonts.inter(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                              ),
                              const SizedBox(height: 6),
                              if (item.unit != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.unit!,
                                    style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF475569)),
                                  ),
                                ),
                              const SizedBox(height: 6),
                              Text(
                                '\u20B5${item.price.toStringAsFixed(2)}',
                                style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 16),

                    // Quantity selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Quantity', style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
                        _quantityStepper(qty, onDecrement: () { if (qty > 1) setSheet(() => qty--); }, onIncrement: () => setSheet(() => qty++)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Substitution toggle
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Allow Substitution',
                                  style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'If unavailable, rider will find a similar item or refund you.',
                                  style: AppFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: allowSubstitution,
                            onChanged: (v) => setSheet(() => allowSubstitution = v),
                            activeThumbColor: const Color(0xFF0068FF),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Add to cart
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final newItem = CartItem(
                            title: item.name,
                            description: '${item.unit ?? ''} · ${allowSubstitution ? 'Substitution OK' : 'No substitution'}',
                            price: item.price,
                            quantity: qty,
                            imageUrl: item.imageUrl,
                            restaurantId: _vendorName,
                            vendorName: _vendorName,
                          );
                          _handleAddToCart(newItem: newItem, itemName: item.name);
                        },
                        style: _addButtonStyle(),
                        child: Text(
                          'Add to Cart  \u2022  \u20B5${(item.price * qty).toStringAsFixed(2)}',
                          style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Shop bottom sheet ─────────────────────────────────────────────────────
  void _showShopSheet(_CatalogueItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        int qty = 1;
        final Map<String, String?> selectedVariants = {
          for (final key in (item.variants ?? {}).keys) key: null,
        };
        return StatefulBuilder(
          builder: (ctx, setSheet) => Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      // Image + name + price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80,
                                height: 80,
                                color: const Color(0xFFE2E8F0),
                                child: const Icon(Icons.shopping_bag, color: Color(0xFF94A3B8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: AppFonts.inter(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                                const SizedBox(height: 6),
                                Text('\u20B5${item.price.toStringAsFixed(2)}', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 16),

                      // Variant chip selectors
                      for (final entry in (item.variants ?? {}).entries) ...[
                        Row(
                          children: [
                            Text(entry.key, style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(color: const Color(0x1A0052CC), borderRadius: BorderRadius.circular(6)),
                              child: Text('REQUIRED', style: AppFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: entry.value.map((option) {
                            final isSelected = selectedVariants[entry.key] == option;
                            return GestureDetector(
                              onTap: () => setSheet(() => selectedVariants[entry.key] = option),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF0068FF) : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF0068FF) : const Color(0xFFE2E8F0),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Text(
                                  option,
                                  style: AppFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : const Color(0xFF475569),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      const Divider(color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 16),

                      // Quantity selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Quantity', style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
                          _quantityStepper(qty, onDecrement: () { if (qty > 1) setSheet(() => qty--); }, onIncrement: () => setSheet(() => qty++)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Add to cart
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final allSelected = selectedVariants.values.every((v) => v != null);
                            if (!allSelected) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please select all required options', style: AppFonts.inter(color: Colors.white)),
                                  backgroundColor: const Color(0xFFEF4444),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              return;
                            }
                            final variantDesc = selectedVariants.entries.map((e) => '${e.key}: ${e.value}').join(', ');
                            final newItem = CartItem(
                              title: item.name,
                              description: variantDesc,
                              price: item.price,
                              quantity: qty,
                              imageUrl: item.imageUrl,
                              restaurantId: _vendorName,
                              vendorName: _vendorName,
                            );
                            _handleAddToCart(newItem: newItem, itemName: item.name);
                          },
                          style: _addButtonStyle(),
                          child: Text(
                            'Add to Cart  \u2022  \u20B5${(item.price * qty).toStringAsFixed(2)}',
                            style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Pharmacy bottom sheet ─────────────────────────────────────────────────
  void _showPharmacySheet(_CatalogueItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        int qty = 1;
        return StatefulBuilder(
          builder: (ctx, setSheet) => Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
                      ),
                    ),

                    // Image + name + Rx badge + price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 80,
                              height: 80,
                              color: const Color(0xFFE2E8F0),
                              child: const Icon(Icons.local_pharmacy, color: Color(0xFF94A3B8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: AppFonts.inter(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item.requiresPrescription ? const Color(0xFFFFEEEE) : const Color(0xFFEEFFF5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.requiresPrescription ? '\u2695 Prescription Required' : '\u2713 No Prescription',
                                  style: AppFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: item.requiresPrescription ? const Color(0xFFEF4444) : const Color(0xFF22C55E),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text('\u20B5${item.price.toStringAsFixed(2)}', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 16),

                    // Quantity selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Quantity', style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
                        _quantityStepper(qty, onDecrement: () { if (qty > 1) setSheet(() => qty--); }, onIncrement: () => setSheet(() => qty++)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Add to cart
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final newItem = CartItem(
                            title: item.name,
                            description: item.requiresPrescription ? '⚕ Prescription required' : 'OTC medication',
                            price: item.price,
                            quantity: qty,
                            imageUrl: item.imageUrl,
                            restaurantId: _vendorName,
                            vendorName: _vendorName,
                          );
                          _handleAddToCart(newItem: newItem, itemName: item.name);
                        },
                        style: _addButtonStyle(),
                        child: Text(
                          'Add to Cart  \u2022  \u20B5${(item.price * qty).toStringAsFixed(2)}',
                          style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────

  ButtonStyle _addButtonStyle() => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0068FF),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      );

  Widget _quantityStepper(int qty, {required VoidCallback onDecrement, required VoidCallback onIncrement}) {
    return Container(
      height: 44,
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(22)),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove, color: Color(0xFF0068FF), size: 18),
            style: IconButton.styleFrom(backgroundColor: Colors.white, padding: EdgeInsets.zero),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('$qty', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add, color: Color(0xFF0068FF), size: 18),
            style: IconButton.styleFrom(backgroundColor: Colors.white, padding: EdgeInsets.zero),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap, Color iconColor = const Color(0xFF0F172A)}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: 20),
        onPressed: onTap,
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(label, style: AppFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8), letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value, style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF))),
        ],
      ),
    );
  }

  // ── Category section builder ──────────────────────────────────────────────

  SliverToBoxAdapter _buildCategorySection(int index) {
    final category = _categories[index];
    final isExpanded = _expanded[index];

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header with expand/collapse
          InkWell(
            onTap: () => setState(() => _expanded[index] = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      category.name,
                      style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded)
            ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: category.items.length,
              separatorBuilder: (_, __) => const Divider(height: 32, color: Color(0xFFF1F5F9)),
              itemBuilder: (_, i) => _buildItemRow(category.items[i]),
            ),
        ],
      ),
    );
  }

  // ── Item row ──────────────────────────────────────────────────────────────

  Widget _buildItemRow(_CatalogueItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showItemSheet(item),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + service-specific inline badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        item.name,
                        style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                      ),
                    ),
                    if (widget.serviceType == ServiceType.pharmacy) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.requiresPrescription ? const Color(0xFFFFEEEE) : const Color(0xFFEEFFF5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          item.requiresPrescription ? '\u2695 Rx' : '\u2713 OTC',
                          style: AppFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: item.requiresPrescription ? const Color(0xFFEF4444) : const Color(0xFF22C55E),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),

                // Grocery: unit badge
                if (widget.serviceType == ServiceType.groceries && item.unit != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                    child: Text(item.unit!, style: AppFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                  ),
                  const SizedBox(height: 4),
                ],

                // Shop: variant chip preview
                if (widget.serviceType == ServiceType.shop && item.variants != null) ...[
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: item.variants!.entries
                        .expand((entry) => entry.value.take(3).map((v) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                              child: Text(v, style: AppFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                            )))
                        .toList(),
                  ),
                  const SizedBox(height: 4),
                ],

                // Price + Add button
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\u20B5${item.price.toStringAsFixed(2)}',
                      style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0068FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text('Add', style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Item image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.imageUrl,
              width: 96,
              height: 96,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(12)),
                child: Icon(widget.serviceType.icon, color: const Color(0xFF94A3B8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(foodCartProvider);
    final totalItems = cart.fold<int>(0, (s, i) => s + i.quantity);
    final subtotal = cart.fold<double>(0.0, (s, i) => s + i.lineTotal);

    // Reactively show prescription banner when any Rx item is in cart.
    final bool cartHasRxItem =
        _rxItemNames.isNotEmpty && cart.any((ci) => _rxItemNames.contains(ci.title));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero SliverAppBar ────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 256.0,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _circleButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _circleButton(icon: Icons.share_outlined, onTap: _onShare),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _circleButton(
                      icon: _isFavourite ? Icons.favorite : Icons.favorite_border,
                      iconColor: _isFavourite ? const Color(0xFFEF4444) : const Color(0xFF0F172A),
                      onTap: () => setState(() => _isFavourite = !_isFavourite),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: _vendorName,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _vendorImage.startsWith('http')
                            ? Image.network(
                                _vendorImage,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE2E8F0)),
                              )
                            : Container(color: const Color(0xFFE2E8F0)),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Vendor info ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _vendorName,
                        style: AppFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: const Color(0xFF334155), letterSpacing: -1.0),
                      ),
                      const SizedBox(height: 4),
                      Text(_vendorCategories, style: AppFonts.inter(fontSize: 14, color: const Color(0xFF8A8A8E))),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Color(0xFF94A3B8), size: 14),
                          const SizedBox(width: 4),
                          Text(_vendorDistance, style: AppFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFEAB308), size: 16),
                          const SizedBox(width: 4),
                          Text(_vendorRating, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                          const SizedBox(width: 4),
                          Text('(verified vendor)', style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _infoChip('DELIVERY TIME', _vendorTime)),
                          const SizedBox(width: 16),
                          Expanded(child: _infoChip('DELIVERY FEE', _vendorFee)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Prescription banner (pharmacy only, reactive) ────────────
              if (widget.serviceType == ServiceType.pharmacy && cartHasRxItem)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFECACA)),
                    ),
                    child: Row(
                      children: [
                        const Text('\uD83D\uDD34', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'This order will require a prescription photo at checkout.',
                            style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFFB91C1C)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── Menu sections ────────────────────────────────────────────
              for (int i = 0; i < _categories.length; i++) _buildCategorySection(i),

              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),

          // ── Floating cart button ─────────────────────────────────────────
          if (cart.isNotEmpty)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: GestureDetector(
                onTap: _goToCheckout,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0068FF),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0068FF).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '$totalItems',
                            style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'View Cart',
                        style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        '\u20B5${subtotal.toStringAsFixed(2)}',
                        style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Data models (file-private) ────────────────────────────────────────────────

class _CatalogueItem {
  final String name;
  final double price;
  final String imageUrl;

  /// Groceries: unit type label (e.g. 'per bowl').
  final String? unit;

  /// Shop: map of variant label → list of options
  /// e.g. {'Color': ['Black', 'White'], 'Size': ['S', 'M', 'L']}
  final Map<String, List<String>>? variants;

  /// Pharmacy: whether this item requires a prescription.
  final bool requiresPrescription;

  const _CatalogueItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.unit,
    this.variants,
    this.requiresPrescription = false,
  });
}

class _CatalogueCategory {
  final String name;
  final List<_CatalogueItem> items;

  const _CatalogueCategory({required this.name, required this.items});
}
