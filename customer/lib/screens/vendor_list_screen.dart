import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';
import '../models/service_type.dart';
import '../providers/store_status_provider.dart';
import '../widgets/filter_sort_modal.dart';
import '../widgets/store_status_badge.dart';
import 'catalogue_store_screen.dart';

class VendorListScreen extends ConsumerStatefulWidget {
  final ServiceType serviceType;
  const VendorListScreen({super.key, required this.serviceType});

  @override
  ConsumerState<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends ConsumerState<VendorListScreen> {
  int _selectedFilter = 0;
  final Set<String> _favouriteVendors = {};
  FilterSortResult _filterSort = const FilterSortResult();

  /// Applies the current sort/filter selection against the (mock) vendor
  /// list. Previously the "Sort" and "Filters" buttons did nothing.
  List<Map<String, dynamic>> _applyFilterSort(List<Map<String, dynamic>> input) {
    var list = [...input];
    if (_filterSort.minRating > 0) {
      list = list
          .where((v) => (double.tryParse(v['rating'] as String? ?? '0') ?? 0) >= _filterSort.minRating)
          .toList();
    }
    switch (_filterSort.sortBy) {
      case VendorSortBy.recommended:
        break;
      case VendorSortBy.ratingHighToLow:
        list.sort((a, b) => (double.tryParse(b['rating'] as String? ?? '0') ?? 0)
            .compareTo(double.tryParse(a['rating'] as String? ?? '0') ?? 0));
        break;
      case VendorSortBy.deliveryTimeFastest:
        list.sort((a, b) => _firstNumber(a['time'] as String? ?? '').compareTo(_firstNumber(b['time'] as String? ?? '')));
        break;
      case VendorSortBy.priceLowToHigh:
        list.sort((a, b) => _firstNumber(a['fee'] as String? ?? '').compareTo(_firstNumber(b['fee'] as String? ?? '')));
        break;
    }
    return list;
  }

  int _firstNumber(String s) {
    final match = RegExp(r'\d+').firstMatch(s);
    return match != null ? int.parse(match.group(0)!) : 0;
  }

  void _openFilterSortSheet() async {
    final result = await showModalBottomSheet<FilterSortResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSortModal(initial: _filterSort),
    );
    if (result != null && mounted) {
      setState(() => _filterSort = result);
    }
  }

  // ── Filter chips per service ─────────────────────────────────────────────
  List<String> get _filters {
    switch (widget.serviceType) {
      case ServiceType.groceries:
        return ['All', 'Supermarkets', 'Mini-Marts', 'Fresh Produce', 'Wholesale'];
      case ServiceType.shop:
        return ['All', 'Electronics', 'Fashion', 'Beauty', 'Stationery', 'Accessories'];
      case ServiceType.pharmacy:
        return ['All', 'Verified', 'Open Now', 'Prescription Ready', '24 Hours'];
      default:
        return ['All'];
    }
  }

