import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swiftree/core/theme/app_fonts.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/errand_task_provider.dart';
import 'checkout_screen.dart';
import '../models/service_type.dart';

class BuyDeliverScreen extends ConsumerStatefulWidget {
  const BuyDeliverScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BuyDeliverScreen> createState() => _BuyDeliverScreenState();
}

class _BuyDeliverScreenState extends ConsumerState<BuyDeliverScreen> {
  int _storeMode = 0; // 0 = Specific Store, 1 = Nearest Available
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  double _getEstimatedTotal(int itemsCount) {
    // Base: 40 (items mock) + 15 delivery fee
    return 40.0 + 15.0 + (itemsCount * 3.4);
  }

  Widget _buildSkeletonLoader() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        leading: const SizedBox(),
        title: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 180,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        actions: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const SizedBox(width: 50, height: 20),
            ),
          ),
        ],
      ),
      body: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 160),
          children: [
            // Header skeleton
            Container(
              width: 200,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            // Item cards skeleton
            ...List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Add button skeleton
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 32),
            // Where to shop section
            Container(
              width: 200,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 32),
            // Delivery address section
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(errandTaskProvider);
    final itemsCount = items.length;
    final estimatedTotal = _getEstimatedTotal(itemsCount);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF334155)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Purchase Task',
          style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0x33FFD700),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0x4DFFD700)),
            ),
            child: Text('URGENT', style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF854D0E), letterSpacing: 0.6)),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 160),
            children: [
              // ── What do you need? ──
              Row(
                children: [
                  const Icon(Icons.shopping_cart_outlined, color: Color(0xFF0068FF), size: 22),
                  const SizedBox(width: 8),
                  Text("What do you need?", style: AppFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                    child: Text('$itemsCount Item${itemsCount > 1 ? 's' : ''}', style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF64748B))),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Items list
              ...items.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: item.name,
                              onChanged: (v) => ref.read(errandTaskProvider.notifier).updateItemName(i, v),
                              style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
                              decoration: InputDecoration.collapsed(hintText: 'Item name', hintStyle: AppFonts.inter(color: const Color(0xFF94A3B8), fontSize: 16)),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              initialValue: item.details,
                              onChanged: (v) => ref.read(errandTaskProvider.notifier).updateItemDetails(i, v),
                              style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B)),
                              decoration: InputDecoration.collapsed(hintText: 'Details (Brand, size, etc.)', hintStyle: AppFonts.inter(color: const Color(0xFF94A3B8), fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => ref.read(errandTaskProvider.notifier).decrementQuantity(i),
                              child: Container(
                                width: 28, height: 28,
                                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                                child: const Icon(Icons.remove, size: 16, color: Color(0xFF475569)),
                              ),
                            ),
                            SizedBox(
                              width: 24,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return ScaleTransition(scale: animation, child: child);
                                },
                                child: Text('${item.quantity}', key: ValueKey<int>(item.quantity), textAlign: TextAlign.center, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => ref.read(errandTaskProvider.notifier).incrementQuantity(i),
                              child: Container(
                                width: 28, height: 28,
                                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                                child: const Icon(Icons.add, size: 16, color: Color(0xFF475569)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => ref.read(errandTaskProvider.notifier).removeItem(i),
                        child: Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(999)),
                          child: const Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Add Item button
              GestureDetector(
                onTap: () => ref.read(errandTaskProvider.notifier).addItem(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF0068FF).withOpacity(0.3), width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_circle_outline, color: Color(0xFF0068FF), size: 20),
                      const SizedBox(width: 8),
                      Text('Add Item', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── Where should we shop? ──
              Row(
                children: [
                  const Icon(Icons.store_outlined, color: Color(0xFF0068FF), size: 22),
                  const SizedBox(width: 8),
                  Text("Where should we shop?", style: AppFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(24)),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _storeMode = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _storeMode == 0 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: _storeMode == 0 ? const [BoxShadow(color: Color(0x0A000000), blurRadius: 4)] : null,
                          ),
                          child: Center(child: Text('Specific Store', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _storeMode == 0 ? const Color(0xFF0068FF) : const Color(0xFF64748B)))),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _storeMode = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _storeMode == 1 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: _storeMode == 1 ? const [BoxShadow(color: Color(0x0A000000), blurRadius: 4)] : null,
                          ),
                          child: Center(child: Text('Nearest Available', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _storeMode == 1 ? const Color(0xFF0068FF) : const Color(0xFF64748B)))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 18),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Whole Foods Market - Downtown',
                          hintStyle: AppFonts.inter(color: const Color(0xFF0F172A), fontSize: 16),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Delivery Address ──
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Color(0xFF0068FF), size: 22),
                  const SizedBox(width: 8),
                  Text("Delivery Address", style: AppFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    // Map Thumbnail
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: Container(
                        height: 128,
                        color: const Color(0xFFE8EFF7),
                        child: const Center(
                          child: Icon(Icons.location_pin, color: Color(0xFF0068FF), size: 40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Home', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                                const SizedBox(height: 4),
                                Text('Abuakwa, ice last stop', style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B))),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: const Color(0x1A0052CC), borderRadius: BorderRadius.circular(16)),
                            child: Text('Change', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Special Notes ──
              Text("Special Notes", style: AppFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Any special instructions for the shopper...',
                    hintStyle: AppFonts.inter(color: const Color(0xFF94A3B8), fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),

          // Sticky Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
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
                              Text('EST. TOTAL', style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 1.2)),
                              Text('₵${estimatedTotal.toStringAsFixed(2)}', style: AppFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('INCLUDES DELIVERY FEE', style: AppFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8))),
                              Row(
                                children: [
                                  const Icon(Icons.verified_outlined, color: Color(0xFF16A34A), size: 14),
                                  const SizedBox(width: 4),
                                  Text('Secure Payment', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF16A34A))),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  serviceType: ServiceType.errand,
                                  cartItems: items,
                                  subtotal: estimatedTotal,
                                  totalItems: items.length,
                                  onPlaceOrder: () => ref.read(errandTaskProvider.notifier).clearTask(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0068FF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            elevation: 0,
                            shadowColor: const Color(0x4D0052CC),
                          ),
                          label: Text('Post Errand', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          icon: const Icon(Icons.send_outlined, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
