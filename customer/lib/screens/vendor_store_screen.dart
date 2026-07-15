import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';
import 'package:share_plus/share_plus.dart';
import 'laundry_cart_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/laundry_cart_provider.dart';

class VendorStoreScreen extends ConsumerStatefulWidget {
  final String vendorName;
  final String vendorImageUrl;
  final String vendorRating;
  final String vendorTurnaround;

  const VendorStoreScreen({
    super.key,
    required this.vendorName,
    this.vendorImageUrl = 'https://images.unsplash.com/photo-1545173168-9f1947eebb7f?auto=format&fit=crop&q=80&w=800',
    this.vendorRating = '4.7',
    this.vendorTurnaround = '2-3 days',
  });

  @override
  ConsumerState<VendorStoreScreen> createState() => _VendorStoreScreenState();
}

class _VendorStoreScreenState extends ConsumerState<VendorStoreScreen> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final _cart = ref.watch(laundryCartProvider);
    final _cartTotal = _cart.values.fold(0, (sum, qty) => sum + qty);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero Image with back/share/heart overlay
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.vendorImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFE2E8F0),
                          child: const Icon(Icons.local_laundry_service, size: 60, color: Color(0xFF94A3B8)),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x66000000), Colors.transparent],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _glassButton(
                                  Icons.arrow_back,
                                  () => Navigator.pop(context),
                                ),
                                Row(
                                  children: [
                                    _glassButton(Icons.share_outlined, () {
                                      SharePlus.instance.share(ShareParams(
                                        text: 'Check out ${widget.vendorName} on swiftree Laundry! 👕 Order now: https://swiftree.com',
                                      ));
                                    }),
                                    const SizedBox(width: 8),
                                    _glassButton(
                                      _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                      () => setState(() => _isBookmarked = !_isBookmarked),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // overlapping logo
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(28),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                      ),
                      Positioned(
                        top: -40,
                        left: 16,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0068FF),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.local_laundry_service, color: Colors.white, size: 36),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Vendor Info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.vendorName,
                        style: AppFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppTheme.star, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.vendorRating,
                            style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(150+ ratings)',
                            style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(color: Color(0xFFCBD5E1), shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Premium Care',
                            style: AppFonts.inter(fontSize: 14, color: const Color(0xFF475569)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Color(0xFF475569)),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.vendorTurnaround} turnaround',
                            style: AppFonts.inter(fontSize: 14, color: const Color(0xFF475569)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.local_shipping_outlined, size: 16, color: Color(0xFF475569)),
                          const SizedBox(width: 6),
                          Text(
                            '₵15 Pickup & Return',
                            style: AppFonts.inter(fontSize: 14, color: const Color(0xFF475569)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Promo Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0x33FBBF24),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0x4DFBBF24)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTheme.secondary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Text('🎉', style: TextStyle(fontSize: 18)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '20% off orders above GH₵100',
                                    style: AppFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Limited time offer applied at checkout',
                                    style: AppFonts.inter(fontSize: 12, color: const Color(0xFF334155)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Item categories
              _buildCategory('Tops', [
                _LaundryItem(name: 'Business Shirt', service: 'Wash & Iron', price: 12.0),
                _LaundryItem(name: 'Casual T-Shirt', service: 'Wash & Fold', price: 8.0),
              ]),
              _buildCategory('Suits', [
                _LaundryItem(name: 'Two-Piece Suit', service: 'Dry Clean Only', price: 45.0),
              ]),
              _buildCategory('Bedding', [
                _LaundryItem(name: 'Duvet (King Size)', service: 'Deep Clean & Sanitized', price: 60.0),
                _LaundryItem(name: 'Pillow Case (pair)', service: 'Wash & Fold', price: 5.0),
              ]),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // Floating Cart Button
          if (_cartTotal > 0)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LaundryCartScreen(
                        vendorName: widget.vendorName,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0068FF),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0068FF).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_cartTotal',
                          style: AppFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'View Cart',
                        style: AppFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.shopping_basket, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _glassButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildCategory(String title, List<_LaundryItem> items) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => _buildItemRow(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(_LaundryItem item) {
    final _cart = ref.watch(laundryCartProvider);
    final qty = _cart[item.name] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 4)],
      ),
      child: Row(
        children: [
          // Icon placeholder
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.local_laundry_service, color: Color(0xFF94A3B8), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.service,
                  style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B)),
                ),
                const SizedBox(height: 4),
                Text(
                  '₵${item.price.toStringAsFixed(2)}',
                  style: AppFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0068FF),
                  ),
                ),
              ],
            ),
          ),
          // Quantity controls
          if (qty == 0)
            GestureDetector(
              onTap: () => ref.read(laundryCartProvider.notifier).updateQuantity(item.name, 1),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0068FF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0068FF).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => ref.read(laundryCartProvider.notifier).updateQuantity(item.name, -1),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.remove, color: Color(0xFF0068FF), size: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '$qty',
                    style: AppFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => ref.read(laundryCartProvider.notifier).updateQuantity(item.name, 1),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0068FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _LaundryItem {
  final String name;
  final String service;
  final double price;

  const _LaundryItem({
    required this.name,
    required this.service,
    required this.price,
  });
}
