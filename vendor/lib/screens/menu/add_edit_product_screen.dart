import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'product_options_variations_screen.dart';
import '../../models/vendor_config.dart';

class AddEditProductScreen extends StatefulWidget {
  final String vendorType;

  const AddEditProductScreen({super.key, this.vendorType = 'restaurant'});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  late VendorConfig _cfg;
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  bool _active = true;
  bool _rxRequired = false;
  bool _published = false;
  late String _category;
  late String _pricingType;
  late String _prepTime;

  @override
  void initState() {
    super.initState();
    _cfg = getVendorConfig(widget.vendorType);
    _category = _cfg.categories.length > 1 ? _cfg.categories[1] : _cfg.categories[0];
    _pricingType = _cfg.pricingTypes.first;
    _prepTime = _cfg.prepTimeOptions.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Widget _fieldLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(label, style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFF334155))),
      );

  InputDecoration _fieldDecoration(String placeholder) => InputDecoration(
        hintText: placeholder,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF6B7280)),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

  Widget _card({required String title, IconData? icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 12, color: AppColors.primary),
                ),
                const SizedBox(width: 8),
              ],
              Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _toggleRow({required String label, required String subtitle, required bool value, required ValueChanged<bool> onChanged, Color? activeColor}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.subtitleMedium),
              Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 44, height: 24,
            decoration: BoxDecoration(
              color: value ? (activeColor ?? AppColors.primary) : AppColors.border,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(2),
                width: 20, height: 20,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Sticky header
          SafeArea(
            bottom: false,
            child: Container(
              color: Colors.white.withOpacity(0.9),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(LucideIcons.arrowLeft, size: 16, color: AppColors.textPrimary),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Add / Edit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary, height: 1.1)),
                            Text(_cfg.itemLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary, height: 1.1)),
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text('Save Draft', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                        ),
                        ElevatedButton(
                          onPressed: () => setState(() => _published = true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            elevation: 2,
                          ),
                          child: Text(_published ? 'Published ✓' : 'Publish', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 1, color: AppColors.border.withOpacity(0.5)),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 48),
              child: Column(
                children: [
                  if (_published)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF86EFAC)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.circleCheck, size: 18, color: Color(0xFF16A34A)),
                          const SizedBox(width: 8),
                          Text('${_cfg.itemLabel} published successfully!', style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF15803D), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),

                  // Image upload section
                  Container(
                    height: 224,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2, style: BorderStyle.solid),
                      color: AppColors.primary.withOpacity(0.05),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.camera, size: 32, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text('Tap to add product image', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),

                  // Basic Info card
                  _card(
                    title: 'Basic Information',
                    icon: LucideIcons.package,
                    child: Column(
                      children: [
                        _fieldLabel('${_cfg.itemLabel} Name'),
                        TextField(
                          controller: _nameCtrl,
                          decoration: _fieldDecoration(
                            _cfg.itemLabel == 'Dish' ? 'e.g. Jollof Rice Special'
                            : _cfg.itemLabel == 'Service' ? 'e.g. Wash & Fold'
                            : 'e.g. Paracetamol 500mg',
                          ),
                        ),
                        const SizedBox(height: 16),
                        _fieldLabel('Description'),
                        TextField(
                          controller: _descCtrl,
                          maxLines: 3,
                          decoration: _fieldDecoration('Describe this ${_cfg.itemLabel.toLowerCase()}...'),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _fieldLabel('Category'),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _category,
                                        isExpanded: true,
                                        items: _cfg.categories.where((c) => c != 'All').map((c) => DropdownMenuItem(value: c, child: Text(c, style: AppTextStyles.bodyMedium))).toList(),
                                        onChanged: (v) { if (v != null) setState(() => _category = v); },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_cfg.fields['stockQty'] == true) ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _fieldLabel('Stock Qty'),
                                    TextField(
                                      controller: _stockCtrl,
                                      keyboardType: TextInputType.number,
                                      decoration: _fieldDecoration('0'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        // Rx toggle for pharmacy
                        if (_cfg.fields['rxRequired'] == true) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7ED),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFFED7AA)),
                            ),
                            child: _toggleRow(
                              label: 'Prescription Required',
                              subtitle: 'Customer must provide valid Rx',
                              value: _rxRequired,
                              onChanged: (v) => setState(() => _rxRequired = v),
                              activeColor: const Color(0xFFEA580C),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pricing card
                  _card(
                    title: 'Pricing',
                    icon: LucideIcons.tag,
                    child: Column(
                      children: [
                        _fieldLabel('Pricing Type'),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _pricingType,
                              isExpanded: true,
                              items: _cfg.pricingTypes.map((t) => DropdownMenuItem(value: t, child: Text(t, style: AppTextStyles.bodyMedium))).toList(),
                              onChanged: (v) { if (v != null) setState(() => _pricingType = v); },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _fieldLabel('Base Price (GHS)'),
                        TextField(
                          controller: _priceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: _fieldDecoration('0.00'),
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const ProductOptionsVariationsScreen(),
                          )),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(LucideIcons.list, size: 18, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Text('Manage Options & Variations', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                                  ],
                                ),
                                const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.primary),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Availability card
                  _card(
                    title: 'Availability',
                    icon: LucideIcons.toggleRight,
                    child: Column(
                      children: [
                        _toggleRow(
                          label: 'Active & Visible',
                          subtitle: 'Show this ${_cfg.itemLabel.toLowerCase()} in your ${_cfg.catalogLabel.toLowerCase()}',
                          value: _active,
                          onChanged: (v) => setState(() => _active = v),
                        ),
                        if (_cfg.fields['prepTime'] == true) ...[
                          const SizedBox(height: 20),
                          const Divider(height: 1, color: AppColors.border),
                          const SizedBox(height: 16),
                          _fieldLabel(_cfg.prepTimeLabel),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _prepTime,
                                isExpanded: true,
                                items: _cfg.prepTimeOptions.map((t) => DropdownMenuItem(value: t, child: Text(t, style: AppTextStyles.bodyMedium))).toList(),
                                onChanged: (v) { if (v != null) setState(() => _prepTime = v); },
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
