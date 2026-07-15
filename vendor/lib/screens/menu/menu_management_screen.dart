import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/vendor_config.dart';
import 'add_edit_product_screen.dart';
import 'bulk_disable_confirmation_sheet.dart';
import 'category_management_screen.dart';
import 'import_products_screen.dart';
import 'out_of_stock_sheet.dart';
import 'product_options_menu_sheet.dart';

class MenuItem {
  final int id;
  final String name;
  final String category;
  final String price;
  bool inStock;
  bool enabled;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.inStock,
    required this.enabled,
  });
}

class MenuManagementScreen extends StatefulWidget {
  final String vendorType;

  const MenuManagementScreen({super.key, this.vendorType = 'restaurant'});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  late VendorConfig _cfg;
  String _search = '';
  String _activeTab = 'All';
  String? _toast;
  final Set<int> _selected = {};

  late List<MenuItem> _items;

  @override
  void initState() {
    super.initState();
    _cfg = getVendorConfig(widget.vendorType);
    _items = [
      MenuItem(id: 1, name: 'Jollof Rice Special', category: _cfg.categories.length > 1 ? _cfg.categories[1] : 'Starters', price: '₵12.50', inStock: true, enabled: true),
      MenuItem(id: 2, name: 'Spicy Pepper Soup', category: _cfg.categories.length > 2 ? _cfg.categories[2] : 'Mains', price: '₵8.00', inStock: true, enabled: true),
      MenuItem(id: 3, name: 'Classic Cola', category: _cfg.categories.length > 3 ? _cfg.categories[3] : 'Drinks', price: '₵3.50', inStock: true, enabled: true),
      MenuItem(id: 4, name: 'Grilled Chicken', category: _cfg.categories.length > 1 ? _cfg.categories[1] : 'Starters', price: '₵15.00', inStock: false, enabled: true),
      MenuItem(id: 5, name: 'Butter Croissant', category: _cfg.categories.length > 2 ? _cfg.categories[2] : 'Mains', price: '₵5.50', inStock: true, enabled: false),
    ];
  }

  void _showToast(String msg) {
    setState(() => _toast = msg);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _toast = null);
    });
  }

  List<MenuItem> get _filtered {
    return _items.where((item) {
      final matchTab = _activeTab == 'All' || item.category == _activeTab;
      final matchSearch = item.name.toLowerCase().contains(_search.toLowerCase());
      return matchTab && matchSearch;
    }).toList();
  }

  void _toggleSelect(int id) {
    setState(() {
      _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
    });
  }

  Future<void> _toggleEnabled(int id) async {
    final idx = _items.indexWhere((it) => it.id == id);
    if (idx != -1) {
      if (_items[idx].enabled) {
        final result = await OutOfStockSheet.show(context);
        if (result == null) return;
      }
      setState(() {
        _items[idx].enabled = !_items[idx].enabled;
        _items[idx].inStock = _items[idx].enabled;
      });
      _showToast('${_items[idx].name} ${_items[idx].enabled ? 'enabled' : 'disabled'}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              SafeArea(
                bottom: false,
                child: Container(
                  color: AppColors.background.withOpacity(0.95),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(LucideIcons.arrowLeft, size: 18, color: AppColors.textPrimary),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Expanded(
                              child: Text(_cfg.catalogLabel, style: AppTextStyles.heading2.copyWith(fontSize: 18), textAlign: TextAlign.center),
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.uploadCloud, size: 20, color: AppColors.textPrimary),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const ImportProductsScreen(),
                                ));
                              },
                            ),
                            IconButton(
                              icon: Container(
                                width: 36, height: 36,
                                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => AddEditProductScreen(vendorType: widget.vendorType),
                                ));
                              },
                            ),
                          ],
                        ),
                      ),
                      // Search bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Icon(LucideIcons.search, size: 15, color: Color(0xFF64748B)),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  onChanged: (v) => setState(() => _search = v),
                                  decoration: InputDecoration(
                                    hintText: _cfg.searchPlaceholder,
                                    hintStyle: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF64748B)),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Category tabs
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16),
                        child: Row(
                          children: _cfg.categories.map((tab) {
                            final isActive = _activeTab == tab;
                            return GestureDetector(
                              onTap: () => setState(() => _activeTab = tab),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(0, 12, 24, 12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isActive ? AppColors.primary : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  tab,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: isActive ? AppColors.primary : const Color(0xFF64748B),
                                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(height: 1, color: AppColors.border),
                    ],
                  ),
                ),
              ),

              // Bulk action bar
              if (_selected.isNotEmpty)
                Container(
                  color: const Color(0xFF0F172A),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_selected.length} selected', style: AppTextStyles.subtitleMedium.copyWith(color: Colors.white)),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => setState(() => _selected.clear()),
                            child: Text('Clear', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8))),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () async {
                              final confirm = await BulkDisableConfirmationSheet.show(context, _selected.length);
                              if (confirm == true) {
                                setState(() {
                                  for (var item in _items) {
                                    if (_selected.contains(item.id)) {
                                      item.enabled = false;
                                      item.inStock = false;
                                    }
                                  }
                                  _selected.clear();
                                });
                                _showToast('Items disabled successfully');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(20)),
                              child: Text('Disable Items', style: AppTextStyles.captionBold.copyWith(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              // Items list
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.package, size: 40, color: Color(0xFFCBD5E1)),
                            const SizedBox(height: 12),
                            Text('No ${_cfg.itemLabelPlural.toLowerCase()} found', style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF94A3B8))),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final item = _filtered[i];
                          final isSelected = _selected.contains(item.id);
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
                            ),
                            child: Row(
                              children: [
                                // Checkbox
                                GestureDetector(
                                  onTap: () => _toggleSelect(item.id),
                                  child: Container(
                                    width: 20, height: 20,
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primary : Colors.transparent,
                                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.center,
                                    child: isSelected ? const Icon(LucideIcons.check, size: 12, color: Colors.white) : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Item image placeholder
                                Container(
                                  width: 64, height: 64,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(LucideIcons.package, size: 24, color: AppColors.primary),
                                ),
                                const SizedBox(width: 12),
                                // Item info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.name, style: AppTextStyles.subtitle),
                                      const SizedBox(height: 2),
                                      Text('${item.category} · ${item.price}', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            width: 8, height: 8,
                                            decoration: BoxDecoration(
                                              color: item.inStock ? const Color(0xFF22C55E) : const Color(0xFF94A3B8),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item.inStock ? 'In Stock' : 'Out of Stock',
                                            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Controls
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => _toggleEnabled(item.id),
                                      child: Container(
                                        width: 44, height: 24,
                                        decoration: BoxDecoration(
                                          color: item.enabled ? AppColors.primary : AppColors.border,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: AnimatedAlign(
                                          duration: const Duration(milliseconds: 200),
                                          alignment: item.enabled ? Alignment.centerRight : Alignment.centerLeft,
                                          child: Container(
                                            margin: const EdgeInsets.all(2),
                                            width: 20, height: 20,
                                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        final action = await ProductOptionsMenuSheet.show(context, item.name);
                                        if (action != null) {
                                          _showToast('Selected action: $action for ${item.name}');
                                        }
                                      },
                                      child: const Icon(LucideIcons.moreVertical, size: 14, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'cat',
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => CategoryManagementScreen(vendorType: widget.vendorType),
              ));
            },
            child: const Icon(LucideIcons.folderOpen, size: 18),
          ),
        ],
      ),
    );
  }
}
