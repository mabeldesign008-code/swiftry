import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/laundry_cart_provider.dart';
import '../widgets/address_modal.dart';
import 'checkout_screen.dart';
import '../models/service_type.dart';

class SchedulePickupScreen extends ConsumerStatefulWidget {
  const SchedulePickupScreen({super.key});

  @override
  ConsumerState<SchedulePickupScreen> createState() => _SchedulePickupScreenState();
}

class _SchedulePickupScreenState extends ConsumerState<SchedulePickupScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 1;
  bool _returnToDifferentAddress = false;
  String _pickupAddressLabel = 'Home';
  String _pickupAddressDetail = 'Osu, Oxford Street, Opposite Melcom';

  final TextEditingController _returnAddrCtrl = TextEditingController();

  final List<String> _times = ['8AM–10AM', '10AM–12PM', '12PM–2PM', '2PM–4PM', '4PM–6PM'];

  // Generated from DateTime.now() — always current
  late final List<Map<String, dynamic>> _dates;

  @override
  void initState() {
    super.initState();
    _dates = _generateDates();
  }

  @override
  void dispose() {
    _returnAddrCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _generateDates() {
    final now = DateTime.now();
    return List.generate(5, (i) {
      final date = now.add(Duration(days: i + 1));
      return {
        'dayName': _shortDay(date.weekday),
        'day': date.day.toString(),
        'month': _shortMonth(date.month),
        'full': date,
      };
    });
  }

  String _shortDay(int w) => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][w - 1];
  String _shortMonth(int m) => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m - 1];
  String _fullDay(int w) => ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][w - 1];

  String get _estimatedReturn {
    final selected = _dates[_selectedDateIndex]['full'] as DateTime;
    final returnDate = selected.add(const Duration(days: 3));
    return '${_fullDay(returnDate.weekday)}, ${returnDate.day} ${_shortMonth(returnDate.month)}';
  }

  double _getItemPrice(String name) {
    if (name.contains('Duvet')) return 60.0;
    if (name.contains('Suit')) return 45.0;
    if (name.contains('T-Shirt') || name.contains('T-shirt')) return 8.0;
    if (name.contains('Shirt')) return 12.0;
    if (name.contains('Pillow') || name.contains('Bedding')) return 5.0;
    return 15.0;
  }

  Future<void> _changeAddress() async {
    final result = await showModalBottomSheet<Address>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddressModal(),
    );
    if (result != null && mounted) {
      setState(() {
        _pickupAddressLabel = result.type;
        _pickupAddressDetail = result.displayLabel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final laundryCart = ref.watch(laundryCartProvider);
    final totalItems = ref.read(laundryCartProvider.notifier).totalItems;
    final subtotal = laundryCart.entries.fold(0.0, (sum, e) => sum + _getItemPrice(e.key) * e.value);
    final pickupFee = laundryCart.isEmpty ? 0.0 : 10.0;
    final returnFee = laundryCart.isEmpty ? 0.0 : 10.0;
    final serviceFee = laundryCart.isEmpty ? 0.0 : 5.0;
    final grandTotal = subtotal + pickupFee + returnFee + serviceFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Schedule Pickup',
            style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE2E8F0)),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 160),
            children: [

              // ── PICKUP FROM ────────────────────────────────────────────
              Text('PICKUP FROM',
                  style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 0.7)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 4)],
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: const Color(0x1A0068FF), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.home_rounded, color: Color(0xFF0068FF)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_pickupAddressLabel,
                              style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                          const SizedBox(height: 2),
                          Text(_pickupAddressDetail,
                              style: AppFonts.inter(fontSize: 13, color: const Color(0xFF64748B))),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _changeAddress,
                            child: Text('Change Address',
                                style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF0068FF))),
                          ),
                        ],
                      ),
                    ),
                    // Map placeholder (no broken API key)
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EFF7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(child: Icon(Icons.map_rounded, color: Color(0xFF0068FF), size: 34)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── RETURN TO ─────────────────────────────────────────────
              Text('RETURN TO',
                  style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 0.7)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 4)],
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        _returnToDifferentAddress ? Icons.circle_outlined : Icons.check_circle_rounded,
                        color: _returnToDifferentAddress ? const Color(0xFFCBD5E1) : const Color(0xFF0068FF),
                      ),
                      title: Text('Same as pickup address',
                          style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xFF334155))),
                      onTap: () => setState(() => _returnToDifferentAddress = false),
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    ListTile(
                      title: Text('Deliver to a different address',
                          style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xFF334155))),
                      trailing: Switch(
                        value: _returnToDifferentAddress,
                        onChanged: (val) => setState(() => _returnToDifferentAddress = val),
                        activeColor: const Color(0xFF0068FF),
                      ),
                    ),
                    // Address input revealed when toggled on
                    if (_returnToDifferentAddress) ...[
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: TextField(
                          controller: _returnAddrCtrl,
                          style: AppFonts.inter(fontSize: 14, color: const Color(0xFF0F172A)),
                          decoration: InputDecoration(
                            hintText: 'Enter return delivery address...',
                            hintStyle: AppFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8)),
                            prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF0068FF), size: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF0068FF), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── PICKUP DATE ───────────────────────────────────────────
              Text('PICKUP DATE',
                  style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 0.7)),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_dates.length, (index) {
                    final date = _dates[index];
                    final isSelected = _selectedDateIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDateIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 12),
                        width: 72,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF0068FF) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0)),
                          boxShadow: isSelected
                              ? [BoxShadow(color: const Color(0xFF0068FF).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(date['dayName']!,
                                style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w500,
                                    color: isSelected ? Colors.white70 : const Color(0xFF64748B))),
                            const SizedBox(height: 4),
                            Text(date['day']!,
                                style: AppFonts.inter(fontSize: 24, fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : const Color(0xFF0F172A))),
                            const SizedBox(height: 4),
                            Text(date['month']!,
                                style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w500,
                                    color: isSelected ? Colors.white70 : const Color(0xFF64748B))),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 32),

              // ── PICKUP TIME ───────────────────────────────────────────
              Text('PICKUP TIME',
                  style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 0.7)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: List.generate(_times.length, (index) {
                  final isSelected = _selectedTimeIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTimeIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF0068FF) : Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0)),
                        boxShadow: isSelected
                            ? [BoxShadow(color: const Color(0xFF0068FF).withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))]
                            : [],
                      ),
                      child: Text(_times[index],
                          style: AppFonts.inter(fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? Colors.white : const Color(0xFF0F172A))),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // ── ESTIMATED RETURN ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFEF3C7)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.bolt_rounded, color: Color(0xFFD97706)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Estimated return',
                              style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF78350F))),
                          const SizedBox(height: 2),
                          Text(_estimatedReturn,
                              style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                          const SizedBox(height: 4),
                          Text("Based on vendor's 2–3 day turnaround",
                              style: AppFonts.inter(fontSize: 12, color: const Color(0xB392400E))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Bottom Bar ─────────────────────────────────────────────────
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Price summary row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total',
                            style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF64748B))),
                        Text('\u20b5${grandTotal.toStringAsFixed(2)}',
                            style: AppFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          final cartList = laundryCart.entries.map((e) => {
                            'title': e.key,
                            'price': _getItemPrice(e.key),
                            'quantity': e.value,
                          }).toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutScreen(
                                serviceType: ServiceType.laundry,
                                cartItems: cartList,
                                subtotal: subtotal,
                                totalItems: totalItems,
                                onPlaceOrder: () => ref.read(laundryCartProvider.notifier).clearCart(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0068FF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text('Continue to Payment',
                            style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
}
