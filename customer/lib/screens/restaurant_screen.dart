import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import '../models/food_item.dart';
import '../providers/store_status_provider.dart';
import '../widgets/store_status_badge.dart';
import 'food_detail_screen.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> restaurantData;

  const RestaurantScreen({super.key, required this.restaurantData});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  bool _isFavourite = false;

  String get _name => widget.restaurantData['name'] as String? ?? 'Restaurant';
  String get _img => widget.restaurantData['img'] as String? ?? '';
  String get _rating => widget.restaurantData['rating'] as String? ?? '4.5';
  String get _time => widget.restaurantData['time'] as String? ?? '20-30 min';
  String get _fee => widget.restaurantData['fee'] as String? ?? '₵15 Delivery';
  String get _cat => widget.restaurantData['cat'] as String? ?? 'Restaurant';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── Hero AppBar ─────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 256.0,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _circleButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _circleButton(
                  icon: Icons.search,
                  onTap: () => Navigator.pushNamed(context, '/search'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _circleButton(
                  icon: _isFavourite ? Icons.favorite : Icons.favorite_border,
                  iconColor: _isFavourite ? const Color(0xFFEF4444) : const Color(0xFF0F172A),
                  onTap: () => setState(() => _isFavourite = !_isFavourite),
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: _name,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _img.startsWith('http')
                        ? Image.network(_img, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE2E8F0)))
                        : Image.asset(_img, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE2E8F0))),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Restaurant Info ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name,
                    style: AppFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: const Color(0xFF334155), letterSpacing: -1.0),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _cat,
                    style: AppFonts.inter(fontSize: 14, color: const Color(0xFF8A8A8E)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFEAB308), size: 16),
                      const SizedBox(width: 4),
                      Text(_rating, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                      const SizedBox(width: 4),
                      Text('(1.2k+ reviews)', style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _infoChip('DELIVERY TIME', _time)),
                      const SizedBox(width: 16),
                      Expanded(child: _infoChip('DELIVERY FEE', _fee)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Menu sections ────────────────────────────────────────────────
          _menuSection(
            context,
            'Popular Items',
            [
              _MenuItem(
                title: 'Fried Chicken & Jollof Rice',
                description: 'Our signature spicy jollof rice served with 2 pieces of crispy fried chicken.',
                price: 12.50,
                imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=200',
                addonGroups: [
                  AddonGroup(
                    name: 'Choose your protein',
                    isRequired: true,
                    minSelections: 1,
                    maxSelections: 1,
                    options: [
                      AddonOption('Grilled Chicken', 0.0),
                      AddonOption('Fried Fish', 3.00),
                      AddonOption('Beef Suya', 4.00),
                    ],
                  ),
                  AddonGroup(
                    name: 'Add extras',
                    isRequired: false,
                    minSelections: 0,
                    maxSelections: 3,
                    options: [
                      AddonOption('Extra Plantain', 2.00),
                      AddonOption('Boiled Egg', 1.50),
                      AddonOption('Coleslaw', 2.00),
                      AddonOption('Shito Sauce', 0.00),
                    ],
                  ),
                ],
              ),
              _MenuItem(
                title: 'Family Pack Special',
                description: '8 pieces of chicken, large family-sized jollof, 4 sides of coleslaw and drinks.',
                price: 35.00,
                imageUrl: 'https://images.unsplash.com/photo-1574484284002-952d92456975?auto=format&fit=crop&q=80&w=200',
                addonGroups: [
                  AddonGroup(
                    name: 'Pack size',
                    isRequired: true,
                    minSelections: 1,
                    maxSelections: 1,
                    options: [
                      AddonOption('Standard (8 pieces)', 0.0),
                      AddonOption('Large (12 pieces)', 15.00),
                    ],
                  ),
                  AddonGroup(
                    name: 'Drink upgrade',
                    isRequired: false,
                    minSelections: 0,
                    maxSelections: 1,
                    options: [
                      AddonOption('Water (4 bottles)', 0.0),
                      AddonOption('Soft Drinks (4 cans)', 8.00),
                      AddonOption('Sobolo (4 cups)', 12.00),
                    ],
                  ),
                ],
              ),
            ],
          ),

          _menuSection(
            context,
            'Rice Dishes',
            [
              _MenuItem(
                title: 'Fried Rice with Beef',
                description: 'Authentic stir-fried rice with seasoned beef chunks and fresh vegetables.',
                price: 10.00,
                imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&q=80&w=200',
                addonGroups: [
                  AddonGroup(
                    name: 'Protein choice',
                    isRequired: true,
                    minSelections: 1,
                    maxSelections: 1,
                    options: [
                      AddonOption('Seasoned Beef', 0.0),
                      AddonOption('Chicken', 3.00),
                      AddonOption('Tuna', 4.00),
                    ],
                  ),
                  AddonGroup(
                    name: 'Add-ons',
                    isRequired: false,
                    minSelections: 0,
                    maxSelections: 2,
                    options: [
                      AddonOption('Extra Sauce', 1.00),
                      AddonOption('Fried Plantain', 2.50),
                    ],
                  ),
                ],
              ),
              _MenuItem(
                title: 'Waakye Special',
                description: 'Waakye with spaghetti, salad, fried plantain and your choice of protein.',
                price: 13.00,
                imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&q=80&w=200',
                addonGroups: [
                  AddonGroup(
                    name: 'Protein',
                    isRequired: true,
                    minSelections: 1,
                    maxSelections: 1,
                    options: [
                      AddonOption('Boiled Egg', 0.0),
                      AddonOption('Fried Fish', 4.00),
                      AddonOption('Beef', 5.00),
                      AddonOption('Tilapia', 8.00),
                    ],
                  ),
                  AddonGroup(
                    name: 'Sides',
                    isRequired: false,
                    minSelections: 0,
                    maxSelections: 3,
                    options: [
                      AddonOption('Spaghetti', 0.0),
                      AddonOption('Gari', 0.0),
                      AddonOption('Wele (Cow skin)', 3.00),
                      AddonOption('Shito', 1.00),
                    ],
                  ),
                  AddonGroup(
                    name: 'Drink',
                    isRequired: false,
                    minSelections: 0,
                    maxSelections: 1,
                    options: [
                      AddonOption('Sobolo', 5.00),
                      AddonOption('Water', 3.00),
                    ],
                  ),
                ],
              ),
            ],
          ),

          _menuSection(
            context,
            'Sides',
            [
              _MenuItem(
                title: 'Kelewele',
                description: 'Spicy fried plantain cubes with ginger.',
                price: 4.50,
              ),
              _MenuItem(
                title: 'Coleslaw',
                description: 'Creamy fresh vegetable salad.',
                price: 2.00,
              ),
            ],
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF0F172A),
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: 20),
        onPressed: onTap,
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(label, style: AppFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8), letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0068FF))),
        ],
      ),
    );
  }

  SliverToBoxAdapter _menuSection(
    BuildContext context,
    String title,
    List<_MenuItem> items,
  ) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Text(title, style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          ),
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 32, color: Color(0xFFF1F5F9)),
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FoodDetailScreen(
                        title: item.title,
                        description: item.description,
                        price: item.price,
                        imageUrl: item.imageUrl,
                        restaurantId: _name,
                        restaurantName: _name,
                        addonGroups: item.addonGroups,
                      ),
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                          const SizedBox(height: 4),
                          Text(item.description, style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B)), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text('₵${item.price.toStringAsFixed(2)}', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: item.imageUrl != null ? const Color(0xFF0068FF) : const Color(0x1A0052CC),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add, color: item.imageUrl != null ? Colors.white : const Color(0xFF0068FF), size: 14),
                                    if (item.imageUrl != null) ...[
                                      const SizedBox(width: 4),
                                      Text('Add', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (item.imageUrl != null) ...[
                      const SizedBox(width: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.imageUrl!,
                          width: 96, height: 96,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 96, height: 96,
                            decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.fastfood_outlined, color: Color(0xFF94A3B8)),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final String description;
  final double price;
  final String? imageUrl;
  final List<AddonGroup>? addonGroups;

  const _MenuItem({
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
    this.addonGroups,
  });
}
