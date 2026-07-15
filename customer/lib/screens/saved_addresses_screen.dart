import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  List<Map<String, dynamic>> _addresses = [
    {
      'id': '1',
      'type': 'home',
      'label': 'Home',
      'address': '123 Ring Road West, Suame, Kumasi',
      'landmark': 'Near Suame Magazine',
      'deliveryInstructions': 'Green gate, second house after the school',
      'icon': Icons.home_outlined,
      'color': const Color(0xFF0068FF),
      'colorLight': const Color(0xFFEFF5FF),
      'selected': true,
    },
    {
      'id': '2',
      'type': 'work',
      'label': 'Office',
      'address': '45 Prempeh II Street, Adum, Kumasi',
      'landmark': 'Kumasi City Mall Area',
      'deliveryInstructions': '5th floor, Suite 502',
      'icon': Icons.work_outline,
      'color': const Color(0xFF8B5CF6),
      'colorLight': const Color(0xFFF5F3FF),
      'selected': false,
    },
    {
      'id': '3',
      'type': 'other',
      'label': 'Market',
      'address': 'Kejetia Market, Central Kumasi',
      'landmark': 'Main entrance gate',
      'deliveryInstructions': 'Meet at main entrance',
      'icon': Icons.store_outlined,
      'color': const Color(0xFF64748B),
      'colorLight': const Color(0xFFF1F5F9),
      'selected': false,
    },
  ];

  // ── Add Address bottom sheet ─────────────────────────────────────────────

  void _openAddSheet() {
    String selectedType = 'Home';
    final labelCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final landmarkCtrl = TextEditingController();
    final instructionsCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title
                      Text(
                        'Add New Address',
                        style: AppFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Type chips
                      Text(
                        'Address Type',
                        style: AppFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: ['Home', 'Office', 'Other'].map((type) {
                          final bool active = selectedType == type;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () => setSheetState(() => selectedType = type),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 9),
                                decoration: BoxDecoration(
                                  color: active
                                      ? const Color(0xFF0068FF)
                                      : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: active
                                        ? const Color(0xFF0068FF)
                                        : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Text(
                                  type,
                                  style: AppFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: active
                                        ? Colors.white
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Label field
                      _sheetFieldLabel('Label'),
                      const SizedBox(height: 6),
                      _sheetTextField(
                        controller: labelCtrl,
                        hint: 'e.g. Home, Office...',
                      ),
                      const SizedBox(height: 16),

                      // Full Address field
                      _sheetFieldLabel('Full Address'),
                      const SizedBox(height: 6),
                      _sheetTextField(
                        controller: addressCtrl,
                        hint: 'Enter full address',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // Landmark field
                      _sheetFieldLabel('Landmark'),
                      const SizedBox(height: 6),
                      _sheetTextField(
                        controller: landmarkCtrl,
                        hint: 'Nearby landmark (optional)',
                      ),
                      const SizedBox(height: 16),

                      // Delivery Instructions field
                      _sheetFieldLabel('Delivery Instructions'),
                      const SizedBox(height: 6),
                      _sheetTextField(
                        controller: instructionsCtrl,
                        hint:
                            'e.g. Call when you arrive, blue gate on the right',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 28),

                      // Save button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final label = labelCtrl.text.trim().isNotEmpty
                                ? labelCtrl.text.trim()
                                : selectedType;
                            final address = addressCtrl.text.trim();
                            if (address.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please enter a full address',
                                    style: AppFonts.inter(),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                              return;
                            }

                            final typeMap = {
                              'Home': {
                                'type': 'home',
                                'icon': Icons.home_outlined,
                                'color': const Color(0xFF0068FF),
                                'colorLight': const Color(0xFFEFF5FF),
                              },
                              'Office': {
                                'type': 'work',
                                'icon': Icons.work_outline,
                                'color': const Color(0xFF8B5CF6),
                                'colorLight': const Color(0xFFF5F3FF),
                              },
                              'Other': {
                                'type': 'other',
                                'icon': Icons.store_outlined,
                                'color': const Color(0xFF64748B),
                                'colorLight': const Color(0xFFF1F5F9),
                              },
                            };

                            final meta = typeMap[selectedType]!;
                            setState(() {
                              _addresses.add({
                                'id': DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                                'type': meta['type'],
                                'label': label,
                                'address': address,
                                'landmark': landmarkCtrl.text.trim(),
                                'deliveryInstructions':
                                    instructionsCtrl.text.trim(),
                                'icon': meta['icon'],
                                'color': meta['color'],
                                'colorLight': meta['colorLight'],
                                'selected': false,
                              });
                            });
                            Navigator.pop(ctx);
                            instructionsCtrl.dispose();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Address saved successfully',
                                  style: AppFonts.inter(),
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: const Color(0xFF16A34A),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0068FF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(
                            'Save Address',
                            style: AppFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── 3-dot options bottom sheet ───────────────────────────────────────────

  void _openOptionsSheet(String id) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _optionRow(
                icon: Icons.edit_outlined,
                label: 'Edit',
                iconColor: const Color(0xFF0068FF),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Edit coming soon', style: AppFonts.inter()),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              _optionRow(
                icon: Icons.delete_outline,
                label: 'Delete',
                iconColor: const Color(0xFFEF4444),
                labelColor: const Color(0xFFEF4444),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _addresses.removeWhere((a) => a['id'] == id));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _optionRow({
    required IconData icon,
    required String label,
    required Color iconColor,
    Color? labelColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        label,
        style: AppFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: labelColor ?? const Color(0xFF0F172A),
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Saved Addresses',
          style: AppFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openAddSheet,
            icon: const Icon(Icons.add, color: Color(0xFF0068FF), size: 26),
            tooltip: 'Add Address',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _addresses.isEmpty ? _buildEmptyState() : _buildList(),
    );
  }

  // ── Address list + bottom button ─────────────────────────────────────────

  Widget _buildList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        ..._addresses.map((addr) => _buildAddressCard(addr)),
        const SizedBox(height: 8),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> addr) {
    final Color color = addr['color'] as Color;
    final Color colorLight = addr['colorLight'] as Color;
    final bool selected = addr['selected'] as bool;

    return GestureDetector(
      onTap: () {
        setState(() {
          for (final a in _addresses) {
            a['selected'] = a['id'] == addr['id'];
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          border: Border(
            left: BorderSide(color: color, width: 3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(addr['icon'] as IconData, color: color, size: 22),
              ),
              const SizedBox(width: 14),

              // Address details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          addr['label'] as String,
                          style: AppFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        if (selected) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF5FF),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Color(0xFF0068FF), size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  'Selected',
                                  style: AppFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0068FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      addr['address'] as String,
                      style: AppFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),
                    if ((addr['landmark'] as String).isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.near_me_outlined,
                              size: 12, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              addr['landmark'] as String,
                              style: AppFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF94A3B8),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if ((addr['deliveryInstructions'] as String? ?? '')
                        .isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 12, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              addr['deliveryInstructions'] as String,
                              style: AppFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF94A3B8),
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // 3-dot menu
              GestureDetector(
                onTap: () => _openOptionsSheet(addr['id'] as String),
                child: const Padding(
                  padding: EdgeInsets.only(left: 8, top: 2),
                  child: Icon(Icons.more_vert,
                      color: Color(0xFF94A3B8), size: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return OutlinedButton.icon(
      onPressed: _openAddSheet,
      icon: const Icon(Icons.add_location_alt_outlined,
          color: Color(0xFF0068FF), size: 20),
      label: Text(
        'Add New Address',
        style: AppFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0068FF),
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF0068FF), width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(double.infinity, 52),
      ),
    );
  }

  // ── Empty state ──────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF5FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_off_outlined,
                color: Color(0xFF0068FF),
                size: 38,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Saved Addresses',
              style: AppFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add your frequently used addresses\nfor faster checkout every time.',
              textAlign: TextAlign.center,
              style: AppFonts.inter(
                fontSize: 14,
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _openAddSheet,
              icon: const Icon(Icons.add_location_alt_outlined, size: 20),
              label: Text(
                'Add Address',
                style: AppFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0068FF),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _sheetFieldLabel(String label) {
    return Text(
      label,
      style: AppFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF64748B),
      ),
    );
  }

  Widget _sheetTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFonts.inter(
          fontSize: 15,
          color: const Color(0xFF94A3B8),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF0068FF), width: 1.5),
        ),
      ),
    );
  }
}
