import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import '../models/address.dart';
import '../models/order.dart';
import '../models/service_type.dart';
import '../providers/active_order_provider.dart';
import '../providers/order_history_provider.dart';
import 'order_confirmation_screen.dart';
import '../services/order_simulation_service.dart';

class BillPaymentScreen extends ConsumerStatefulWidget {
  const BillPaymentScreen({super.key});

  @override
  ConsumerState<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends ConsumerState<BillPaymentScreen> {
  int _selectedBillIndex = 0;
  bool _isVerifying = false;
  bool _isVerified = false;
  bool _isSubmitting = false;

  final _accountCtrl = TextEditingController();
  final _accountNameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _instructionsCtrl = TextEditingController();

  final List<Map<String, dynamic>> _billTypes = [
    {'name': 'ECG', 'icon': Icons.bolt_rounded},
    {'name': 'Water', 'icon': Icons.water_drop_rounded},
    {'name': 'Internet', 'icon': Icons.wifi_rounded},
    {'name': 'Airtime', 'icon': Icons.phone_android_rounded},
  ];

  @override
  void dispose() {
    _accountCtrl.dispose();
    _accountNameCtrl.dispose();
    _amountCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  double get _billAmount => double.tryParse(_amountCtrl.text) ?? 0.0;
  double get _total => _billAmount + 15.0;

  Future<void> _onVerify() async {
    final account = _accountCtrl.text.trim();
    if (account.isEmpty || account.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter a valid account/meter number.',
            style: AppFonts.inter(color: Colors.white, fontSize: 14)),
        backgroundColor: const Color(0xFFE11D48),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }

    setState(() { _isVerifying = true; _isVerified = false; });
    // Simulate API verification
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Populate the account name field with a simulated result
    _accountNameCtrl.text = 'Verified Account Holder';
    setState(() { _isVerifying = false; _isVerified = true; });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text('Account verified successfully!', style: AppFonts.inter(color: Colors.white, fontSize: 14)),
      ]),
      backgroundColor: const Color(0xFF16A34A),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  Future<void> _onConfirm() async {
    if (_accountCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter the account/meter number first.',
            style: AppFonts.inter(color: Colors.white, fontSize: 14)),
        backgroundColor: const Color(0xFFE11D48),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }
    if (_billAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter the bill amount.',
            style: AppFonts.inter(color: Colors.white, fontSize: 14)),
        backgroundColor: const Color(0xFFE11D48),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final billName = _billTypes[_selectedBillIndex]['name'] as String;
    final order = Order(
      id: OrderIdGenerator.next(ServiceType.bill),
      serviceType: ServiceType.bill,
      items: [
        OrderLineItem(
          title: '$billName Bill Payment',
          description: 'Account: ${_accountCtrl.text.trim()}',
          unitPrice: _billAmount,
        ),
      ],
      subtotal: _billAmount,
      serviceFee: 15.0,
      total: _total,
      paymentMethod: 'swiftree Wallet',
      address: Address(type: 'Bill Account', street: _accountCtrl.text.trim()),
      vendorName: billName,
      specialInstructions: _instructionsCtrl.text.trim().isEmpty ? null : _instructionsCtrl.text.trim(),
      placedAt: DateTime.now(),
      eta: ServiceType.bill.defaultEta,
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

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => OrderConfirmationScreen(order: order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Bill Payment Errand',
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 130),
            children: [
              Text('What bill are we paying today?',
                  style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 16),

              // Bill type selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_billTypes.length, (index) {
                  final isActive = _selectedBillIndex == index;
                  final bill = _billTypes[index];
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedBillIndex = index;
                      _isVerified = false;
                      _accountNameCtrl.clear();
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 80, height: 96,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF0068FF) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isActive ? Colors.transparent : const Color(0xFFE2E8F0)),
                        boxShadow: isActive
                            ? [BoxShadow(color: const Color(0xFF0068FF).withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(bill['icon'], color: isActive ? Colors.white : const Color(0xFF475569), size: 28),
                          const SizedBox(height: 8),
                          Text(bill['name'],
                              style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w600,
                                  color: isActive ? Colors.white : const Color(0xFF475569), letterSpacing: 0.6)),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Meter / Account Number
              _fieldLabel('Meter / Account Number', required: true),
              const SizedBox(height: 8),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _isVerified ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0), width: _isVerified ? 1.5 : 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _accountCtrl,
                        style: AppFonts.inter(fontSize: 15, color: const Color(0xFF0F172A)),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() => _isVerified = false),
                        decoration: InputDecoration(
                          hintText: 'Enter account/meter number',
                          hintStyle: AppFonts.inter(color: const Color(0xFF94A3B8), fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _isVerifying ? null : _onVerify,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: _isVerified ? const Color(0xFFF0FDF4) : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _isVerifying
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0068FF)))
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(_isVerified ? Icons.check_circle : Icons.verified_outlined,
                                      size: 14, color: _isVerified ? const Color(0xFF16A34A) : const Color(0xFF0068FF)),
                                  const SizedBox(width: 4),
                                  Text(_isVerified ? 'VERIFIED' : 'VERIFY',
                                      style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.bold,
                                          color: _isVerified ? const Color(0xFF16A34A) : const Color(0xFF0068FF))),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Account Holder Name (auto-filled after verify)
              _fieldLabel('Account Holder Name'),
              const SizedBox(height: 8),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: _isVerified ? const Color(0xFFF0FDF4) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  controller: _accountNameCtrl,
                  readOnly: true,
                  style: AppFonts.inter(fontSize: 15, color: const Color(0xFF0F172A), fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Auto-filled after verification',
                    hintStyle: AppFonts.inter(color: const Color(0xFF94A3B8), fontSize: 15),
                    prefixIcon: _isVerified ? const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 18) : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Amount to Pay
              _fieldLabel('Amount to Pay'),
              const SizedBox(height: 8),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFFE2E8F0)))),
                      child: Center(
                        child: Text('₵', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF64748B))),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _amountCtrl,
                        onChanged: (_) => setState(() {}),
                        style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: AppFonts.inter(color: const Color(0xFF6B7280), fontSize: 18, fontWeight: FontWeight.bold),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: ['20', '50', '100', '200', '500'].map((amount) {
                  return GestureDetector(
                    onTap: () => setState(() => _amountCtrl.text = amount),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _amountCtrl.text == amount ? const Color(0xFF0068FF) : Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: _amountCtrl.text == amount ? Colors.transparent : const Color(0xFFE2E8F0)),
                      ),
                      child: Text('₵$amount',
                          style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w500,
                              color: _amountCtrl.text == amount ? Colors.white : const Color(0xFF475569))),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Special Instructions
              _fieldLabel('Special Instructions (Optional)'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  controller: _instructionsCtrl,
                  maxLines: 3,
                  style: AppFonts.inter(fontSize: 15, color: const Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    hintText: 'e.g. Please send confirmation SMS after payment',
                    hintStyle: AppFonts.inter(color: const Color(0xFF94A3B8), fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF0068FF).withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Bill Amount', style: AppFonts.inter(fontSize: 14, color: const Color(0xFF475569))),
                        Text('₵ ${_billAmount.toStringAsFixed(2)}',
                            style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Errand Fee', style: AppFonts.inter(fontSize: 14, color: const Color(0xFF475569))),
                        Text('₵ 15.00', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Divider(height: 1, color: const Color(0xFF0068FF).withValues(alpha: 0.2)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Estimated', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        Text('₵ ${_total.toStringAsFixed(2)}',
                            style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Sticky Bottom Bar
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
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0068FF),
                      disabledBackgroundColor: const Color(0xFF0068FF).withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Confirm Bill Payment',
                                  style: AppFonts.inter(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text, {bool required = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
        if (required)
          Text('Required', style: AppFonts.inter(fontSize: 12, color: const Color(0xFF0068FF))),
      ],
    );
  }
}
