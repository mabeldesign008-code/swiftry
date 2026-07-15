import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'voice_search_screen.dart';
import 'restaurant_screen.dart';
import 'vendor_list_screen.dart';
import '../models/service_type.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Food', 'Groceries', 'Pharmacy', 'Shop', 'Market'];

  final List<String> _recentSearches = ['Jollof Rice', 'KFC', 'Papaye', 'Pizza'];

  final List<Map<String, dynamic>> _dummyResults = [
    {'title': 'Jollof Rice', 'type': 'Food', 'price': '₵45.00', 'icon': Icons.fastfood, 'vendor': 'Papaye Fast Food', 'subtitle': 'Papaye Fast Food'},
    {'title': 'Waakye Special', 'type': 'Food', 'price': '₵32.00', 'icon': Icons.fastfood, 'vendor': 'Nana Konadu Joint', 'subtitle': 'Nana Konadu Joint'},
    {'title': 'Fried Chicken Combo', 'type': 'Food', 'price': '₵68.00', 'icon': Icons.fastfood, 'vendor': 'Papaye Fast Food', 'subtitle': 'Papaye Fast Food'},
    {'title': 'Fresh Tomatoes', 'type': 'Groceries', 'price': '₵12.00', 'icon': Icons.shopping_basket, 'subtitle': 'per bowl · Maxmart'},
    {'title': 'Eggs (Tray of 30)', 'type': 'Groceries', 'price': '₵55.00', 'icon': Icons.shopping_basket, 'subtitle': 'per tray · Shoprite'},
    {'title': 'Paracetamol 500mg', 'type': 'Pharmacy', 'price': '₵6.00', 'icon': Icons.medical_services, 'subtitle': 'No prescription · Ernest Chemists'},
    {'title': 'Vitamin C 1000mg', 'type': 'Pharmacy', 'price': '₵25.00', 'icon': Icons.medical_services, 'subtitle': 'No prescription · Kinapharma'},
    {'title': 'iPhone Clear Case', 'type': 'Shop', 'price': '₵45.00', 'icon': Icons.phone_android, 'subtitle': 'Tech Hub Nigeria'},
    {'title': 'Polo T-Shirt', 'type': 'Shop', 'price': '₵80.00', 'icon': Icons.checkroom, 'subtitle': 'Kantanka Fashion'},
    {'title': 'Indomie (pack of 40)', 'type': 'Groceries', 'price': '₵65.00', 'icon': Icons.shopping_basket, 'subtitle': 'per pack · Melcom'},
  ];

  List<Map<String, dynamic>> get _filteredResults {
    return _dummyResults.where((item) {
      final matchesText = _searchController.text.isEmpty ||
          item['title'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' ||
          item['type'] == _selectedFilter;
      return matchesText && matchesFilter;
    }).toList();
  }

  void _navigateToResult(Map<String, dynamic> result) {
    final type = result['type'] as String;
    switch (type) {
      case 'Food':
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => RestaurantScreen(restaurantData: {
            'img': 'assets/images/home/story_papaye.png',
            'name': result['vendor'] as String? ?? 'Restaurant',
            'cat': 'Food',
            'time': '20-30 min',
            'fee': '₵12 Delivery',
            'rating': '4.6',
          }),
        ));
        break;
      case 'Groceries':
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => const VendorListScreen(serviceType: ServiceType.groceries),
        ));
        break;
      case 'Pharmacy':
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => const VendorListScreen(serviceType: ServiceType.pharmacy),
        ));
        break;
      case 'Shop':
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => const VendorListScreen(serviceType: ServiceType.shop),
        ));
        break;
      default:
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => const VendorListScreen(serviceType: ServiceType.groceries),
        ));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search restaurants, groceries...',
                    hintStyle: AppFonts.inter(color: const Color(0xFF94A3B8), fontSize: 14),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
              ),
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  child: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 18),
                ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(builder: (_) => const VoiceSearchScreen()),
                  );
                  if (result != null && result.isNotEmpty) {
                    setState(() {
                      _searchController.text = result;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(Icons.mic_outlined, color: const Color(0xFF0068FF), size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0068FF) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? const Color(0xFF0068FF) : const Color(0xFFE2E8F0)),
                    ),
                    child: Center(
                      child: Text(
                        filter,
                        style: AppFonts.inter(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Container(height: 1, color: const Color(0xFFF1F5F9)),

          Expanded(
            child: _searchController.text.isEmpty
                ? _buildRecentSearches()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Recent Searches',
          style: AppFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _recentSearches.map((term) {
            return GestureDetector(
              onTap: () {
                _searchController.text = term;
                _searchController.selection = TextSelection.fromPosition(
                  TextPosition(offset: term.length),
                );
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.history, color: Color(0xFF94A3B8), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      term,
                      style: AppFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    final results = _filteredResults;

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 56, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: AppFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try a different search term or filter',
              style: AppFonts.inter(
                fontSize: 13,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return GestureDetector(
          onTap: () => _navigateToResult(result),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(result['icon'] as IconData, color: const Color(0xFF0068FF)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result['title'] as String,
                        style: AppFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result['type'] as String,
                        style: AppFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      if ((result['subtitle'] as String? ?? '').isNotEmpty)
                        Text(
                          result['subtitle'] as String,
                          style: AppFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                        ),
                    ],
                  ),
                ),
                Text(
                  result['price'] as String,
                  style: AppFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFCBD5E1)),
              ],
            ),
          ),
        );
      },
    );
  }
}
