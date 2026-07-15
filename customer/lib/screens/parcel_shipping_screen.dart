import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'parcel_review_screen.dart';

class ParcelShippingScreen extends StatefulWidget {
  final String category;
  final String senderName;
  final String recipientName;
  final String weight;
  final bool isFragile;

  const ParcelShippingScreen({
    super.key,
    required this.category,
    required this.senderName,
    required this.recipientName,
    required this.weight,
    this.isFragile = false,
  });

  @override
  State<ParcelShippingScreen> createState() => _ParcelShippingScreenState();
}

class _ParcelShippingScreenState extends State<ParcelShippingScreen> {
  int _selectedSpeed = 0; // 0: Standard, 1: Express, 2: Priority

  final _speeds = [
    {
      'name': 'Standard Delivery',
      'time': '2 – 3 business days',
      'price': 0.00,
        'icon': Icons.local_shipping_rounded,
        'badge': null,
      },
      {
        'name': 'Express Delivery',
        'time': 'Same day delivery',
        'price': 20.00,
        'icon': Icons.bolt_rounded,
        'badge': 'POPULAR',
      },
      {
        'name': 'Priority Rush',
        'time': 'Within 2 – 3 hours',
        'price': 45.00,
      'icon': Icons.rocket_launch_rounded,
      'badge': 'FASTEST',
    },
  ];

  double get _baseFee {
    switch (widget.weight) {
      case 'Under 1kg': return 10.0;
      case '1 - 5 kg':  return 15.0;
      case '5 - 10 kg': return 25.0;
      case '10kg +':    return 40.0;
      default:          return 10.0;
    }
  }

  static const double _distanceFee = 14.0; // mock 5 km, 3–7 km tier

  double get _speedSurcharge {
    switch (_selectedSpeed) {
      case 1: return 20.0;
      case 2: return 45.0;
      default: return 0.0;
    }
  }

  double get _fragileExtra => widget.isFragile ? 10.0 : 0.0;
  static const double _platformFee = 3.0;

  double get _total => _baseFee + _distanceFee + _speedSurcharge + _fragileExtra + _platformFee;

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
        title: Text('Shipping Options', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
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
                    Text('STEP 3 OF 5: DELIVERY SPEED', style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF475569), letterSpacing: 0.6)),
                    Text('60%', style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF))),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(999)),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.6,
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
              Text('How fast do you need it?', style: AppFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 6),
              Text('Choose a delivery speed that works for you.', style: AppFonts.inter(fontSize: 15, color: const Color(0xFF64748B))),
              const SizedBox(height: 24),
              ...List.generate(_speeds.length, (i) {
                final speed = _speeds[i];
                final isSelected = _selectedSpeed == i;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedSpeed = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? const Color(0xFF0068FF) : const Color(0xFFE2E8F0), width: isSelected ? 2 : 1),
                        boxShadow: isSelected ? [const BoxShadow(color: Color(0x1A0068FF), blurRadius: 12, offset: Offset(0, 4))] : const [BoxShadow(color: Color(0x08000000), blurRadius: 4)],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF0068FF) : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(speed['icon'] as IconData, color: isSelected ? Colors.white : const Color(0xFF0068FF), size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(speed['name'] as String, style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                                    if (speed['badge'] != null) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(color: const Color(0xFF0068FF), borderRadius: BorderRadius.circular(6)),
                                        child: Text(speed['badge'] as String, style: AppFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(speed['time'] as String, style: AppFonts.inter(fontSize: 13, color: const Color(0xFF64748B))),
                              ],
                            ),
                          ),
                          Text('₵${(_baseFee + _distanceFee + (speed["price"] as double) + _fragileExtra + _platformFee).toStringAsFixed(2)}', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF))),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '💡 Price based on ~5km distance estimate. Final price confirmed at pickup.',
                  style: AppFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
                ),
              ),
              if (widget.isFragile) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFFED7AA))),
                  child: Row(
                    children: [
                      const Icon(Icons.wine_bar, color: Color(0xFFEA580C), size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text('Fragile handling surcharge: +₵10.00', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFFEA580C)))),
                    ],
                  ),
                ),
              ],
            ],
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFE2E8F0))), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Total Cost', style: AppFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                        Text('₵${_total.toStringAsFixed(2)}', style: AppFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ParcelReviewScreen(
                        category: widget.category,
                        senderName: widget.senderName,
                        recipientName: widget.recipientName,
                        weight: widget.weight,
                        isFragile: widget.isFragile,
                        deliverySpeed: _speeds[_selectedSpeed]['name'] as String,
                        deliveryTime: _speeds[_selectedSpeed]['time'] as String,
                        totalCost: _total,
                      ))),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0068FF), padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                      child: Text('Continue', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
