import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import '../models/service_type.dart';
import 'checkout_screen.dart';

class MarketShoppingListScreen extends StatefulWidget {
  const MarketShoppingListScreen({super.key});

  @override
  State<MarketShoppingListScreen> createState() =>
      _MarketShoppingListScreenState();
}

class _MarketShoppingListScreenState extends State<MarketShoppingListScreen> {
  String _selectedMarket = 'Makola Market';
  final TextEditingController _instructionsCtrl = TextEditingController();
  final List<Map<String, TextEditingController>> _items = [];
  bool _submitting = false;

  final List<String> _markets = [
    'Makola Market',
    'Kejetia Market',
    'Kaneshie Market',
    'Kotokuraba Market',
    'Agbogbloshie Market',
    'Kumasi Central Market',
    'Other (specify in instructions)',
  ];

  static const Color _primary = Color(0xFF0068FF);
  static const Color _dark = Color(0xFF0F172A);
  static const Color _mid = Color(0xFF64748B);
  static const Color _light = Color(0xFFF8FAFC);
  static const Color _border = Color(0xFFE8EDF2);
  static const Color _marketGreen = Color(0xFF16A34A);

  @override
  void initState() {
    super.initState();
    // Start with 2 empty rows
    _addItem();
    _addItem();
  }

  @override
  void dispose() {
    _instructionsCtrl.dispose();
    for (final row in _items) {
      row['name']!.dispose();
      row['qty']!.dispose();
    }
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add({
        'name': TextEditingController(),
        'qty': TextEditingController(),
      });
    });
  }

  void _removeItem(int index) {
    if (_items.length <= 1) return;
    setState(() {
      _items[index]['name']!.dispose();
      _items[index]['qty']!.dispose();
      _items.removeAt(index);
    });
  }

  // Build a simplified cart-like structure for CheckoutScreen
  List<Map<String, dynamic>> _buildCartItems() {
    return _items
        .where((row) => row['name']!.text.trim().isNotEmpty)
        .map((row) => {
              'name': row['name']!.text.trim(),
              'title': row['name']!.text.trim(),
              'description': row['qty']!.text.trim().isNotEmpty
                  ? 'Qty: ${row['qty']!.text.trim()}'
                  : '',
              'price': 0.0, // price TBD by rider
              'quantity': 1,
            })
        .toList();
  }

  void _onSubmit() async {
    final filledItems = _items.where((r) => r['name']!.text.trim().isNotEmpty);
    if (filledItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least one item',
              style: AppFonts.inter(color: Colors.white)),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final cart = _buildCartItems();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          serviceType: ServiceType.market,
          cartItems: cart,
          subtotal: 0.0, // pre-auth; actual price TBD
          totalItems: cart.length,
          onPlaceOrder: () {},
          marketName: _selectedMarket,
          specialInstructions: _instructionsCtrl.text.trim(),
        ),
      ),
    );
    setState(() => _submitting = false);
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
                  _buildInfoBanner(),
                  const SizedBox(height: 16),
                  _buildMarketSelector(),
                  const SizedBox(height: 14),
                  _buildItemsCard(),
                  const SizedBox(height: 14),
                  _buildInstructionsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildSubmitBar(),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF15803D), Color(0xFF22C55E)],
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
                      'Market Shopping List',
                      style: AppFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    Text(
                      'A rider shops for you at the market',
                      style: AppFonts.inter(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shopping_basket_rounded,
                    color: Colors.white, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Info banner ────────────────────────────────────────────────────────────
  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: _marketGreen, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How it works',
                  style: AppFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _marketGreen),
                ),
                const SizedBox(height: 4),
                Text(
                  '1. Tell us what you need and which market\n'
                  '2. We estimate the cost and you pre-authorize payment\n'
                  '3. A rider goes to the market and buys your items\n'
                  '4. You get a refund if the cost is lower, or approve extra if higher',
                  style: AppFonts.inter(fontSize: 12, color: const Color(0xFF166534), height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Market Selector ────────────────────────────────────────────────────────
  Widget _buildMarketSelector() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
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
                    color: _marketGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.store_mall_directory_rounded,
                    size: 17, color: _marketGreen),
              ),
              const SizedBox(width: 10),
              Text('Target Market',
                  style: AppFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _dark)),
            ],
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: _selectedMarket,
            decoration: InputDecoration(
              filled: true,
              fillColor: _light,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            style: AppFonts.inter(fontSize: 14, color: _dark),
            items: _markets
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (v) => setState(() => _selectedMarket = v!),
          ),
        ],
      ),
    );
  }

  // ── Items Card ─────────────────────────────────────────────────────────────
  Widget _buildItemsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
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
                    color: _primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.list_alt_rounded,
                    size: 17, color: _primary),
              ),
              const SizedBox(width: 10),
              Text('Shopping Items',
                  style: AppFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _dark)),
              const Spacer(),
              Text('${_items.length} items',
                  style: AppFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _mid)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Be specific — e.g. "Fresh tomatoes - 1 big bowl"',
            style: AppFonts.inter(fontSize: 12, color: _mid),
          ),
          const SizedBox(height: 14),
          // Column headers
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text('Item',
                    style: AppFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _mid,
                        letterSpacing: 0.6)),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Text('Qty / Description',
                    style: AppFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _mid,
                        letterSpacing: 0.6)),
              ),
              const SizedBox(width: 36),
            ],
          ),
          const SizedBox(height: 8),
          ..._items.asMap().entries.map((entry) {
            final i = entry.key;
            final row = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  // Index badge
                  Container(
                    width: 26,
                    height: 26,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: _primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: AppFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _primary),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: row['name'],
                      decoration: _inputDecoration('e.g. Tomatoes'),
                      style: AppFonts.inter(fontSize: 14),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: row['qty'],
                      decoration: _inputDecoration('1 bowl'),
                      style: AppFonts.inter(fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => _removeItem(i),
                    icon: Icon(
                      Icons.remove_circle_outline_rounded,
                      color: _items.length <= 1
                          ? _border
                          : Colors.red[400],
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: _addItem,
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: _marketGreen, size: 20),
            label: Text('Add another item',
                style: AppFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _marketGreen)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),
        ],
      ),
    );
  }

  // ── Instructions Card ──────────────────────────────────────────────────────
  Widget _buildInstructionsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
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
                    color: Colors.orange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.notes_rounded,
                    size: 17, color: Colors.orange[700]),
              ),
              const SizedBox(width: 10),
              Text('Special Instructions',
                  style: AppFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _dark)),
              const Spacer(),
              Text('Optional',
                  style: AppFonts.inter(
                      fontSize: 12, color: _mid)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _instructionsCtrl,
            maxLines: 3,
            decoration: _inputDecoration(
              'e.g. "Pick firm tomatoes, not soft ones. Call me if tilapia is above ₵10 each."',
            ).copyWith(
              contentPadding: const EdgeInsets.all(16),
            ),
            style: AppFonts.inter(fontSize: 14),
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }

  // ── Submit bar ─────────────────────────────────────────────────────────────
  Widget _buildSubmitBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 14, 16, MediaQuery.of(context).padding.bottom + 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -6))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: _mid, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You pay an estimate now. Refunds or top-ups are settled after the rider shops.',
                  style: AppFonts.inter(fontSize: 11, color: _mid),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _submitting ? null : _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _marketGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Review & Pre-Authorize',
                          style: AppFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppFonts.inter(fontSize: 13, color: _mid),
      filled: true,
      fillColor: _light,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _primary, width: 2),
      ),
    );
  }
}
