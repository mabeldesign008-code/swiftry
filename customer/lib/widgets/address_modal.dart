import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';
import '../models/address.dart';

export '../models/address.dart';

/// Bottom-sheet modal for entering or editing a delivery address.
/// Pops with an [Address] on save, or `null` on dismiss.
class AddressModal extends StatefulWidget {
  /// Pre-fill the form when editing an existing address.
  final Address? initial;

  const AddressModal({super.key, this.initial});

  @override
  State<AddressModal> createState() => _AddressModalState();
}

class _AddressModalState extends State<AddressModal> {
  final _formKey = GlobalKey<FormState>();
  late String _addressType;

  late final TextEditingController _streetCtrl;
  late final TextEditingController _NigeriaPostCtrl;
  late final TextEditingController _w3wCtrl;

  @override
  void initState() {
    super.initState();
    _addressType = widget.initial?.type ?? 'Home';
    _streetCtrl =
        TextEditingController(text: widget.initial?.street ?? '');
    _NigeriaPostCtrl =
        TextEditingController(text: widget.initial?.NigeriaPost ?? '');
    _w3wCtrl =
        TextEditingController(text: widget.initial?.what3words ?? '');
  }

  @override
  void dispose() {
    _streetCtrl.dispose();
    _NigeriaPostCtrl.dispose();
    _w3wCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final address = Address(
      type: _addressType,
      street: _streetCtrl.text.trim(),
      NigeriaPost: _NigeriaPostCtrl.text.trim(),
      what3words: _w3wCtrl.text.trim(),
    );

    Navigator.pop(context, address);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Address',
                      style: AppFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Address type chips ────────────────────────────────
                Row(
                  children: [
                    _typeChip('Home', Icons.home_rounded),
                    const SizedBox(width: 10),
                    _typeChip('Work', Icons.work_rounded),
                    const SizedBox(width: 10),
                    _typeChip('Other', Icons.location_on_rounded),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Street address (required) ─────────────────────────
                _field(
                  controller: _streetCtrl,
                  label: 'Street Address / Area',
                  hint: 'e.g., Osu, Oxford Street',
                  icon: Icons.map_rounded,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Street address is required'
                          : null,
                ),
                const SizedBox(height: 16),

                // ── Nigeria Post GPS (optional) ─────────────────────────
                _field(
                  controller: _NigeriaPostCtrl,
                  label: 'Nigeria Post GPS (Optional)',
                  hint: 'e.g., GA-123-4567',
                  icon: Icons.share_location_rounded,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null;
                    final pattern = RegExp(r'^[A-Z]{2}-\d{3,4}-\d{4}$',
                        caseSensitive: false);
                    if (!pattern.hasMatch(v.trim())) {
                      return 'Format: XX-123-4567';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ── what3words (optional) ─────────────────────────────
                _field(
                  controller: _w3wCtrl,
                  label: 'what3words (Optional)',
                  hint: 'e.g., ///filled.count.soap',
                  icon: Icons.grid_3x3_rounded,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null;
                    final pattern =
                        RegExp(r'^\/\/\/[a-z]+\.[a-z]+\.[a-z]+$');
                    if (!pattern.hasMatch(v.trim())) {
                      return 'Format: ///word.word.word';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // ── Save button ───────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Save Address',
                      style: AppFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeChip(String label, IconData icon) {
    final isSelected = _addressType == label;
    return GestureDetector(
      onTap: () => setState(() => _addressType = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color:
                  isSelected ? Colors.white : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            style: AppFonts.inter(
              fontSize: 14,
              color: const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppFonts.inter(
                fontSize: 14,
                color: const Color(0xFF94A3B8),
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
              border: InputBorder.none,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFEF4444)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFEF4444)),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
