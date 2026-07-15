import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import '../models/service_type.dart';
import '../models/cart_item.dart';
import 'checkout_screen.dart';

class ParcelReviewScreen extends StatelessWidget {
  final String category;
  final String senderName;
  final String recipientName;
  final String weight;
  final bool isFragile;
  final String deliverySpeed;
  final String deliveryTime;
  final double totalCost;

  const ParcelReviewScreen({
    super.key,
    required this.category,
    required this.senderName,
    required this.recipientName,
    required this.weight,
    required this.isFragile,
    required this.deliverySpeed,
    required this.deliveryTime,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
        ),
        title: Text('Review & Confirm', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('STEP 4 OF 5: REVIEW', style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF475569), letterSpacing: 0.6)),
                    Text('80%', style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF))),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 6, width: double.infinity,
                  decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(999)),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft, widthFactor: 0.8,
                    child: Container(decoration: BoxDecoration(color: const Color(0xFF0068FF), borderRadius: BorderRadius.circular(999))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 140),
            children: [
              Text('Order Summary', style: AppFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 6),
              Text('Review your parcel details before placing the order.', style: AppFonts.inter(fontSize: 15, color: const Color(0xFF64748B))),
              const SizedBox(height: 24),

              _card(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Parcel Details'),
                  const SizedBox(height: 14),
                  _row('Category', category),
                  _row('Weight', weight),
                  if (isFragile) _row('Handling', '⚠️ Fragile — extra care'),
                ],
              )),
              const SizedBox(height: 16),

              _card(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Sender'),
                  const SizedBox(height: 14),
                  _row('Name', senderName.isEmpty ? 'Not provided' : senderName),
                ],
              )),
              const SizedBox(height: 16),

              _card(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Recipient'),
                  const SizedBox(height: 14),
                  _row('Name', recipientName.isEmpty ? 'Not provided' : recipientName),
                ],
              )),
              const SizedBox(height: 16),

              _card(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Delivery'),
                  const SizedBox(height: 14),
                  _row('Speed', deliverySpeed),
                  _row('Estimated Time', deliveryTime),
                ],
              )),
              const SizedBox(height: 16),

              _card(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Price Breakdown'),
                  const SizedBox(height: 14),
                  _priceRow('Delivery Fee', totalCost - (isFragile ? 10.0 : 0)),
                  if (isFragile) _priceRow('Fragile Surcharge', 10.0),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 12),
                  _priceRow('Total', totalCost, bold: true),
                ],
              )),
            ],
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFE2E8F0))), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final cartItem = CartItem(
                        title: '$category Parcel',
                        description: 'From: $senderName · To: $recipientName · $weight · $deliverySpeed',
                        price: totalCost,
                        quantity: 1,
                        restaurantId: 'parcel',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutScreen(
                            serviceType: ServiceType.parcel,
                            cartItems: [cartItem],
                            subtotal: totalCost,
                            totalItems: 1,
                            onPlaceOrder: () {},
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0068FF), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    child: Text('Proceed to Payment', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
    width: double.infinity, padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0)), boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8)]),
    child: child,
  );

  Widget _sectionTitle(String t) => Text(t, style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)));

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B))),
        Text(value, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
      ],
    ),
  );

  Widget _priceRow(String label, double amount, {bool bold = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppFonts.inter(fontSize: bold ? 15 : 14, fontWeight: bold ? FontWeight.w700 : FontWeight.normal, color: bold ? const Color(0xFF0F172A) : const Color(0xFF64748B))),
        Text('₵${amount.toStringAsFixed(2)}', style: AppFonts.inter(fontSize: bold ? 16 : 14, fontWeight: bold ? FontWeight.w700 : FontWeight.w500, color: const Color(0xFF0F172A))),
      ],
    ),
  );
}
