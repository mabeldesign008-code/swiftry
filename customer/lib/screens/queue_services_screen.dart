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

class QueueServicesScreen extends ConsumerStatefulWidget {
  const QueueServicesScreen({super.key});

  @override
  ConsumerState<QueueServicesScreen> createState() => _QueueServicesScreenState();
}

class _QueueServicesScreenState extends ConsumerState<QueueServicesScreen> {
  int _selectedService = 0;
  bool _isSubmitting = false;

  final _descriptionCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _floorCtrl = TextEditingController();
  final _buildingCtrl = TextEditingController();

  final List<Map<String, dynamic>> _services = [
    {'label': 'Collect documents', 'icon': Icons.description_outlined},
    {'label': 'Stand in queue', 'icon': Icons.people_outlined},
    {'label': 'Submit documents', 'icon': Icons.upload_file_outlined},
  ];

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    _addressCtrl.dispose();
    _floorCtrl.dispose();
    _buildingCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_descriptionCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please describe the task for the agent.',
              style: AppFonts.inter(color: Colors.white, fontSize: 14)),
          backgroundColor: const Color(0xFFE11D48),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    if (_addressCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the location address.',
              style: AppFonts.inter(color: Colors.white, fontSize: 14)),
          backgroundColor: const Color(0xFFE11D48),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final serviceLabel = _services[_selectedService]['label'] as String;
    final order = Order(
      id: OrderIdGenerator.next(ServiceType.queue),
      serviceType: ServiceType.queue,
      items: [
        OrderLineItem(
          title: serviceLabel,
          description: _descriptionCtrl.text.trim(),
          unitPrice: 15.0,
        ),
      ],
      subtotal: 0,
      serviceFee: 15.0,
      total: 15.0,
      paymentMethod: 'swiftree Wallet',
      address: Address(
        type: 'Location',
        street: _addressCtrl.text.trim(),
        landmark: [
          if (_buildingCtrl.text.trim().isNotEmpty) _buildingCtrl.text.trim(),
          if (_floorCtrl.text.trim().isNotEmpty) 'Floor ${_floorCtrl.text.trim()}',
        ].join(', '),
      ),
      vendorName: 'swiftree Agent',
      placedAt: DateTime.now(),
      eta: ServiceType.queue.defaultEta,
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
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0068FF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Errand Request',
          style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE2E8F0)),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
            children: [
              // Security Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0x1A166CEC), Color(0x1A004BBC)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0x330068FF)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline, color: Color(0xFF0068FF), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'END-TO-END ENCRYPTED SUBMISSION',
                      style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF0068FF), letterSpacing: 0.6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Service Selection
              Text('What do you need help with?',
                  style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_services.length, (index) {
                  final isActive = _selectedService == index;
                  final s = _services[index];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedService = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF0068FF) : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(s['icon'], size: 16, color: isActive ? Colors.white : const Color(0xFF334155)),
                          const SizedBox(width: 6),
                          Text(s['label'],
                              style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w500,
                                  color: isActive ? Colors.white : const Color(0xFF334155))),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Task Description
              Text('Task Description',
                  style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: TextField(
                  controller: _descriptionCtrl,
                  maxLines: 5,
                  style: AppFonts.inter(fontSize: 15, color: const Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    hintText: 'Please provide specific instructions for the agent...',
                    hintStyle: AppFonts.inter(color: const Color(0xFF94A3B8), fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Location Details
              Text('Location Details',
                  style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 12),

              // Address search
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Icon(Icons.location_on, color: Color(0xFF0068FF), size: 20),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _addressCtrl,
                        style: AppFonts.inter(fontSize: 15, color: const Color(0xFF0F172A)),
                        decoration: InputDecoration(
                          hintText: 'Search address...',
                          hintStyle: AppFonts.inter(color: const Color(0xFF6B7280), fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: TextField(
                        controller: _floorCtrl,
                        style: AppFonts.inter(fontSize: 14, color: const Color(0xFF0F172A)),
                        decoration: InputDecoration(
                          hintText: 'Floor / Room',
                          hintStyle: AppFonts.inter(color: const Color(0xFF6B7280), fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: TextField(
                        controller: _buildingCtrl,
                        style: AppFonts.inter(fontSize: 14, color: const Color(0xFF0F172A)),
                        decoration: InputDecoration(
                          hintText: 'Building Name',
                          hintStyle: AppFonts.inter(color: const Color(0xFF6B7280), fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Mini map placeholder
              Container(
                height: 128,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EFF7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      const Positioned.fill(child: ColoredBox(color: Color(0xFFE8EFF7))),
                      Center(child: Icon(Icons.location_on, color: const Color(0xFF0068FF), size: 40)),
                      Positioned(
                        bottom: 10, left: 0, right: 0,
                        child: Center(
                          child: Text(
                            'Map will load with real location',
                            style: AppFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Document Upload
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Confidential Documents',
                      style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  const Icon(Icons.description_outlined, color: Color(0xFF0068FF), size: 20),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Document upload will be available after backend integration.',
                        style: AppFonts.inter(color: Colors.white, fontSize: 14)),
                    backgroundColor: const Color(0xFF0F172A),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF0068FF).withValues(alpha: 0.3), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0x1A0068FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.upload_file_outlined, color: Color(0xFF0068FF), size: 22),
                      ),
                      const SizedBox(height: 8),
                      Text('Tap to upload files',
                          style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
                      const SizedBox(height: 4),
                      Text('PDF, PNG, JPG (Max 10MB)',
                          style: AppFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'All documents are encrypted and only accessible by your assigned agent during the errand timeframe.',
                textAlign: TextAlign.center,
                style: AppFonts.inter(fontSize: 11, color: const Color(0xFF64748B), height: 1.6),
              ),
            ],
          ),

          // Fixed Bottom Bar
          Positioned(
            bottom: 0, left: 0, right: 0,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimated Service Fee',
                            style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF64748B))),
                        Text('₵15.00',
                            style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0068FF),
                          disabledBackgroundColor: const Color(0xFF0068FF).withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        label: Text(
                          _isSubmitting ? 'Submitting...' : 'Submit Errand',
                          style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        icon: _isSubmitting
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Icon(Icons.send, color: Colors.white, size: 18),
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
