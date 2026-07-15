import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import '../models/address.dart';
import '../models/errand_type.dart';
import '../models/order.dart';
import '../providers/active_order_provider.dart';
import '../providers/order_history_provider.dart';
import 'order_confirmation_screen.dart';
import '../services/order_simulation_service.dart';
import 'help_support_screen.dart';
import '../models/service_type.dart';

// Fixed estimate shown on this form; kept as a named constant so the
// Order built on submit always matches what was displayed (previously the
// '₵24.50' shown on screen was a literal string never wired to anything).
const double _kErrandEstimatedTotal = 24.50;

class ErrandFormScreen extends ConsumerStatefulWidget {
  final ErrandType errandType;
  final String title;

  const ErrandFormScreen({
    super.key,
    required this.errandType,
    required this.title,
  });

  @override
  ConsumerState<ErrandFormScreen> createState() => _ErrandFormScreenState();
}

class _ErrandFormScreenState extends ConsumerState<ErrandFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedSize = 1; // 0: Small, 1: Medium, 2: Large
  bool _isFragile = false;
  bool _isLoading = true;

  final _pickupAddrCtrl = TextEditingController();
  final _senderNameCtrl = TextEditingController();
  final _senderPhoneCtrl = TextEditingController();
  final _dropoffAddrCtrl = TextEditingController();
  final _recipientNameCtrl = TextEditingController();
  final _recipientPhoneCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _pickupAddrCtrl.dispose();
    _senderNameCtrl.dispose();
    _senderPhoneCtrl.dispose();
    _dropoffAddrCtrl.dispose();
    _recipientNameCtrl.dispose();
    _recipientPhoneCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Widget _buildSkeletonLoader() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox(),
        title: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Container(
                    width: 48,
                    height: 6,
                    margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Map skeleton
            Container(
              height: 128,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 16),
            // Section card skeleton
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 16),
            // Another section
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 16),
            // Package details
            Container(
              height: 300,
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
    if (_isLoading) return _buildSkeletonLoader();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Color(0xFF0F172A)),
        ),
        title: Text(
          widget.title == 'Pickup & Drop-off' ? 'New Delivery Request' : widget.title,
          style: AppFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
            ),
            icon: const Icon(Icons.help_outline, color: Color(0xFF0F172A)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStep(true),
                const SizedBox(width: 12),
                _buildStep(false),
                const SizedBox(width: 12),
                _buildStep(false),
              ],
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                // Map Preview (Mock)
                Container(
                  height: 128,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(24),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80&w=800',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, color: Color(0xFF0068FF), size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Confirming route...',
                            style: AppFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Pickup Details (Location A)
                _buildSectionCard(
                  title: 'Pickup Details (Location A)',
                  iconColor: const Color(0xFF0068FF),
                  children: [
                    _buildInputField(
                      'Pickup Address',
                      _pickupAddrCtrl,
                      Icons.location_searching,
                      hint: 'e.g. Buokrom Street, Kumasi',
                      required: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            'Sender Name',
                            _senderNameCtrl,
                            null,
                            hint: 'Sender full name',
                            required: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField(
                            'Phone Number',
                            _senderPhoneCtrl,
                            null,
                            hint: '0XX XXX XXXX',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Drop-off Details (Location B)
                _buildSectionCard(
                  title: 'Drop-off Details (Location B)',
                  iconColor: const Color(0xFFFFD700),
                  children: [
                    _buildInputField(
                      'Drop-off Address',
                      _dropoffAddrCtrl,
                      Icons.location_searching,
                      hint: 'e.g. Abuakwa, ICE last stop',
                      required: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            'Recipient Name',
                            _recipientNameCtrl,
                            null,
                            hint: 'Recipient full name',
                            required: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField(
                            'Phone Number',
                            _recipientPhoneCtrl,
                            null,
                            hint: '0XX XXX XXXX',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Package Details
                _buildSectionCard(
                  title: 'Package Details',
                  iconColor: null,
                  children: [
                    _buildInputField(
                      'What are you sending?',
                      _descriptionCtrl,
                      null,
                      hint: 'e.g. Documents, Pizza, Clothes...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Item Size',
                      style: AppFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildSizeOption(0, 'Small', 'Up to 2kg', Icons.inventory_2_outlined)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSizeOption(1, 'Medium', 'Up to 10kg', Icons.inventory_2)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSizeOption(2, 'Large', 'Up to 25kg', Icons.inventory_outlined)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Fragile Toggle
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0x0D0052CC),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0x330052CC)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                              ],
                            ),
                            child: const Icon(Icons.wine_bar, color: Color(0xFF0068FF)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fragile Item',
                                  style: AppFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Handle with extra care',
                                  style: AppFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isFragile,
                            onChanged: (val) => setState(() => _isFragile = val),
                            activeThumbColor: const Color(0xFF0068FF),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Sticky Footer
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ESTIMATED TOTAL',
                                style: AppFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF64748B),
                                  letterSpacing: 0.6,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₵24.50',
                                    style: AppFonts.inter(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0x1A0052CC),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '-10% Promo',
                                      style: AppFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF0068FF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('5.2 km', style: AppFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                              const SizedBox(height: 4),
                              Text('~25 min', style: AppFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;
                            final order = Order(
                              id: OrderIdGenerator.next(ServiceType.errand),
                              serviceType: ServiceType.errand,
                              items: [
                                OrderLineItem(
                                  title: widget.title,
                                  description: _descriptionCtrl.text.trim(),
                                  unitPrice: _kErrandEstimatedTotal,
                                ),
                              ],
                              subtotal: 0,
                              deliveryFee: _kErrandEstimatedTotal,
                              total: _kErrandEstimatedTotal,
                              paymentMethod: 'swiftree Wallet',
                              address: Address(
                                type: 'Pickup',
                                street: _pickupAddrCtrl.text.trim(),
                                contactPhone: _senderPhoneCtrl.text.trim(),
                              ),
                              vendorName: 'swiftree Agent',
                              placedAt: DateTime.now(),
                              eta: ServiceType.errand.defaultEta,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderConfirmationScreen(order: order),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0068FF),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Confirm Delivery Request',
                            style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(bool isActive) {
    return Container(
      width: 48,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0068FF) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Color? iconColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (iconColor != null) ...[
                Icon(Icons.circle, size: 16, color: iconColor),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: AppFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData? suffixIcon, {
    int maxLines = 1,
    String? hint,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: required
                ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null
                : null,
            style: AppFonts.inter(fontSize: 15, color: const Color(0xFF0F172A)),
            decoration: InputDecoration(
              hintText: hint ?? label,
              hintStyle: AppFonts.inter(fontSize: 15, color: const Color(0xFF94A3B8)),
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, color: const Color(0xFF94A3B8), size: 20)
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeOption(int index, String title, String subtitle, IconData icon) {
    final isSelected = _selectedSize == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedSize = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x0D0052CC) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF0068FF) : const Color(0xFFF1F5F9),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF0068FF) : const Color(0xFF94A3B8), size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