  // ── Mock vendor data per service ─────────────────────────────────────────
  List<Map<String, dynamic>> get _vendors {
    switch (widget.serviceType) {
      case ServiceType.groceries:
        return [
          {
            'name': 'Maxmart Supermarket',
            'image': 'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=800',
            'categories': 'Groceries • Fresh Produce • Dairy',
            'rating': '4.6',
            'reviews': '200+',
            'distance': '1.4 km',
            'time': '20-35 min',
            'fee': '₵8 Delivery',
            'verified': false,
          },
          {
            'name': 'Shoprite - Osu',
            'image': 'https://images.unsplash.com/photo-1534723452862-4c874986ebad?w=800',
            'categories': 'Supermarket • Household • Frozen Foods',
            'rating': '4.8',
            'reviews': '500+',
            'distance': '2.1 km',
            'time': '25-40 min',
            'fee': '₵10 Delivery',
            'verified': false,
          },
          {
            'name': 'Melcom Shopping Centre',
            'image': 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800',
            'categories': 'Groceries • Cosmetics • Stationery',
            'rating': '4.4',
            'reviews': '300+',
            'distance': '3.0 km',
            'time': '30-45 min',
            'fee': '₵12 Delivery',
            'verified': false,
          },
        ];
      case ServiceType.shop:
        return [
          {
            'name': 'Tech Hub Nigeria',
            'image': 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800',
            'categories': 'Phones • Accessories • Gadgets',
            'rating': '4.7',
            'reviews': '180+',
            'distance': '0.9 km',
            'time': '15-25 min',
            'fee': '₵5 Delivery',
            'verified': false,
          },
          {
            'name': 'Kantanka Fashion',
            'image': 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=800',
            'categories': 'Clothing • Shoes • Bags',
            'rating': '4.5',
            'reviews': '120+',
            'distance': '2.3 km',
            'time': '20-35 min',
            'fee': '₵8 Delivery',
            'verified': false,
          },
          {
            'name': 'Beauty Palace',
            'image': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=800',
            'categories': 'Cosmetics • Hair • Skincare',
            'rating': '4.9',
            'reviews': '250+',
            'distance': '1.7 km',
            'time': '25-40 min',
            'fee': '₵7 Delivery',
            'verified': false,
          },
        ];
      case ServiceType.pharmacy:
        return [
          {
            'name': 'Ernest Chemists',
            'image': 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800',
            'categories': 'Medicine • Supplements • Baby Care',
            'rating': '4.8',
            'reviews': '300+',
            'distance': '0.7 km',
            'time': '15-25 min',
            'fee': '₵5 Delivery',
            'verified': true,
          },
          {
            'name': 'Kinapharma Pharmacy',
            'image': 'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?w=800',
            'categories': 'Pharmaceuticals • First Aid • Vitamins',
            'rating': '4.6',
            'reviews': '150+',
            'distance': '1.8 km',
            'time': '20-35 min',
            'fee': '₵8 Delivery',
            'verified': true,
          },
          {
            'name': 'Alliance Pharma',
            'image': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800',
            'categories': 'Medicine • Wellness • Prescription',
            'rating': '4.7',
            'reviews': '200+',
            'distance': '2.5 km',
            'time': '25-40 min',
            'fee': '₵10 Delivery',
            'verified': true,
          },
        ];
      default:
        return [];
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final vendors = _applyFilterSort(_vendors);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // ── Blue gradient SliverAppBar (pinned) ───────────────────────────
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF0068FF),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                ),
              ),
            ),
            title: Text(
              widget.serviceType.label,
              style: AppFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0042CC), Color(0xFF0068FF)],
                ),
              ),
            ),
          ),

          // ── Filter chips + Sort/Filter bar ───────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Filter chips row
                  SizedBox(
                    height: 64,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      itemCount: _filters.length,
                      itemBuilder: (context, i) {
                        final isActive = i == _selectedFilter;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: isActive ? const Color(0xFF0068FF) : Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: isActive ? Colors.transparent : const Color(0xFFE2E8F0),
                              ),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF0068FF).withValues(alpha: 0.2),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Text(
                              _filters[i],
                              style: AppFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isActive ? Colors.white : const Color(0xFF475569),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Sort & Filter buttons row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _openFilterSortSheet,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.sort, color: Color(0xFF334155), size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Sort: ${_filterSort.sortBy.label}',
                                  style: AppFonts.inter(fontSize: 13, color: const Color(0xFF334155)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _openFilterSortSheet,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                            decoration: BoxDecoration(
                              color: _filterSort.isDefault ? Colors.white : const Color(0xFF0068FF).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _filterSort.isDefault ? const Color(0xFFE2E8F0) : const Color(0xFF0068FF)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.filter_list, color: _filterSort.isDefault ? const Color(0xFF334155) : const Color(0xFF0068FF), size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Filters',
                                  style: AppFonts.inter(fontSize: 13, color: _filterSort.isDefault ? const Color(0xFF334155) : const Color(0xFF0068FF)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Vendor list ───────────────────────────────────────────────────
          if (vendors.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off_rounded, size: 56, color: Color(0xFFCBD5E1)),
                    const SizedBox(height: 12),
                    Text(
                      'No vendors available yet',
                      style: AppFonts.inter(fontSize: 16, color: const Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _buildVendorCard(vendors[i]),
                  childCount: vendors.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVendorCard(Map<String, dynamic> vendor) {
    final name = vendor['name'] as String;
    final imageUrl = vendor['image'] as String;
    final categories = vendor['categories'] as String;
    final rating = vendor['rating'] as String;
    final reviews = vendor['reviews'] as String? ?? '100+';
    final distance = vendor['distance'] as String;
    final time = vendor['time'] as String;
    final fee = vendor['fee'] as String;
    final isVerified = vendor['verified'] as bool? ?? false;
    final isFav = _favouriteVendors.contains(name);

    return GestureDetector(
      onTap: () {
        final status = ref.read(storeStatusProvider(name));
        if (!status.isOrderable) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('$name is currently closed. ${nextOpenLabel(name)}',
                style: AppFonts.inter(color: Colors.white, fontSize: 13)),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ));
          return;
        }
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CatalogueStoreScreen(
            serviceType: widget.serviceType,
            vendor: vendor,
          ),
        ),
      );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            // ── Hero image + overlays ──────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: double.infinity,
                      height: 140,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: const Icon(Icons.storefront_rounded, size: 48, color: Color(0xFF94A3B8)),
                    ),
                  ),
                ),
                // Verified badge (pharmacy)
                if (isVerified)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'Verified \u2713',
                            style: AppFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Heart toggle
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      if (isFav) {
                        _favouriteVendors.remove(name);
                      } else {
                        _favouriteVendors.add(name);
                      }
                    }),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isFav ? const Color(0xFFF43F5E) : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Info section ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + rating badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: AppFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E3B8A),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0x1AFACC15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: AppTheme.star, size: 12),
                            const SizedBox(width: 3),
                            Text(
                              '$rating ($reviews)',
                              style: AppFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Categories
                  Text(
                    categories,
                    style: AppFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 10),
                  // Distance + Time
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF94A3B8), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: AppFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, color: Color(0xFF94A3B8), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: AppFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, color: const Color(0xFFF1F5F9)),
                  const SizedBox(height: 12),
                  // Delivery fee + View Store button
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0x1A0068FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.delivery_dining, color: Color(0xFF0068FF), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              fee,
                              style: AppFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0068FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0x1A1E3B8A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'View Store',
                          style: AppFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E3B8A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
