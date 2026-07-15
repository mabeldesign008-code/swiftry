import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/vendor_config.dart';

class _Category {
  final int id;
  String name;
  int items;
  bool active;

  _Category({required this.id, required this.name, required this.items, required this.active});
}

class CategoryManagementScreen extends StatefulWidget {
  final String vendorType;

  const CategoryManagementScreen({super.key, this.vendorType = 'restaurant'});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  late VendorConfig _cfg;
  late List<_Category> _categories;
  bool _showAddModal = false;
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _toast;
  int _nextId = 10;

  @override
  void initState() {
    super.initState();
    _cfg = getVendorConfig(widget.vendorType);
    _categories = _cfg.defaultCategories.asMap().entries.map((e) => _Category(
      id: e.key + 1,
      name: e.value['name'] as String,
      items: e.value['items'] as int,
      active: true,
    )).toList();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _showToast(String msg) {
    setState(() => _toast = msg);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _toast = null);
    });
  }

  void _deleteCategory(int id) {
    setState(() => _categories.removeWhere((c) => c.id == id));
    _showToast('Category deleted');
  }

  void _createCategory() {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() {
      _categories.add(_Category(id: _nextId++, name: _nameCtrl.text.trim(), items: 0, active: true));
      _showAddModal = false;
      _nameCtrl.clear();
      _descCtrl.clear();
    });
    _showToast('Category created');
  }

  List<_Category> get _active => _categories.where((c) => c.active).toList();
  List<_Category> get _inactive => _categories.where((c) => !c.active).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: const Icon(LucideIcons.folderOpen, size: 16, color: AppColors.primary),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${_cfg.catalogLabel} Categories', style: AppTextStyles.subtitle.copyWith(fontSize: 17)),
                                  Text('Organize your ${_cfg.catalogLabel.toLowerCase()} offerings', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(LucideIcons.upload, size: 12),
                              label: const Text('Import'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                textStyle: AppTextStyles.captionBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(height: 1, color: AppColors.border),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Active section header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ACTIVE CATEGORIES (${_active.length})', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8), letterSpacing: 0.8)),
                          GestureDetector(
                            onTap: () => setState(() => _showAddModal = true),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.plus, size: 12, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text('Add New', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      ..._active.map((cat) => _buildCategoryRow(cat, isActive: true)),

                      const SizedBox(height: 24),

                      // Inactive section
                      Text('INACTIVE CATEGORIES (${_inactive.length})', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8), letterSpacing: 0.8)),
                      const SizedBox(height: 12),

                      if (_inactive.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border, width: 2, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text('No inactive categories found.', style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF94A3B8))),
                        )
                      else
                        ..._inactive.map((cat) => _buildCategoryRow(cat, isActive: false)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // FAB
          Positioned(
            bottom: 24, right: 16,
            child: FloatingActionButton(
              onPressed: () => setState(() => _showAddModal = true),
              backgroundColor: AppColors.primary,
              child: const Icon(LucideIcons.plus, size: 24, color: Colors.white),
            ),
          ),

          // Add Category Modal
          if (_showAddModal)
            GestureDetector(
              onTap: () => setState(() => _showAddModal = false),
              child: Container(color: Colors.black54),
            ),
          if (_showAddModal)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: GestureDetector(
                onTap: () {}, // prevent dismiss on content tap
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Add New Category', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                          IconButton(
                            icon: const Icon(LucideIcons.x, size: 18, color: AppColors.textSecondary),
                            onPressed: () => setState(() => _showAddModal = false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Image upload placeholder
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border, width: 2, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(LucideIcons.uploadCloud, size: 24, color: Color(0xFF94A3B8)),
                              const SizedBox(height: 6),
                              Text('Click to upload or drag and drop', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                              Text('SVG, PNG, JPG (MAX. 800×400px)', style: AppTextStyles.caption.copyWith(color: const Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category Name', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _nameCtrl,
                            decoration: InputDecoration(
                              hintText: 'e.g. Summer Collection',
                              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _descCtrl,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Describe the items in this category...',
                              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setState(() => _showAddModal = false),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.border),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                minimumSize: const Size(0, 48),
                              ),
                              child: Text('Cancel', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.textSecondary)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: _nameCtrl,
                              builder: (_, val, __) {
                                final enabled = _nameCtrl.text.trim().isNotEmpty;
                                return ElevatedButton(
                                  onPressed: enabled ? _createCategory : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: enabled ? AppColors.primary : AppColors.border,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    minimumSize: const Size(0, 48),
                                    elevation: 0,
                                  ),
                                  child: Text('Create Category', style: AppTextStyles.subtitleMedium.copyWith(color: enabled ? Colors.white : AppColors.textSecondary)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Toast
          if (_toast != null)
            Positioned(
              bottom: 24, left: 32, right: 32,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(16)),
                child: Text(_toast!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(_Category cat, {required bool isActive}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Opacity(
        opacity: isActive ? 1.0 : 0.6,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.gripVertical, size: 18, color: Color(0xFFCBD5E1)),
              const SizedBox(width: 8),
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(LucideIcons.folderOpen, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cat.name, style: AppTextStyles.subtitleMedium),
                    Row(
                      children: [
                        Text('${cat.items} items', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFFF0FDF4) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isActive ? 'Active' : 'Inactive',
                            style: AppTextStyles.caption.copyWith(
                              color: isActive ? const Color(0xFF22C55E) : const Color(0xFF94A3B8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isActive) ...[
                IconButton(
                  icon: const Icon(LucideIcons.pencil, size: 14, color: AppColors.primary),
                  onPressed: () {},
                  style: IconButton.styleFrom(backgroundColor: AppColors.primary.withOpacity(0.08)),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 14, color: Color(0xFFEF4444)),
                  onPressed: () => _deleteCategory(cat.id),
                  style: IconButton.styleFrom(backgroundColor: const Color(0xFFFEE2E2)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
