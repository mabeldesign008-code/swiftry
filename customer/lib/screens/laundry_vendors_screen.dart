import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';
import '../providers/store_status_provider.dart';
import '../widgets/store_status_badge.dart';
import 'vendor_store_screen.dart';

class LaundryVendorsScreen extends ConsumerStatefulWidget {
  const LaundryVendorsScreen({super.key});

  @override
  ConsumerState<LaundryVendorsScreen> createState() => _LaundryVendorsScreenState();
}

class _LaundryVendorsScreenState extends ConsumerState<LaundryVendorsScreen> {
  int _selectedFilter = 0;
  final Set<String> _favouriteVendors = {'CleanPro Laundry'}; // pre-init from isFavorite: true

  final List<String> _filters = [
    'All',
    'Wash & Fold',
    'Wash & Iron',
    'Dry Cleaning',
    'Bulk Laundry',
  ];

  final List<_VendorData> _vendors = [
    _VendorData(
      name: 'CleanPro Laundry',
      services: 'Wash & Fold • Dry Cleaning • Ironing',
      rating: '4.7',
      reviews: '150+',
      distance: '1.2 km',
      turnaround: '2-3 days',
      priceFrom: '₵5/item',
      imageUrl: 'https://images.unsplash.com/photo-1545173168-9f1947eebb7f?auto=format&fit=crop&q=80&w=600',
      isFavorite: true,
    ),
    _VendorData(
      name: 'Elite Garment Care',
      services: 'Dry Cleaning • Premium Ironing • Suede',
      rating: '4.9',
      reviews: '80+',
      distance: '2.5 km',
      turnaround: '1-2 days',
      priceFrom: '₵12/item',
      imageUrl: 'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?auto=format&fit=crop&q=80&w=600',
      isFavorite: false,
    ),
    _VendorData(
      name: 'The Laundry Hub',
      services: 'Bulk Laundry • Wash & Fold • Duvets',
      rating: '4.5',
      reviews: '210+',
      distance: '0.8 km',
      turnaround: '3-4 days',
      priceFrom: '₵3/item',
      imageUrl: 'https://images.unsplash.com/photo-1604335399105-a0c585fd81a1?auto=format&fit=crop&q=80&w=600',
      isFavorite: false,
    ),
  ];

  List<_VendorData> get _filteredVendors {
    if (_selectedFilter == 0) return _vendors;
    final keyword = _filters[_selectedFilter].toLowerCase();
    return _vendors.where((v) {
      final s = v.services.toLowerCase();
      if (keyword.contains('wash & fold')) return s.contains('wash & fold');
      if (keyword.contains('wash & iron')) return s.contains('iron');
      if (keyword.contains('dry cleaning')) return s.contains('dry clean');
      if (keyword.contains('bulk')) return s.contains('bulk');
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
                        ),
                        const Spacer(),
                        Text(
                          'Laundry',
                          style: AppFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.tune, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                  ),
                ),

                // Filter Chips
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: _filters.length,
                    itemBuilder: (context, i) {
                      final isActive = i == _selectedFilter;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedFilter = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
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
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isActive ? Colors.white : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Sort & Filter Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Sort options coming soon', style: AppFonts.inter(color: Colors.white)),
                          backgroundColor: const Color(0xFF0F172A),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          duration: const Duration(seconds: 2),
                        )),
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
                                'Sort: Recommended',
                                style: AppFonts.inter(fontSize: 14, color: const Color(0xFF334155)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Advanced filters coming soon', style: AppFonts.inter(color: Colors.white)),
                          backgroundColor: const Color(0xFF0F172A),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          duration: const Duration(seconds: 2),
                        )),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.filter_list, color: Color(0xFF334155), size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Filters',
                                style: AppFonts.inter(fontSize: 14, color: const Color(0xFF334155)),
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

          // Vendor List
          Expanded(
            child: _filteredVendors.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 56, color: Color(0xFFCBD5E1)),
                        const SizedBox(height: 12),
                        Text('No vendors for this category yet',
                            style: AppFonts.inter(fontSize: 16, color: const Color(0xFF64748B))),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredVendors.length,
                    itemBuilder: (context, i) => _buildVendorCard(_filteredVendors[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorCard(_VendorData vendor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VendorStoreScreen(
              vendorName: vendor.name,
              vendorImageUrl: vendor.imageUrl,
              vendorRating: vendor.rating,
              vendorTurnaround: vendor.turnaround,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            // Hero image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(
                    vendor.imageUrl,
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      if (_favouriteVendors.contains(vendor.name)) {
                        _favouriteVendors.remove(vendor.name);
                      } else {
                        _favouriteVendors.add(vendor.name);
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
                        _favouriteVendors.contains(vendor.name) ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: _favouriteVendors.contains(vendor.name) ? const Color(0xFFF43F5E) : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Info section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 36, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vendor.name,
                          style: AppFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E3B8A),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0x1AFACC15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: AppTheme.star, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              '${vendor.rating} (${vendor.reviews})',
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
                  Text(
                    vendor.services,
                    style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF94A3B8), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        vendor.distance,
                        style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF94A3B8)),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, color: Color(0xFF94A3B8), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        vendor.turnaround,
                        style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, color: const Color(0xFFF1F5F9)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: AppFonts.inter(fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'From ',
                              style: TextStyle(color: const Color(0xFF64748B)),
                            ),
                            TextSpan(
                              text: vendor.priceFrom,
                              style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontWeight: FontWeight.w600,
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
                          'View Details',
                          style: AppFonts.inter(
                            fontSize: 14,
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

class _VendorData {
  final String name;
  final String services;
  final String rating;
  final String reviews;
  final String distance;
  final String turnaround;
  final String priceFrom;
  final String imageUrl;
  final bool isFavorite;

  const _VendorData({
    required this.name,
    required this.services,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.turnaround,
    required this.priceFrom,
    required this.imageUrl,
    required this.isFavorite,
  });
}
