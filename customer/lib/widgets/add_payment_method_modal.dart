import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import '../models/payment_method.dart';

const Color _primary = Color(0xFF0068FF);
const Color _dark = Color(0xFF0F172A);
const Color _mid = Color(0xFF64748B);
const Color _border = Color(0xFFE8EDF2);
const Color _light = Color(0xFFF8FAFC);

/// Add a new saved payment method (mobile money number or card). Returns
/// the built [PaymentMethod] via `Navigator.pop`, or `null` if dismissed.
class AddPaymentMethodModal extends StatefulWidget {
  const AddPaymentMethodModal({super.key});

  @override
  State<AddPaymentMethodModal> createState() => _AddPaymentMethodModalState();
}

class _AddPaymentMethodModalState extends State<AddPaymentMethodModal> {
  bool _isMobileMoney = true;
  String _network = 'MTN';
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _cardNumberCtrl = TextEditingController();
  final TextEditingController _cardNameCtrl = TextEditingController();
  final TextEditingController _cardExpiryCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _cardNumberCtrl.dispose();
    _cardNameCtrl.dispose();
    _cardExpiryCtrl.dispose();
    super.dispose();
  }

  bool get _isValid => _isMobileMoney
      ? _phoneCtrl.text.trim().length >= 9
      : (_cardNumberCtrl.text.trim().length >= 12 &&
          _cardExpiryCtrl.text.trim().isNotEmpty &&
          _cardNameCtrl.text.trim().isNotEmpty);

  void _save() {
    if (!_isValid) return;
    final method = _isMobileMoney
        ? PaymentMethod(
            id: 'pm-${DateTime.now().millisecondsSinceEpoch}',
            type: PaymentMethodType.mobileMoney,
            label: '$_network Mobile Money',
            detail: _phoneCtrl.text.trim(),
            network: _network,
          )
        : PaymentMethod(
            id: 'pm-${DateTime.now().millisecondsSinceEpoch}',
            type: PaymentMethodType.card,
            label: '${_cardNetworkGuess()} •••• ${_last4(_cardNumberCtrl.text.trim())}',
            detail: 'Expires ${_cardExpiryCtrl.text.trim()}',
            network: _cardNetworkGuess(),
          );
    Navigator.pop(context, method);
  }

  String _last4(String number) => number.length <= 4 ? number : number.substring(number.length - 4);

  String _cardNetworkGuess() {
    final n = _cardNumberCtrl.text.trim();
    if (n.startsWith('4')) return 'Visa';
    if (n.startsWith('5')) return 'Mastercard';
    return 'Card';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text('Add payment method', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: _dark)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _tab('Mobile Money', Icons.phone_android_rounded, _isMobileMoney, () => setState(() => _isMobileMoney = true))),
                const SizedBox(width: 10),
                Expanded(child: _tab('Card', Icons.credit_card_rounded, !_isMobileMoney, () => setState(() => _isMobileMoney = false))),
              ],
            ),
            const SizedBox(height: 20),
            if (_isMobileMoney) ...[
              Text('NETWORK', style: AppFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: _mid, letterSpacing: 0.8)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: ['MTN', 'Vodafone', 'AirtelTigo'].map((n) {
                  final selected = _network == n;
                  return GestureDetector(
                    onTap: () => setState(() => _network = n),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: selected ? _primary.withOpacity(0.08) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: selected ? _primary : _border, width: selected ? 1.5 : 1),
                      ),
                      child: Text(n, style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? _primary : _dark)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              _field('Phone number', _phoneCtrl, hint: '024 XXX XXXX', keyboardType: TextInputType.phone),
            ] else ...[
              _field('Card number', _cardNumberCtrl, hint: '1234 5678 9012 3456', keyboardType: TextInputType.number),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _field('Expiry', _cardExpiryCtrl, hint: 'MM/YY')),
                  const SizedBox(width: 12),
                  Expanded(child: _field('Cardholder name', _cardNameCtrl, hint: 'Ama Owusu')),
                ],
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isValid ? _save : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _border,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Save', style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, IconData icon, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? _primary.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? _primary : _border, width: selected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? _primary : _mid, size: 20),
            const SizedBox(height: 6),
            Text(label, style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: selected ? _primary : _dark)),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {String? hint, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: _mid)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppFonts.inter(fontSize: 14, color: _mid),
            filled: true,
            fillColor: _light,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primary, width: 2)),
          ),
          style: AppFonts.inter(fontSize: 14),
        ),
      ],
    );
  }
}
