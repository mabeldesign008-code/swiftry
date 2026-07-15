import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'parcel_shipping_screen.dart';

class ParcelDetailsScreen extends StatefulWidget {
  final String category;

  const ParcelDetailsScreen({super.key, required this.category});

  @override
  State<ParcelDetailsScreen> createState() => _ParcelDetailsScreenState();
}

class _ParcelDetailsScreenState extends State<ParcelDetailsScreen> {
  int _selectedWeightIndex = -1;
  bool _isFragile = false;

  final List<String> _weightOptions = ['Under 1kg', '1 - 5 kg', '5 - 10 kg', '10kg +'];

  final _formKey = GlobalKey<FormState>();
  final _senderNameCtrl = TextEditingController();
  final _senderAddrCtrl = TextEditingController();
  final _recipientNameCtrl = TextEditingController();
  final _recipientAddrCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _declaredValueCtrl = TextEditingController();

  @override
  void dispose() {
    _senderNameCtrl.dispose();
    _senderAddrCtrl.dispose();
    _recipientNameCtrl.dispose();
    _recipientAddrCtrl.dispose();
    _descriptionCtrl.dispose();
    _declaredValueCtrl.dispose();
    super.dispose();
  }

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
        title: Text(
          'Parcel Details',
          style: AppFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
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
                    Text(
                      'STEP 2 OF 5: SHIPPING INFO',
                      style: AppFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      '40%',
                      style: AppFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0068FF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC5B13).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0068FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
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
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
              children: [
                // Path connector line
                Stack(
                  children: [
                    Positioned(
                      left: 45,
                      top: 60,
                      bottom: 60,
                      child: Container(
                        width: 2,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: const Color(0xFFEC5B13).withValues(alpha: 0.3),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        // Sender (A)
                        _buildParticipantCard(
                          'A',
                          'Sender Details',
                          const Color(0xFF0068FF),
                          Colors.white,
                          [
                            _buildInputField('Full Name', _senderNameCtrl),
                            const SizedBox(height: 16),
                            _buildInputField('Pickup Address', _senderAddrCtrl, Icons.my_location),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Recipient (B)
                        _buildParticipantCard(
                          'B',
                          'Recipient Details',
                          const Color(0xFFE2E8F0),
                          const Color(0xFF475569),
                          [
                            _buildInputField('Full Name', _recipientNameCtrl),
                            const SizedBox(height: 16),
                            _buildInputField('Delivery Address', _recipientAddrCtrl, Icons.location_on_outlined),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Parcel Specifications',
                  style: AppFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(21),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField('Item Description', _descriptionCtrl, null, 2),
                      const SizedBox(height: 24),
                      Text(
                        'Weight Range',
                        style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(_weightOptions.length, (index) {
                            final isSelected = _selectedWeightIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedWeightIndex = index),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF0068FF) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    _weightOptions[index],
                                    style: AppFonts.inter(
                                      fontSize: 14,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      color: isSelected ? Colors.white : const Color(0xFF475569),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Declared Value (Insurance)',
                        style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text('₵', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF64748B))),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _declaredValueCtrl,
                                keyboardType: TextInputType.number,
                                style: AppFonts.inter(fontSize: 16, color: const Color(0xFF0F172A)),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: AppFonts.inter(fontSize: 16, color: const Color(0xFF94A3B8)),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Special Handling',
                  style: AppFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0x1AEC5B13),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.wine_bar, color: Color(0xFF0068FF)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fragile Item', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                            const SizedBox(height: 4),
                            Text('Extra padding and care (+ ₵20.50)', style: AppFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isFragile,
                        onChanged: (val) => setState(() => _isFragile = val),
                        activeThumbColor: const Color(0xFF0068FF),
                        activeTrackColor: const Color(0xFF0068FF),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Footer
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  border: const Border(top: BorderSide(color: Color(0x1AEC5B13))),
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
                          Text('Estimated Cost', style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF64748B))),
                          Text('₵42.50', style: AppFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedWeightIndex == -1) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please select a weight range', style: AppFonts.inter(color: Colors.white)),
                              backgroundColor: const Color(0xFFE11D48),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ));
                            return;
                          }
                          if (!_formKey.currentState!.validate()) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ParcelShippingScreen(
                                category: widget.category,
                                senderName: _senderNameCtrl.text.trim(),
                                recipientName: _recipientNameCtrl.text.trim(),
                                weight: _weightOptions[_selectedWeightIndex],
                                isFragile: _isFragile,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0068FF),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Continue to Shipping',
                          style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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

  Widget _buildParticipantCard(String letter, String title, Color letterBgColor, Color letterColor, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: letterBgColor,
                  shape: BoxShape.circle,
                  border: letterBgColor == const Color(0xFFE2E8F0) ? Border.all(color: const Color(0xFF0068FF), width: 2) : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  letter,
                  style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: letterColor),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController ctrl, [IconData? suffixIcon, int maxLines = 1]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF64748B))),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: ctrl,
            maxLines: maxLines,
            style: AppFonts.inter(fontSize: 15, color: const Color(0xFF0F172A)),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label is required';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: label,
              hintStyle: AppFonts.inter(fontSize: 15, color: const Color(0xFF94A3B8)),
              suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFF0068FF), size: 20) : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
