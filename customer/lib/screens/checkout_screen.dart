import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'order_confirmation_screen.dart';
import '../models/service_type.dart';
import '../models/order.dart';
import '../providers/active_order_provider.dart';
import '../providers/order_history_provider.dart';
import '../providers/voucher_provider.dart';
import '../providers/wallet_provider.dart';
import '../widgets/address_modal.dart';
import '../widgets/schedule_order_modal.dart';
import '../services/order_simulation_service.dart';

// ── Colour tokens ──────────────────────────────────────────────────────────────────────────────────────────
const Color _primary = Color(0xFF0068FF);
const Color _dark = Color(0xFF0F172A);
const Color _mid = Color(0xFF64748B);
const Color _light = Color(0xFFF8FAFC);
const Color _border = Color(0xFFE8EDF2);

class CheckoutScreen extends ConsumerStatefulWidget {
  final ServiceType serviceType;
  final List<dynamic> cartItems;
  final double subtotal;
  final int totalItems;
  final VoidCallback onPlaceOrder;
  // Optional extras
  final String? marketName;
  final String? specialInstructions;
  final String? vendorName;

  const CheckoutScreen({
    Key? key,
    required this.serviceType,
    required this.cartItems,
    required this.subtotal,
    required this.totalItems,
    required this.onPlaceOrder,
    this.marketName,
    this.specialInstructions,
    this.vendorName,
  }) : super(key: key);

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _selectedPayment = 'MTN Mobile Money';
  bool _isPlacing = false;
  String? _prescriptionImagePath; // Pharmacy prescription

  // Delivery address — previously hardcoded and never actually editable;
  // tapping "Change" opened AddressModal but its result was discarded.
  Address _address = const Address(
    type: 'Home',
    street: 'Osu, Oxford Street',
    NigeriaPost: 'GA-123-4567',
  );

  // Promo code — previously the "Apply" button was a no-op (onPressed: () {}).
  final TextEditingController _promoCtrl = TextEditingController();
  String? _appliedPromoCode;
  double _discount = 0;

  // Delivery options — previously checkout had no generic "note for rider",
  // "leave at door", or "schedule for later" controls at all.
  final TextEditingController _deliveryNoteCtrl = TextEditingController();
  bool _leaveAtDoor = false;
  DateTime? _scheduledFor;

  // "Send to someone" (gift) — lets the orderer deliver to a different
  // recipient than themselves.
  bool _isGift = false;
  final TextEditingController _recipientNameCtrl = TextEditingController();
  final TextEditingController _recipientPhoneCtrl = TextEditingController();
  final TextEditingController _giftMessageCtrl = TextEditingController();

  @override
  void dispose() {
    _promoCtrl.dispose();
    _deliveryNoteCtrl.dispose();
    _recipientNameCtrl.dispose();
    _recipientPhoneCtrl.dispose();
    _giftMessageCtrl.dispose();
    super.dispose();
  }

  // ── Computed values ─────────────────────────────────────────────────────
  bool get _isErrandOrMarket =>
      widget.serviceType == ServiceType.errand ||
      widget.serviceType == ServiceType.market;
  bool get _isShop => widget.serviceType == ServiceType.shop;
  bool get _isLaundry => widget.serviceType == ServiceType.laundry;
  bool get _isPharmacy => widget.serviceType == ServiceType.pharmacy;
  // Laundry has 2 trips = 2× delivery fee
  double get _deliveryFee => widget.cartItems.isEmpty ? 0 : (_isLaundry ? 5.00 : 5.00);
  double get _returnDeliveryFee => _isLaundry ? 5.00 : 0;
  double get _serviceFee => widget.cartItems.isEmpty ? 0 : 2.50;
  double get _grandTotal {
    final total = widget.subtotal + _deliveryFee + _returnDeliveryFee + _serviceFee - _discount;
    return total < 0 ? 0 : total;
  }

