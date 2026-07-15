import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'restaurant_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  int _selectedRestaurantFilter = 0;
  int _selectedDishFilter = 0;

  final List<String> _filters = [
    'All',
    'Fast Food',
    'Local Food',
    'Groceries',
    'Laundry',
  ];

  final List<String> _dishFilters = ['All', 'Rice', 'Street Food', 'Snacks', 'Grills'];

  List<Map<String, dynamic>> _favouriteRestaurants = [
    {
      'img': 'assets/images/home/popular_nana.png',
      'name': 'Nana Konadu Joint',
      'cat': 'Local food',
      'time': '30-40 min',
      'fee': '₵15 Delivery',
      'rating': '4.7',
      'tag': 'hero_nana',
    },
    {
      'img': 'assets/images/home/popular_bigimage.png',
      'name': 'Big Image Paradise',
      'cat': 'Local foods',
      'time': '15-25 min',
      'fee': 'Free Delivery',
      'rating': '4.9',
      'tag': 'hero_big',
    },
    {
      'img': 'assets/images/home/story_papaye.png',
      'name': 'Papaye Fast Food',
      'cat': 'Fast Food',
      'time': '20-30 min',
      'fee': '₵12 Delivery',
      'rating': '4.6',
      'tag': 'hero_papaye',
    },
  ];

  List<Map<String, dynamic>> _favouriteDishes = [
    {
      'img': 'assets/images/home/street_abaawa.png',
      'name': 'Abaawa Kebab',
      'restaurant': 'Street Kitchen',
      'price': '₵24.00',
      'cuisine': 'Grills',
    },
    {
      'img': 'assets/images/home/street_area_mama.png',
      'name': 'Area Mama Special',
      'restaurant': 'Local Spot',
      'price': '₵28.00',
      'cuisine': 'Street Food',
    },
    {
      'img': 'assets/images/home/street_abaawa.png',
      'name': 'Jollof Rice Combo',
      'restaurant': 'Papaye Fast Food',
      'price': '₵45.00',
      'cuisine': 'Rice',
    },
    {
      'img': 'assets/images/home/street_area_mama.png',
      'name': 'Kelewele',
      'restaurant': 'Nana Konadu Joint',
      'price': '₵8.00',
      'cuisine': 'Snacks',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredRestaurants {
    if (_selectedRestaurantFilter == 0) return _favouriteRestaurants;
    final filter = _filters[_selectedRestaurantFilter].toLowerCase();
    return _favouriteRestaurants.where((r) {
      return (r['cat'] as String).toLowerCase().contains(filter);
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredDishes {
    if (_selectedDishFilter == 0) return _favouriteDishes;
    final filter = _dishFilters[_selectedDishFilter];
    return _favouriteDishes.where((d) => d['cuisine'] == filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF0F172A),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Favourites',
          style: AppFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF0068FF),
          indicatorWeight: 3,
          labelColor: const Color(0xFF0068FF),
          unselectedLabelColor: const Color(0xFF94A3B8),
          labelStyle: AppFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'Restaurants'),
            Tab(text: 'Dishes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRestaurantsTab(),
          _buildDishesTab(),
        ],
      ),
    );
  }

  // ─────────────────────── FILTER CHIPS ───────────────────────

  Widget _buildFilterChips(int selected, ValueChanged<int> onSelected) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isSelected = selected == i;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0068FF) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0068FF)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Text(
                _filters[i],
                style: AppFonts.inter(
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────── DISH FILTER CHIPS ────────────────────

  Widget _buildDishFilterChips(int selected, ValueChanged<int> onSelected) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _dishFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isSelected = selected == i;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0068FF) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF0068FF) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Text(
                _dishFilters[i],
                style: AppFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────── RESTAURANTS TAB ────────────────────

  Widget _buildRestaurantsTab() {
    final filtered = _filteredRestaurants;
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildFilterChips(_selectedRestaurantFilter, (i) {
          setState(() => _selectedRestaurantFilter = i);
        }),
        const SizedBox(height: 16),
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) =>
                      _buildRestaurantCard(filtered[i]),
                ),
        ),
      ],
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> r) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RestaurantScreen(restaurantData: r),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with overlaid badges
            Stack(
              children: [
                Hero(
                  tag: r['tag']!,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      r['img']!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Filled red heart — tapping removes from list
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _favouriteRestaurants.remove(r));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          BoxShadow(color: Color(0x14000000), blurRadius: 6),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 20,
                        color: Color(0xFFE53E3E),
                      ),
                    ),
                  ),
                ),
                // Delivery time badge
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      r['time']!,
                      style: AppFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Info row
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          r['name']!,
                          style: AppFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              r['rating']!,
                              style: AppFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFFB135),
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        r['cat']!,
                        style: AppFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.circle,
                          size: 4,
                          color: Color(0xFFCBD5E1),
                        ),
                      ),
                      Icon(
                        Icons.delivery_dining_outlined,
                        size: 16,
                        color: r['fee'] == 'Free Delivery'
                            ? const Color(0xFF16A34A)
                            : const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        r['fee']!,
                        style: AppFonts.inter(
                          fontSize: 13,
                          fontWeight: r['fee'] == 'Free Delivery'
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: r['fee'] == 'Free Delivery'
                              ? const Color(0xFF16A34A)
                              : const Color(0xFF64748B),
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

  // ─────────────────────── DISHES TAB ─────────────────────────

  Widget _buildDishesTab() {
    final filtered = _filteredDishes;
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildDishFilterChips(_selectedDishFilter, (i) {
          setState(() => _selectedDishFilter = i);
        }),
        const SizedBox(height: 16),
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) => _buildDishCard(filtered[i]),
                ),
        ),
      ],
    );
  }

  Widget _buildDishCard(Map<String, dynamic> d) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
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
      ),
      child: Row(
        children: [
          // Square image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              d['img']!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d['name']!,
                  style: AppFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  d['restaurant']!,
                  style: AppFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  d['price']!,
                  style: AppFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0068FF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Actions: heart + add button
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() => _favouriteDishes.remove(d));
                },
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFFE53E3E),
                  size: 22,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF0068FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────── EMPTY STATE ────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF5FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_outline,
                color: Color(0xFF0068FF),
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Favourites Yet',
              style: AppFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Items you love will appear here',
              textAlign: TextAlign.center,
              style: AppFonts.inter(
                fontSize: 14,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0068FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Start Exploring',
                  style: AppFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
