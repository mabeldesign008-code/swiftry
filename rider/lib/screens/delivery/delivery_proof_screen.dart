import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/rider_provider.dart';

class DeliveryProofScreen extends ConsumerStatefulWidget {
  final RiderOrder order;
  const DeliveryProofScreen({super.key, required this.order});

  @override
  ConsumerState<DeliveryProofScreen> createState() => _DeliveryProofScreenState();
}

class _DeliveryProofScreenState extends ConsumerState<DeliveryProofScreen> {
  final _otpCtrl = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _completeDelivery() async {
    if (_otpCtrl.text.trim().length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter OTP from customer')));
      return;
    }
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1)); // Mock verification

    // TODO Backend: POST /rider/orders/:id/proof {otp, photo, lat, lng}
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ref.read(riderOrdersProvider.notifier).updateStatus(widget.order.id, OrderStatus.delivered);
    ref.read(earningsProvider.notifier).addEarning(widget.order.riderEarning);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Delivered! 🎉'),
        content: Text('You earned ₵${widget.order.riderEarning.toStringAsFixed(0)} for this delivery'),
        actions: [
          ElevatedButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text('Go Home')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deliver to ${widget.order.customerName}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.check_circle, color: AppColors.success), const SizedBox(width: 12), Expanded(child: Text('Order ${widget.order.id} - ₵${widget.order.total.toStringAsFixed(0)} collected?', style: const TextStyle(fontWeight: FontWeight.bold)))])),
            const SizedBox(height: 24),
            const Text('Enter OTP from customer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Ask customer for delivery OTP to confirm', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            TextField(
              controller: _otpCtrl,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(labelText: 'Delivery OTP', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: AppColors.surfaceVariant),
            ),
            const SizedBox(height: 16),
            const Text('Proof Options (TODO Backend)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _proofOption(Icons.camera_alt, 'Take Photo', 'Photo of delivered parcel')),
                const SizedBox(width: 12),
                Expanded(child: _proofOption(Icons.draw, 'Signature', 'Customer signature')),
              ],
            ),
            const Spacer(),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _isSubmitting ? null : _completeDelivery, child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : Text('Complete • Earn ₵${widget.order.riderEarning.toStringAsFixed(0)}'))),
            const SizedBox(height: 12),
            Center(child: TextButton(onPressed: () {}, child: const Text('Customer not available? Report issue'))),
          ],
        ),
      ),
    );
  }

  Widget _proofOption(IconData icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.textTertiary), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