  /// Vendor name to attach to the order. Falls back to a sensible
  /// service-type-specific label when the caller didn't supply one, instead
  /// of the previous generic "Restaurant"/"Agent" placeholders that ignored
  /// the actual vendor tracked on the cart items.
  String get _effectiveVendorName {
    if (widget.vendorName != null && widget.vendorName!.trim().isNotEmpty) {
      return widget.vendorName!.trim();
    }
    if (widget.marketName != null && widget.marketName!.trim().isNotEmpty) {
      return widget.marketName!.trim();
    }
    switch (widget.serviceType) {
      case ServiceType.food:
        return 'Restaurant';
      case ServiceType.groceries:
        return 'Grocery Store';
      case ServiceType.shop:
        return 'Store';
      case ServiceType.pharmacy:
        return 'Pharmacy';
      case ServiceType.laundry:
        return 'Laundry Service';
      case ServiceType.errand:
        return 'swiftree Agent';
      case ServiceType.market:
        return 'Market Agent';
      case ServiceType.parcel:
        return 'Parcel Rider';
      case ServiceType.bill:
        return 'Bill Payment';
      case ServiceType.queue:
        return 'swiftree Agent';
    }
  }

  bool get _isCodDisabled {
    if (_isShop) return true;
    if (_grandTotal > 200.0) return true;
    if (DateTime.now().hour >= 21) return true;
    return false;
  }

