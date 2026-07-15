import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../models/food_item.dart';
import '../models/service_type.dart';
import '../providers/food_cart_provider.dart';
import 'checkout_screen.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final double price;
  final String? imageUrl;
  final String? restaurantId;
  final String? restaurantName;
  final List<AddonGroup>? addonGroups;

  const FoodDetailScreen({
    super.key,
    this.title = 'Jollof Rice with Chicken',
    this.description =
        'Authentic smoky Jollof rice served with seasoned grilled chicken, '
        'a side of fried sweet plantains, and our signature pepper sauce.',
    this.price = 15.00,
    this.imageUrl,
    this.restaurantId,
    this.restaurantName,
    this.addonGroups,
  });

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  int _quantity = 1;

  // Keyed by group name → list of selected option names.
  late final Map<String, List<String>> _selections;

  final TextEditingController _instructionsCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selections = {};
    // Pre-select the first option in every required single-select group.
    for (final group in widget.addonGroups ?? []) {
      if (group.isRequired && group.isSingleSelect && group.options.isNotEmpty) {
        _selections[group.name] = [group.options.first.name];
      } else {
        _selections[group.name] = [];
      }
    }
  }

  @override
  void dispose() {
    _instructionsCtrl.dispose();
    super.dispose();
  }

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  /// Total price adjustment from all selected addon options.
  double get _addonsTotal {
    double total = 0;
    for (final group in widget.addonGroups ?? []) {
      final selected = _selections[group.name] ?? [];
      for (final optName in selected) {
        final opt = group.options.firstWhere(
          (o) => o.name == optName,
          orElse: () => const AddonOption('', 0),
        );
        total += opt.priceAdjustment;
      }
    }
    return total;
  }

  double get _unitPrice => widget.price + _addonsTotal;
  double get _totalPrice => _unitPrice * _quantity;

  /// Returns true if all required groups have sufficient selections.
  bool get _isValid {
    for (final group in widget.addonGroups ?? []) {
      if (group.isRequired) {
        final selected = _selections[group.name] ?? [];
        if (selected.length < group.minSelections) return false;
      }
    }
    return true;
  }

  void _onShare() {
    final name = widget.restaurantName ?? 'swiftree';
    SharePlus.instance.share(
      ShareParams(
        text: 'Check out ${widget.title} from $name on swiftree! '
            '🍽️ Order now: https://swiftree.com',
      ),
    );
  }

  void _onAddToCart() {
    if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please complete all required selections.',
            style: AppFonts.inter(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // Build structured addons list for CartItem.
    final List<Map<String, dynamic>> selectedAddons = [];
    for (final group in widget.addonGroups ?? []) {
      final selected = _selections[group.name] ?? [];
      for (final optName in selected) {
        final opt = group.options.firstWhere(
          (o) => o.name == optName,
          orElse: () => const AddonOption('', 0),
        );
        if (opt.name.isNotEmpty) {
          selectedAddons.add({
            'group': group.name,
            'name': opt.name,
            'price': opt.priceAdjustment,
          });
        }
      }
    }

    // Build a human-readable description summary.
    final descParts = <String>[
      if (selectedAddons.isNotEmpty)
        selectedAddons
            .where((a) => (a['price'] as double) >= 0)
            .map((a) => a['name'] as String)
            .join(', '),
      if (_instructionsCtrl.text.trim().isNotEmpty)
        'Note: ${_instructionsCtrl.text.trim()}',
    ];

    // CartItem.price is the base price; CartItem.addonsTotal is computed
    // from selectedAddons so that CartItem.unitPrice and lineTotal are correct.
    final item = CartItem(
      title: widget.title,
      description: descParts.where((s) => s.isNotEmpty).join(' · '),
      price: widget.price,
      quantity: _quantity,
      imageUrl: widget.imageUrl,
      restaurantId: widget.restaurantId,
      vendorName: widget.restaurantName,
      selectedAddons: selectedAddons,
      specialInstructions:
          _instructionsCtrl.text.trim().isEmpty ? null : _instructionsCtrl.text.trim(),
    );

    final notifier = ref.read(foodCartProvider.notifier);
    if (notifier.hasVendorConflict(widget.restaurantId)) {
      _showVendorConflictDialog(item, notifier);
      return;
    }

    notifier.addItem(item);
    _showAddedSnackbar();
  }

  void _showVendorConflictDialog(CartItem item, FoodCartNotifier notifier) {
    final vendorName = notifier.currentVendorName ?? 'another restaurant';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Start a new cart?', style: AppFonts.inter(fontWeight: FontWeight.w700, fontSize: 18)),
        content: Text(
          'You have items from "$vendorName" in your cart. Adding from a different restaurant will clear your current cart.',
          style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Keep Current Cart', style: AppFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              notifier.replaceCart(item);
              _showAddedSnackbar();
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
  }

  void _showAddedSnackbar() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${widget.title} added to cart',
                style: AppFonts.inter(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Checkout',
          textColor: const Color(0xFF60A5FA),
          onPressed: () {
            final cart = ref.read(foodCartProvider);
            final notifier = ref.read(foodCartProvider.notifier);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CheckoutScreen(
                  serviceType: ServiceType.food,
                  cartItems: cart,
                  subtotal: notifier.subtotal,
                  totalItems: notifier.totalItems,
                  vendorName: notifier.currentVendorName,
                  onPlaceOrder: () => ref.read(foodCartProvider.notifier).clearCart(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Hero image URL — use passed URL or a sensible default ──────────────
  String get _heroImage =>
      widget.imageUrl ??
      'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d'
          '?auto=format&fit=crop&q=80&w=1000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero AppBar ─────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 300.0,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A), size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.share_outlined, color: Color(0xFF0F172A), size: 20),
                        onPressed: _onShare,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    _heroImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFE2E8F0),
                      child: const Icon(Icons.restaurant, size: 80, color: Color(0xFF94A3B8)),
                    ),
                  ),
                ),
              ),

              // ── Content ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Title & Price ─────────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: AppFonts.inter(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0F172A),
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Color(0xFFF59E0B), size: 16),
                                    const SizedBox(width: 4),
                                    Text('4.8', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFFF59E0B))),
                                    const SizedBox(width: 4),
                                    Text('(120+ reviews)', style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '₵${widget.price.toStringAsFixed(2)}',
                            style: AppFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Description ───────────────────────────────────
                      Text(
                        widget.description,
                        style: AppFonts.inter(fontSize: 15, color: const Color(0xFF475569), height: 1.6),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Divider(color: Color(0xFFE2E8F0), height: 1),
                      ),

                      // ── Dynamic addon groups ───────────────────────────
                      if (widget.addonGroups != null && widget.addonGroups!.isNotEmpty)
                        ...widget.addonGroups!.map(_buildAddonGroup),

                      const SizedBox(height: 32),

                      // ── Special Instructions ──────────────────────────
                      Text(
                        'Special instructions',
                        style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _instructionsCtrl,
                        maxLines: 4,
                        style: AppFonts.inter(fontSize: 15, color: const Color(0xFF0F172A)),
                        decoration: InputDecoration(
                          hintText: 'E.g. No onions, extra spicy please...',
                          hintStyle: AppFonts.inter(color: const Color(0xFF6B7280), fontSize: 15),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF0068FF))),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Sticky bottom bar ──────────────────────────────────────────
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  // ── Quantity stepper ───────────────────────────────────
                  Container(
                    height: 48,
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: _decrement,
                          icon: const Icon(Icons.remove, color: Color(0xFF0068FF), size: 20),
                          style: IconButton.styleFrom(backgroundColor: Colors.white, padding: EdgeInsets.zero),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('$_quantity', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        ),
                        IconButton(
                          onPressed: _increment,
                          icon: const Icon(Icons.add, color: Color(0xFF0068FF), size: 20),
                          style: IconButton.styleFrom(backgroundColor: Colors.white, padding: EdgeInsets.zero),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // ── Add to Cart button ─────────────────────────────────
                  Expanded(
                    child: Opacity(
                      opacity: _isValid ? 1.0 : 0.5,
                      child: ElevatedButton(
                        onPressed: _onAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0068FF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Add to Cart', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('•', style: TextStyle(color: Colors.white54)),
                            ),
                            Text('₵${_totalPrice.toStringAsFixed(2)}', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
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

  Widget _buildAddonGroup(AddonGroup group) {
    final selected = _selections[group.name] ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Group header ───────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  group.name,
                  style: AppFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: group.isRequired ? const Color(0x1A0052CC) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  group.isRequired ? 'REQUIRED' : 'OPTIONAL',
                  style: AppFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: group.isRequired ? const Color(0xFF0068FF) : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          if (group.maxSelections > 1)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: Text(
                'Pick up to ${group.maxSelections}',
                style: AppFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
              ),
            )
          else
            const SizedBox(height: 16),

          // ── Options ────────────────────────────────────────────────────
          ...group.options.map((option) {
            final isSelected = selected.contains(option.name);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  final current = List<String>.from(_selections[group.name] ?? []);
                  if (group.isSingleSelect) {
                    setState(() => _selections[group.name] = [option.name]);
                  } else {
                    if (isSelected) {
                      current.remove(option.name);
                      setState(() => _selections[group.name] = current);
                    } else if (current.length < group.maxSelections) {
                      current.add(option.name);
                      setState(() => _selections[group.name] = current);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'You can pick at most ${group.maxSelections} from "${group.name}".',
                            style: AppFonts.inter(color: Colors.white),
                          ),
                          backgroundColor: const Color(0xFF0F172A),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0068FF) : const Color(0xFFE2E8F0),
                      width: isSelected ? 2 : 1,
                    ),
                    color: isSelected ? const Color(0x0D0052CC) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // ── Radio dot or checkbox indicator ────────────────
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: group.isSingleSelect ? BoxShape.circle : BoxShape.rectangle,
                          borderRadius: group.isSingleSelect ? null : BorderRadius.circular(6),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF0068FF) : const Color(0xFFCBD5E1),
                            width: isSelected ? 2 : 1.5,
                          ),
                          color: isSelected ? const Color(0xFF0068FF) : Colors.transparent,
                        ),
                        child: isSelected
                            ? Icon(
                                group.isSingleSelect ? Icons.circle : Icons.check,
                                color: Colors.white,
                                size: group.isSingleSelect ? 10 : 14,
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          option.name,
                          style: AppFonts.inter(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Text(
                        option.priceAdjustment == 0
                            ? 'Included'
                            : '+₵${option.priceAdjustment.toStringAsFixed(2)}',
                        style: AppFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: option.priceAdjustment == 0
                              ? const Color(0xFF16A34A)
                              : const Color(0xFF0068FF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
