import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'schedule_pickup_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/laundry_cart_provider.dart';

class LaundryCartScreen extends ConsumerWidget {
  final String vendorName;

  const LaundryCartScreen({super.key, required this.vendorName});

  int _getTotalItems(Map<String, int> cart) => cart.values.fold(0, (sum, qty) => sum + qty);

  double _getItemPrice(String name) {
    if (name.contains('Duvet')) return 60.0;
    if (name.contains('Suit')) return 45.0;
    if (name.contains('T-Shirt') || name.contains('T-shirt')) return 8.0;
    if (name.contains('Shirt')) return 12.0;
    if (name.contains('Pillow') || name.contains('Bedding')) return 5.0;
    return 15.0;
  }

  double _getSubtotal(Map<String, int> cart) {
    double total = 0;
    cart.forEach((name, qty) {
      total += _getItemPrice(name) * qty;
    });
    return total;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _cart = ref.watch(laundryCartProvider);
    final _totalItems = _getTotalItems(_cart);
    final double pickupFee = _cart.isEmpty ? 0 : 10.0;
    final double returnFee = _cart.isEmpty ? 0 : 10.0;
    final double serviceFee = _cart.isEmpty ? 0 : 5.0;
    final double subtotal = _getSubtotal(_cart);
    final double total = subtotal + pickupFee + returnFee + serviceFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Your Laundry Cart',
          style: AppFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              ref.read(laundryCartProvider.notifier).clearCart();
            },
            child: Text(
              'Clear',
              style: AppFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3B8A),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
            children: [
              // Vendor Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0x1A1E3B8A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: const Icon(Icons.local_laundry_service, color: Color(0xFF1E3B8A)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your items from $vendorName',
                            style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(
                                'Turnaround: 2-3 days',
                                style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Items Header
              Text(
                'Your items ($_totalItems items)',
                style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 16),

              // Items List
              if (_cart.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'Your cart is empty',
                      style: AppFonts.inter(fontSize: 16, color: const Color(0xFF64748B)),
                    ),
                  ),
                )
              else
                ..._cart.entries.map((entry) => _buildCartItem(context, ref, entry.key, entry.value)).toList(),

              if (_cart.isNotEmpty) ...[
                const SizedBox(height: 16),
                // Weight Info Callout
                Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: const Color(0x0D1E3B8A),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0x331E3B8A)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF1E3B8A), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimated weight: ~${(_totalItems * 0.5).toStringAsFixed(1)} kg',
                              style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                            ),
                            Text(
                              'Actual weight confirmed at pickup',
                              style: AppFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Add More Items
                GestureDetector(
                  onTap: () => Navigator.pop(context, _cart),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF1E3B8A), width: 2),
                    ),
                    child: Text(
                      '+ Add more items from $vendorName',
                      textAlign: TextAlign.center,
                      style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1E3B8A)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Special Instructions
                Text(
                  'Special instructions',
                  style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 96,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: 'Any general notes for your laundry...',
                      hintStyle: AppFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8)),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(height: 32),

                // Order Summary Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow('Items ($_totalItems)', '₵${subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _buildSummaryRow('Pickup', '₵${pickupFee.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _buildSummaryRow('Return delivery', '₵${returnFee.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _buildSummaryRow('Service fee', '₵${serviceFee.toStringAsFixed(2)}'),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFF1F5F9), thickness: 1),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                          Text('₵${total.toStringAsFixed(2)}', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          // Sticky Bottom Bar
          if (_cart.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, -8))],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('TOTAL PRICE', style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 1.2)),
                          Text('₵${total.toStringAsFixed(2)}', style: AppFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SchedulePickupScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0068FF),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          elevation: 0,
                        ),
                        child: Row(
                          children: [
                            Text('Continue', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                          ],
                        ),
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

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppFonts.inter(fontSize: 14, color: const Color(0xFF475569))),
        Text(value, style: AppFonts.inter(fontSize: 14, color: const Color(0xFF475569))),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, WidgetRef ref, String name, int qty) {
    final price = _getItemPrice(name);
    final total = price * qty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.checkroom, color: Color(0xFF0068FF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                          Text('Wash & Iron • ₵${price.toStringAsFixed(0)} each', style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    Text('₵${total.toStringAsFixed(0)}', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Service type changes coming soon')),
                        );
                      },
                      child: Text(
                        'Change service',
                        style: AppFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0068FF),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => ref.read(laundryCartProvider.notifier).updateQuantity(name, -1),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
                              child: const Icon(Icons.remove, size: 16, color: Color(0xFF0F172A)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return ScaleTransition(scale: animation, child: child);
                              },
                              child: Text('$qty', key: ValueKey<int>(qty), style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => ref.read(laundryCartProvider.notifier).updateQuantity(name, 1),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Color(0xFF0068FF), shape: BoxShape.circle),
                              child: const Icon(Icons.add, size: 16, color: Colors.white),
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
        ],
      ),
    );
  }
}