  String get _codDisabledReason {
    if (_isShop) return 'Not available for Shop orders';
    if (DateTime.now().hour >= 21) return 'Not available after 9 PM';
    if (_grandTotal > 200.0) return 'Not available above ₵200';
    return 'Pay rider in cash on delivery';
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppFonts.inter(color: Colors.white)),
        backgroundColor: isError ? Colors.red[600] : const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _onPlaceOrder() async {
    // Re-validate every requirement at submit time — previously none of
    // these were checked here at all, so a stale/invalid payment selection,
    // a missing prescription, or an insufficient wallet balance would all
    // silently succeed.
    if (_selectedPayment == 'Cash on Delivery' && _isCodDisabled) {
      _showMessage(
        'Cash on Delivery is no longer available ($_codDisabledReason). '
        'Please choose another payment method.',
      );
      return;
    }
    if (_isPharmacy && _prescriptionImagePath == null) {
      _showMessage('Please upload your prescription before placing the order.');
      return;
    }
    if (_selectedPayment == 'swiftree Wallet') {
      final balance = ref.read(walletProvider);
      if (balance < _grandTotal) {
        _showMessage(
          'Insufficient wallet balance (₵${balance.toStringAsFixed(2)}). '
          'Please top up or choose another payment method.',
        );
        return;
      }
    }
    if (_isGift &&
        (_recipientNameCtrl.text.trim().isEmpty || _recipientPhoneCtrl.text.trim().isEmpty)) {
      _showMessage('Please enter the recipient\'s name and phone number.');
      return;
    }

    setState(() => _isPlacing = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final order = Order(
      id: OrderIdGenerator.next(widget.serviceType),
      serviceType: widget.serviceType,
      items: widget.cartItems.map((raw) {
        final item = _extractItem(raw);
        return OrderLineItem(
          title: item['title'] as String,
          description: item['desc'] as String,
          unitPrice: item['price'] as double,
          quantity: item['qty'] as int,
          imageUrl: item['imageUrl'] as String?,
        );
      }).toList(),
      subtotal: widget.subtotal,
      deliveryFee: _deliveryFee,
      returnDeliveryFee: _returnDeliveryFee,
      serviceFee: _serviceFee,
      discount: _discount,
      total: _grandTotal,
      paymentMethod: _selectedPayment,
      address: _address,
      vendorName: _effectiveVendorName,
      specialInstructions: _deliveryNoteCtrl.text.trim().isEmpty
          ? widget.specialInstructions
          : [
              if (widget.specialInstructions != null) widget.specialInstructions!,
              _deliveryNoteCtrl.text.trim(),
            ].join(' · '),
      placedAt: DateTime.now(),
      eta: widget.serviceType.defaultEta,
      scheduledFor: _scheduledFor,
      leaveAtDoor: _leaveAtDoor,
      recipientName: _isGift ? _recipientNameCtrl.text.trim() : null,
      recipientPhone: _isGift ? _recipientPhoneCtrl.text.trim() : null,
      giftMessage: _isGift && _giftMessageCtrl.text.trim().isNotEmpty ? _giftMessageCtrl.text.trim() : null,
    );

    if (_selectedPayment == 'swiftree Wallet') {
      ref.read(walletProvider.notifier).deduct(_grandTotal);
    }
    if (_appliedPromoCode != null) {
      ref.read(voucherProvider.notifier).markRedeemed(_appliedPromoCode!);
    }

    // Record the order so it actually shows up in "My Orders" / order
    // detail, and surface it as the active order on the home screen —
    // previously neither of these ever happened.
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

    widget.onPlaceOrder();

    // Start auto-progression simulation — fires order state changes,
    // in-app notifications and the rider map movement automatically.
    OrderSimulationService.start(ref: ref, context: context, order: order);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(order: order),
      ),
    );
  }

  void _applyPromoCode() {
    if (_appliedPromoCode != null) {
      // "Remove" tapped.
      setState(() {
        _appliedPromoCode = null;
        _discount = 0;
        _promoCtrl.clear();
      });
      return;
    }

    final code = _promoCtrl.text.trim().toUpperCase();
    if (code.isEmpty) {
      _showMessage('Enter a promo code first.');
      return;
    }
    final voucher = ref.read(voucherProvider.notifier).byCode(code);
    if (voucher == null) {
      _showMessage('"$code" is not a valid promo code.');
      return;
    }
    if (widget.subtotal < voucher.minSpend) {
      _showMessage('Minimum spend for this code is ₵${voucher.minSpend.toStringAsFixed(0)}.');
      return;
    }
    final discount = voucher.discountFor(widget.subtotal);
    setState(() {
      _appliedPromoCode = code;
      _discount = discount;
    });
    _showMessage(
      'Promo "$code" applied — ₵${discount.toStringAsFixed(2)} off',
      isError: false,
    );
  }

  // ── Extract item fields safely from dynamic cart list ────────────────────
  Map<String, dynamic> _extractItem(dynamic item) {
    String title = 'Item';
    double price = 0.0;
    int qty = 1;
    String desc = '';
    String? imageUrl;

    try {
      if (item is Map) {
        title = item['title'] ?? item['name'] ?? title;
        price = (item['price'] ?? 0.0).toDouble();
        qty = item['quantity'] ?? qty;
        desc = item['description'] ?? '';
        imageUrl = item['imageUrl'];
      } else {
        try { title = item.title; } catch (_) { try { title = item.name; } catch (_) {} }
        try { price = item.price.toDouble(); } catch (_) {}
        try { qty = item.quantity; } catch (_) {}
        try { desc = item.description; } catch (_) {}
        try { imageUrl = item.imageUrl; } catch (_) {}
      }
    } catch (_) {}

    return {'title': title, 'price': price, 'qty': qty, 'desc': desc, 'imageUrl': imageUrl};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isErrandOrMarket) _buildEstimateWarning(),
                  _buildSectionCard(children: [
                    _buildSectionTitle('Delivery Address', icon: Icons.location_on_rounded, iconColor: _primary),
                    const SizedBox(height: 12),
                    _buildAddressRow(),
                  ]),
                  const SizedBox(height: 14),
                  _buildSectionCard(children: [
                    _buildSectionTitle('Delivery Options', icon: Icons.schedule_rounded, iconColor: Colors.indigo),
                    const SizedBox(height: 12),
                    _buildScheduleRow(),
                    const SizedBox(height: 14),
                    _buildDeliveryNoteField(),
                    const SizedBox(height: 4),
                    _buildLeaveAtDoorToggle(),
                  ]),
                  const SizedBox(height: 14),
                  _buildSectionCard(children: [
                    _buildGiftToggleRow(),
                    if (_isGift) ...[
                      const SizedBox(height: 14),
                      _buildGiftFields(),
                    ],
                  ]),
                  const SizedBox(height: 14),
                  // Market name banner
                  if (widget.marketName != null)
                    _buildInfoBanner(
                      icon: Icons.store_mall_directory_rounded,
                      color: const Color(0xFF16A34A),
                      bgColor: const Color(0xFFF0FDF4),
                      borderColor: const Color(0xFFBBF7D0),
                      text: 'Shopping at: ${widget.marketName}. This is a pre-authorization — the rider will buy your items and settle the final cost.',
                    ),
                  if (widget.marketName != null) const SizedBox(height: 14),
                  // Laundry 2-trip banner
                  if (_isLaundry)
                    _buildInfoBanner(
                      icon: Icons.local_laundry_service_rounded,
                      color: Colors.indigo,
                      bgColor: const Color(0xFFEEF2FF),
                      borderColor: const Color(0xFFC7D2FE),
                      text: 'Laundry service involves 2 trips: pickup from you to the laundry vendor, and return delivery after processing (24–48 hrs).',
                    ),
                  if (_isLaundry) const SizedBox(height: 14),
                  // Pharmacy prescription banner
                  if (_isPharmacy)
                    _buildInfoBanner(
                      icon: Icons.medical_services_rounded,
                      color: const Color(0xFFDC2626),
                      bgColor: const Color(0xFFFFF1F2),
                      borderColor: const Color(0xFFFECACA),
                      text: 'Some items may require a prescription. Upload it below to avoid delays.',
                    ),
                  if (_isPharmacy) const SizedBox(height: 14),
                  if (_isPharmacy)
                    _buildSectionCard(children: [
                      _buildSectionTitle('Prescription Upload', icon: Icons.upload_file_rounded, iconColor: const Color(0xFFDC2626)),
                      const SizedBox(height: 12),
                      _buildPrescriptionUpload(),
                    ]),
                  if (_isPharmacy) const SizedBox(height: 14),
                  _buildSectionCard(children: [
                    _buildSectionTitle(
                      'Order Summary',
                      icon: Icons.receipt_long_rounded,
                      iconColor: Colors.deepPurple,
                      badge: '${widget.totalItems} item${widget.totalItems == 1 ? '' : 's'}',
                    ),
                    const SizedBox(height: 14),
                    if (widget.cartItems.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text('Your cart is empty', style: AppFonts.inter(color: _mid)),
                        ),
                      )
                    else
                      ...widget.cartItems.map((raw) {
                        final item = _extractItem(raw);
                        return _buildOrderItem(item);
                      }),
                    _buildDivider(),
                    _buildTotalRow('Subtotal', '₵${widget.subtotal.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    if (_isLaundry) ...[
                      _buildTotalRow('Pickup delivery fee', '₵${_deliveryFee.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _buildTotalRow('Return delivery fee', '₵${_returnDeliveryFee.toStringAsFixed(2)}'),
                    ] else
                      _buildTotalRow(
                        _isErrandOrMarket ? 'Agent rate' : 'Delivery fee',
                        '₵${_deliveryFee.toStringAsFixed(2)}',
                      ),
                    const SizedBox(height: 8),
                    _buildTotalRow('Service fee', '₵${_serviceFee.toStringAsFixed(2)}'),
                    if (_discount > 0) ...[
                      const SizedBox(height: 8),
                      _buildTotalRow(
                        'Promo ($_appliedPromoCode)',
                        '-₵${_discount.toStringAsFixed(2)}',
                        valueColor: const Color(0xFF16A34A),
                      ),
                    ],
                    _buildDivider(),
                    _buildTotalRow(
                      'Total',
                      '₵${_grandTotal.toStringAsFixed(2)}',
                      isBold: true,
                      valueColor: _primary,
                    ),
                  ]),
                  const SizedBox(height: 14),
                  _buildSectionCard(children: [
                    _buildSectionTitle('Payment Method', icon: Icons.payment_rounded, iconColor: Colors.teal),
                    if (_isErrandOrMarket)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Cash on Delivery disabled for Errand & Market runs.',
                          style: AppFonts.inter(fontSize: 12, color: Colors.red[600]),
                        ),
                      ),
                    const SizedBox(height: 14),
                    _buildPaymentCard(
                      id: 'MTN Mobile Money',
                      label: 'MTN Mobile Money',
                      sub: '024 XXX XXXX',
                      gradient: const LinearGradient(colors: [Color(0xFFFFCC00), Color(0xFFFF8C00)]),
                      icon: Icons.phone_android_rounded,
                    ),
                    const SizedBox(height: 10),
                    Consumer(
                      builder: (context, ref, _) {
                        final balance = ref.watch(walletProvider);
                        return _buildPaymentCard(
                          id: 'swiftree Wallet',
                          label: 'swiftree Wallet',
                          sub: 'Balance: ₵${balance.toStringAsFixed(2)}',
                          gradient: LinearGradient(colors: [_primary, _primary.withOpacity(0.7)]),
                          icon: Icons.account_balance_wallet_rounded,
                        );
                      },
                    ),
                    if (!_isErrandOrMarket) ...[
                      const SizedBox(height: 10),
                      _buildPaymentCard(
                        id: 'Cash on Delivery',
                        label: 'Cash on Delivery',
                        sub: _codDisabledReason,
                        gradient: const LinearGradient(colors: [Color(0xFF22C55E), Color(0xFF16A34A)]),
                        icon: Icons.money_rounded,
                        isDisabled: _isCodDisabled,
                      ),
                    ],
                  ]),
                  const SizedBox(height: 14),
                  // Promo Code
                  _buildSectionCard(children: [
                    _buildSectionTitle('Promo Code', icon: Icons.local_offer_rounded, iconColor: Colors.orange),
                    const SizedBox(height: 12),
                    _buildPromoField(),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildPlaceOrderBar(),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0052CC), Color(0xFF0084FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 20),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isErrandOrMarket ? 'Pre-Authorize Order' : 'Checkout',
                      style: AppFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    Text(
                      '${widget.totalItems} item${widget.totalItems == 1 ? '' : 's'} · ${widget.serviceType.label}',
                      style: AppFonts.inter(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '₵${_grandTotal.toStringAsFixed(2)}',
                  style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section Card container ────────────────────────────────────────────────
  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSectionTitle(String title, {required IconData icon, required Color iconColor, String? badge}) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 17, color: iconColor),
        ),
        const SizedBox(width: 10),
        Text(title, style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: _dark)),
        if (badge != null) ...[
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(badge, style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: _primary)),
          ),
        ],
      ],
    );
  }

  // ── Address ───────────────────────────────────────────────────────────────
  Widget _buildAddressRow() {
    final line2 = _address.street.isNotEmpty ? _address.street : _address.displayLabel;
    final String? line3 = _address.NigeriaPost.isNotEmpty
        ? 'GPS: ${_address.NigeriaPost}'
        : (_address.what3words.isNotEmpty ? '///${_address.what3words}' : null);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: _primary.withOpacity(0.08), shape: BoxShape.circle),
          child: const Icon(Icons.home_rounded, color: _primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_address.type.toUpperCase(), style: AppFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: _mid, letterSpacing: 0.8)),
              const SizedBox(height: 3),
              Text(line2, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
              if (line3 != null) ...[
                const SizedBox(height: 2),
                Text(line3, style: AppFonts.inter(fontSize: 12, color: _mid)),
              ],
            ],
          ),
        ),
        TextButton(
          onPressed: () async {
            final result = await showModalBottomSheet<Address>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => AddressModal(initial: _address),
            );
            if (result != null && mounted) {
              setState(() => _address = result);
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: _primary,
            padding: EdgeInsets.zero,
            minimumSize: const Size(48, 32),
          ),
          child: Text('Change', style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: _primary)),
        ),
      ],
    );
  }


  // ── Schedule for later ────────────────────────────────────────────────────
  Widget _buildScheduleRow() {
    final label = _scheduledFor == null
        ? 'Deliver Now'
        : 'Scheduled: ${_formatScheduled(_scheduledFor!)}';
    return GestureDetector(
      onTap: () async {
        final result = await showModalBottomSheet<DateTime?>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ScheduleOrderModal(initial: _scheduledFor),
        );
        if (!mounted) return;
        setState(() => _scheduledFor = result);
      },
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.08), shape: BoxShape.circle),
            child: Icon(_scheduledFor == null ? Icons.bolt_rounded : Icons.calendar_month_rounded, color: Colors.indigo, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WHEN', style: AppFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: _mid, letterSpacing: 0.8)),
                const SizedBox(height: 3),
                Text(label, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
              ],
            ),
          ),
          Text('Change', style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: _primary)),
        ],
      ),
    );
  }

  

  String _formatScheduled(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day} ${months[dt.month - 1]}, $hour12:00 $ampm';
  }

  // ── Delivery note + leave-at-door ────────────────────────────────────────
  Widget _buildDeliveryNoteField() {
    return TextField(
      controller: _deliveryNoteCtrl,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: 'Add a note for your rider (e.g. gate code, landmark)',
        hintStyle: AppFonts.inter(fontSize: 13, color: _mid),
        filled: true,
        fillColor: _light,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primary, width: 2)),
      ),
      style: AppFonts.inter(fontSize: 13),
    );
  }

  Widget _buildLeaveAtDoorToggle() {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: _leaveAtDoor,
      onChanged: (v) => setState(() => _leaveAtDoor = v),
      activeThumbColor: _primary,
      title: Text('Leave at the door', style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
      subtitle: Text('Rider will drop off without contact', style: AppFonts.inter(fontSize: 11, color: _mid)),
    );
  }

  // ── Send to someone (gift) ───────────────────────────────────────────────
  Widget _buildGiftToggleRow() {
    return Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: Colors.pink.withOpacity(0.08), shape: BoxShape.circle),
          child: const Icon(Icons.card_giftcard_rounded, color: Colors.pink, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Send to someone else', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: _dark)),
              Text('Deliver this as a gift to a friend or family member', style: AppFonts.inter(fontSize: 12, color: _mid)),
            ],
          ),
        ),
        Switch(
          value: _isGift,
          onChanged: (v) => setState(() => _isGift = v),
          activeThumbColor: _primary,
        ),
      ],
    );
  }

  Widget _buildGiftFields() {
    return Column(
      children: [
        TextField(
          controller: _recipientNameCtrl,
          decoration: InputDecoration(
            hintText: "Recipient's name",
            hintStyle: AppFonts.inter(fontSize: 13, color: _mid),
            filled: true,
            fillColor: _light,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primary, width: 2)),
          ),
          style: AppFonts.inter(fontSize: 13),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _recipientPhoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "Recipient's phone number",
            hintStyle: AppFonts.inter(fontSize: 13, color: _mid),
            filled: true,
            fillColor: _light,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primary, width: 2)),
          ),
          style: AppFonts.inter(fontSize: 13),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _giftMessageCtrl,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Add a gift message (optional)',
            hintStyle: AppFonts.inter(fontSize: 13, color: _mid),
            filled: true,
            fillColor: _light,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primary, width: 2)),
          ),
          style: AppFonts.inter(fontSize: 13),
        ),
      ],
    );
  }

  // ── Order Item row ────────────────────────────────────────────────────────
  Widget _buildOrderItem(Map<String, dynamic> item) {
    final String title = item['title'];
    final double price = item['price'];
    final int qty = item['qty'];
    final String desc = item['desc'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('$qty×', style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: _primary)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _dark), maxLines: 1, overflow: TextOverflow.ellipsis),
                if (desc.isNotEmpty)
                  Text(desc, style: AppFonts.inter(fontSize: 11, color: _mid), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('₵${(price * qty).toStringAsFixed(2)}', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: _dark)),
        ],
      ),
    );
  }

  // ── Payment card ──────────────────────────────────────────────────────────
  Widget _buildPaymentCard({
    required String id,
    required String label,
    required String sub,
    required LinearGradient gradient,
    required IconData icon,
    bool isDisabled = false,
  }) {
    final bool selected = !isDisabled && _selectedPayment == id;
    return GestureDetector(
      onTap: isDisabled ? null : () => setState(() => _selectedPayment = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? _primary.withOpacity(0.04) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? _primary : _border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Opacity(
          opacity: isDisabled ? 0.4 : 1,
          child: Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: _dark)),
                    const SizedBox(height: 2),
                    Text(sub, style: AppFonts.inter(fontSize: 12, color: _mid)),
                  ],
                ),
              ),
              Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: selected ? _primary : _border, width: 2),
                  color: selected ? _primary : Colors.transparent,
                ),
                child: selected
                    ? const Icon(Icons.check, color: Colors.white, size: 13)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Promo code field ──────────────────────────────────────────────────────
  Widget _buildPromoField() {
    final bool applied = _appliedPromoCode != null;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _promoCtrl,
            enabled: !applied,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'Enter promo code',
              hintStyle: AppFonts.inter(fontSize: 14, color: _mid),
              filled: true,
              fillColor: applied ? const Color(0xFFF0FDF4) : _light,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _primary, width: 2),
              ),
            ),
            style: AppFonts.inter(fontSize: 14),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _applyPromoCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: applied ? Colors.red[600] : _primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: Text(applied ? 'Remove' : 'Apply', style: AppFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  // ── Estimate warning ──────────────────────────────────────────────────────
  Widget _buildEstimateWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFD97706), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Prices are estimates. The final amount will be confirmed via receipt by the rider.',
              style: AppFonts.inter(fontSize: 12, color: const Color(0xFF92400E), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ── Totals row ────────────────────────────────────────────────────────────
  Widget _buildTotalRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppFonts.inter(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? _dark : _mid,
          ),
        ),
        Text(
          value,
          style: AppFonts.inter(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: valueColor ?? _dark,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: List.generate(
          30,
          (i) => Expanded(
            child: Container(
              height: 1,
              color: i.isEven ? _border : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  // ── Info Banner ───────────────────────────────────────────────────────────
  Widget _buildInfoBanner({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required Color borderColor,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: AppFonts.inter(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                    height: 1.5)),
          ),
        ],
      ),
    );
  }

  // ── Prescription Upload ────────────────────────────────────────────────────
  Widget _buildPrescriptionUpload() {
    return GestureDetector(
      onTap: () {
        // In a real app: use image_picker or file_picker.
        // For now, simulate selection.
        setState(() {
          _prescriptionImagePath = 'prescription_selected';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prescription selected ✓',
                style: AppFonts.inter(color: Colors.white)),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _prescriptionImagePath != null
              ? const Color(0xFFF0FDF4)
              : _light,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _prescriptionImagePath != null
                ? const Color(0xFF16A34A)
                : _border,
            width: _prescriptionImagePath != null ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _prescriptionImagePath != null
                    ? const Color(0xFF16A34A).withOpacity(0.12)
                    : const Color(0xFFDC2626).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _prescriptionImagePath != null
                    ? Icons.check_circle_rounded
                    : Icons.upload_file_rounded,
                color: _prescriptionImagePath != null
                    ? const Color(0xFF16A34A)
                    : const Color(0xFFDC2626),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _prescriptionImagePath != null
                        ? 'Prescription uploaded'
                        : 'Upload Prescription',
                    style: AppFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _dark),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _prescriptionImagePath != null
                        ? 'Tap to change the document'
                        : 'Tap to take a photo or choose a file',
                    style: AppFonts.inter(fontSize: 12, color: _mid),
                  ),
                ],
              ),
            ),
            if (_prescriptionImagePath != null)
              IconButton(
                onPressed: () =>
                    setState(() => _prescriptionImagePath = null),
                icon: const Icon(Icons.close_rounded,
                    color: Color(0xFFDC2626), size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  // ── Place Order bottom bar ─────────────────────────────────────────────────
  Widget _buildPlaceOrderBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 14, 16, MediaQuery.of(context).padding.bottom + 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -6)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Summary row
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isErrandOrMarket ? 'PRE-AUTHORIZE' : 'TOTAL TO PAY',
                    style: AppFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _mid, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₵${_grandTotal.toStringAsFixed(2)}',
                    style: AppFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: _dark),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('via', style: AppFonts.inter(fontSize: 11, color: _mid)),
                  Text(
                    _selectedPayment.split(' ').first,
                    style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: _dark),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Place Order button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: widget.cartItems.isEmpty || _isPlacing ? null : _onPlaceOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _border,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isPlacing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isErrandOrMarket ? 'Pre-Authorize & Send' : 'Place Order',
                          style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
