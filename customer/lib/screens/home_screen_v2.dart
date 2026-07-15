import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'restaurant_screen.dart';
import 'laundry_vendors_screen.dart';
import 'errand_selection_screen.dart';
import 'profile_screen.dart';
import 'orders_screen.dart';
import '../widgets/animated_press.dart';
import 'location_search_screen.dart';
import 'search_screen.dart';
import 'search_view.dart';
import 'notifications_screen.dart';
import '../models/service_type.dart';
import '../models/address.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/food_cart_provider.dart';
import 'vendor_list_screen.dart';
import 'market_screen.dart';
import 'parcel_selection_screen.dart';
import 'food_detail_screen.dart';
import 'checkout_screen.dart';
import 'order_tracking_screen.dart';
import '../providers/active_order_provider.dart';
import 'market_shopping_list_screen.dart';
import '../providers/notifications_provider.dart';
import '../providers/vendor_stories_provider.dart';
import 'vendor_story_screen.dart';

class HomeScreenV2 extends ConsumerStatefulWidget {
  const HomeScreenV2({super.key});

  @override
  ConsumerState<HomeScreenV2> createState() => _HomeScreenV2State();
}

class _HomeScreenV2State extends ConsumerState<HomeScreenV2> {
  bool _isLoading = false;
  int _selectedTab = 0;
  int _selectedNav = 0;
  int _promoIndex = 0;
  final PageController _promoController = PageController();
  String _locationName = 'Obuasi, Kumasi';
  final Set<String> _favouriteRestaurants = {};
  ServiceType _selectedServiceType = ServiceType.food;
  String _marketMode = 'browse'; // 'browse' or 'list'

  final List<String> _groceryFilterTabs = [
    'All',
    'Supermarket Groceries',
    'Dairy & Eggs',
    'Frozen Foods'
  ];

  final List<Map<String, dynamic>> _allGroceryVendors = [
    {
      'img': 'assets/images/figma_groceries/konadu_groceries.png',
      'name': 'Konadu Groceries Store - Regular',
      'cat': 'Supermarket',
      'time': '30mins',
      'fee': '₵35',
      'price': '₵35',
      'rating': '4.7',
      'reviews': '200+',
      'distance': '1.2 km'
    },
    {
      'img': 'assets/images/figma_groceries/big_image_paradise.png',
      'name': 'Big Image Paradise Eggs Store',
      'cat': 'Diary and Eggs',
      'time': '15 mins',
      'fee': '₵35',
      'price': '₵35',
      'rating': '4.7',
      'reviews': '120+',
      'distance': '2.5 km'
    },
  ];

  final List<Map<String, dynamic>> _featuredGroceryStores = [
    {
      'img': 'assets/images/figma_groceries/abaawa_groceries.png',
      'name': 'Abaawa Groceries',
      'rating': '4.8',
      'reviews': '150 reviews',
      'price': '₵24.0'
    },
    {
      'img': 'assets/images/home/street_areamama.jpg',
      'name': 'Area Mama Speci',
      'rating': '4.8',
      'reviews': '150 reviews',
      'price': '₵24.0'
    },
  ];

  final List<String> _marketFilterTabs = [
    'All',
    'Electronics',
    'Clothing',
    'Furniture',
    'Food Items'
  ];

  final List<Map<String, dynamic>> _allMarketVendors = [
    {
      'img': 'assets/images/home/restaurant_nana.jpg',
      'name': 'Kumasi Central Market',
      'cat': 'Electronics',
      'time': '25 mins',
      'fee': '₵10 Delivery',
      'rating': '4.6',
      'reviews': '310+',
      'distance': '2.0 km'
    },
    {
      'img': 'assets/images/home/restaurant_bigimage.jpg',
      'name': 'Kejetia Traders Hub',
      'cat': 'Clothing',
      'time': '20 mins',
      'fee': 'Free Delivery',
      'rating': '4.5',
      'reviews': '180+',
      'distance': '3.1 km'
    },
  ];

  final List<Map<String, dynamic>> _featuredMarketStores = [
    {
      'img': 'assets/images/home/street_abaawa.jpg',
      'name': 'Aba Electronics',
      'rating': '4.7',
      'reviews': '200 reviews',
      'price': '₵30.0'
    },
    {
      'img': 'assets/images/home/street_areamama.jpg',
      'name': 'Kejetia Fashion',
      'rating': '4.5',
      'reviews': '130 reviews',
      'price': '₵18.0'
    },
  ];

  final List<Map<String, dynamic>> _popularMarketStores = [
    {
      'img': 'assets/images/home/restaurant_nana.jpg',
      'name': 'Adum Tech Market',
      'cat': 'Electronics',
      'time': '30 mins',
      'fee': '₵12 Delivery',
      'rating': '4.6',
      'price': '₵50'
    },
    {
      'img': 'assets/images/home/restaurant_bigimage.jpg',
      'name': 'Kejetia Womenswear',
      'cat': 'Clothing',
      'time': '20 mins',
      'fee': 'Free Delivery',
      'rating': '4.4',
      'price': '₵25'
    },
  ];

  // ── Shop ──────────────────────────────────────────────────────────────
  final List<String> _shopFilterTabs = [
    'All',
    'Clothing',
    'Electronics',
    'Shoes',
    'Accessories',
  ];

  final List<Map<String, dynamic>> _allShopVendors = [
    {
      'img': 'assets/images/home/restaurant_nana.jpg',
      'name': 'Accra Mall Fashion Hub',
      'cat': 'Clothing',
      'time': '35 mins',
      'fee': '₵8 Delivery',
      'rating': '4.6',
      'reviews': '250+',
      'distance': '1.8 km'
    },
    {
      'img': 'assets/images/home/restaurant_bigimage.jpg',
      'name': 'TechZone Electronics',
      'cat': 'Electronics',
      'time': '25 mins',
      'fee': 'Free Delivery',
      'rating': '4.5',
      'reviews': '190+',
      'distance': '2.3 km'
    },
    {
      'img': 'assets/images/home/story_papaye.jpg',
      'name': 'SoleKing Shoe Store',
      'cat': 'Shoes',
      'time': '30 mins',
      'fee': '₵5 Delivery',
      'rating': '4.7',
      'reviews': '300+',
      'distance': '3.0 km'
    },
  ];

  final List<Map<String, dynamic>> _featuredShopStores = [
    {
      'img': 'assets/images/home/street_abaawa.jpg',
      'name': 'Accra Mall Fashion',
      'rating': '4.6',
      'reviews': '250 reviews',
      'price': '₵45.0'
    },
    {
      'img': 'assets/images/home/street_areamama.jpg',
      'name': 'SoleKing Shoes',
      'rating': '4.7',
      'reviews': '300 reviews',
      'price': '₵80.0'
    },
  ];

  final List<Map<String, dynamic>> _popularShopStores = [
    {
      'img': 'assets/images/home/restaurant_nana.jpg',
      'name': 'Accra Mall Fashion Hub',
      'cat': 'Clothing',
      'time': '35 mins',
      'fee': '₵8 Delivery',
      'rating': '4.6',
      'price': '₵45'
    },
    {
      'img': 'assets/images/home/restaurant_bigimage.jpg',
      'name': 'TechZone Electronics',
      'cat': 'Electronics',
      'time': '25 mins',
      'fee': 'Free Delivery',
      'rating': '4.5',
      'price': '₵120'
    },
  ];

  // ── Pharmacy ──────────────────────────────────────────────────────────
  final List<String> _pharmacyFilterTabs = [
    'All',
    'Supermarket Groceries',
    'Dairy & Eggs',
    'Frozen Foods',
  ];

  final List<Map<String, dynamic>> _allPharmacyVendors = [
    {
      'img': 'assets/images/figma_pharmacy/konadu_otc_store.jpg',
      'name': 'Konadu OTC Store  - Regular',
      'cat': 'Pharmacy',
      'time': '30mins',
      'fee': '₵35',
      'price': '₵35',
      'rating': '4.7',
      'reviews': '200+',
      'distance': '1.0 km'
    },
    {
      'img': 'assets/images/figma_pharmacy/big_paradise_pharmacy.jpg',
      'name': 'Big Paradise Pharmacy Store',
      'cat': 'Pharmacy',
      'time': '15 mins',
      'fee': '₵35',
      'price': '₵35',
      'rating': '4.7',
      'reviews': '300+',
      'distance': '2.5 km'
    },
  ];

  final List<Map<String, dynamic>> _featuredPharmacyStores = [
    {
      'img': 'assets/images/figma_pharmacy/konadu_otc_store.jpg',
      'name': 'Konadu OTC Store',
      'rating': '4.7',
      'reviews': '200 reviews',
      'price': '₵35.0'
    },
    {
      'img': 'assets/images/figma_pharmacy/big_paradise_pharmacy.jpg',
      'name': 'Big Paradise Pharmacy',
      'rating': '4.7',
      'reviews': '300 reviews',
      'price': '₵35.0'
    },
  ];

  final List<Map<String, dynamic>> _popularPharmacyStores = [
    {
      'img': 'assets/images/figma_pharmacy/konadu_otc_store.jpg',
      'name': 'Konadu OTC Store - Regular',
      'cat': 'Pharmacy',
      'time': '30mins',
      'fee': '₵35',
      'rating': '4.7',
      'price': '₵35'
    },
    {
      'img': 'assets/images/figma_pharmacy/big_paradise_pharmacy.jpg',
      'name': 'Big Paradise Pharmacy Store',
      'cat': 'Pharmacy',
      'time': '15 mins',
      'fee': '₵35',
      'rating': '4.7',
      'price': '₵35'
    },
  ];

  final List<Map<String, dynamic>> _restaurants = [
    {
      'img': 'assets/images/home/restaurant_nana.jpg',
      'name': 'Nana Konadu Joint  - Regular',
      'cat': 'Local food',
      'time': '30mins',
      'fee': '₵15 Delivery',
      'rating': '4.7',
      'price': '₵35'
    },
    {
      'img': 'assets/images/home/restaurant_bigimage.jpg',
      'name': 'Big Image Paradise Restaurant',
      'cat': 'Local foods',
      'time': '15 mins',
      'fee': 'Free Delivery',
      'rating': '4.7',
      'price': '₵35'
    },
  ];

  final List<Map<String, dynamic>> _streetFood = [
    {
      'img': 'assets/images/home/street_abaawa.jpg',
      'name': 'Abaawa Kebab',
      'rating': '4.8',
      'reviews': '150 reviews',
      'price': '₵24.0'
    },
    {
      'img': 'assets/images/home/street_areamama.jpg',
      'name': 'Area Mama Speci',
      'rating': '4.8',
      'reviews': '150 reviews',
      'price': '₵24.0'
    },
  ];

  final List<Map<String, dynamic>> _allVendors = [
    {
      'img': 'assets/images/home/restaurant_nana.jpg',
      'name': 'Nana Konadu Joint - Regular',
      'cat': 'Local Foods',
      'time': '30 mins',
      'fee': '₵15 Delivery',
      'rating': '4.7',
      'reviews': '200+',
      'distance': '1.2 km'
    },
    {
      'img': 'assets/images/home/restaurant_bigimage.jpg',
      'name': 'Big Image Paradise Restaurant',
      'cat': 'Restaurants',
      'time': '15 mins',
      'fee': 'Free Delivery',
      'rating': '4.7',
      'reviews': '120+',
      'distance': '2.5 km'
    },
    {
      'img': 'assets/images/home/story_papaye.jpg',
      'name': 'Papaye Fast Food',
      'cat': 'Restaurants',
      'time': '20 mins',
      'fee': '₵10 Delivery',
      'rating': '4.5',
      'reviews': '1k+',
      'distance': '3.0 km'
    },
    {
      'img': 'assets/images/home/story_breakfo.jpg',
      'name': 'Breakfo Bakery',
      'cat': 'Pastries & Backery',
      'time': '40 mins',
      'fee': '₵12 Delivery',
      'rating': '4.9',
      'reviews': '50+',
      'distance': '4.1 km'
    },
  ];

  static const _serviceGrid = [
    {'name': 'Food', 'type': ServiceType.food},
    {'name': 'Groceries', 'type': ServiceType.groceries},
    {'name': 'Market', 'type': ServiceType.market},
    {'name': 'Shop', 'type': ServiceType.shop},
    {'name': 'Pharmacy', 'type': ServiceType.pharmacy},
    {'name': 'Laundry', 'type': ServiceType.laundry},
    {'name': 'Parcel', 'type': ServiceType.parcel},
    {'name': 'Errand', 'type': ServiceType.errand},
  ];

  final List<String> _filterTabs = [
    'All',
    'Restaurants',
    'Local Foods',
    'Pastries & Backery',
    'Soup & Stews'
  ];

  // Food items shown below vendor list (FoodKing style)
  final List<Map<String, dynamic>> _popularFoodItems = [
    {
      'img': 'assets/images/home/promo_fufu.jpg',
      'name': 'Fufu & Light Soup',
      'price': 'GH₵ 55.00',
      'restaurant': 'Nana\'s Kitchen',
      'rating': '4.9',
    },
    {
      'img': 'assets/images/home/street_abaawa.jpg',
      'name': 'Abaawa Special Kebab',
      'price': 'GH₵ 24.00',
      'restaurant': 'Abaawa Chop Bar',
      'rating': '4.8',
    },
    {
      'img': 'assets/images/home/street_areamama.jpg',
      'name': 'Waakye & Salad',
      'price': 'GH₵ 30.00',
      'restaurant': 'Area Mama',
      'rating': '4.7',
    },
    {
      'img': 'assets/images/home/restaurant_nana.jpg',
      'name': 'Jollof & Chicken',
      'price': 'GH₵ 45.00',
      'restaurant': 'Nana Konadu Joint',
      'rating': '4.8',
    },
  ];

  void _onAddressTap() async {
    final result = await Navigator.of(context).push<Address>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LocationSearchScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Match Material Design's search delegate animation
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.fastOutSlowIn;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
    if (result != null && mounted) {
      setState(() => _locationName = result.displayLabel);
    }
  }

  void _onServiceTap(ServiceType serviceType) {
    if (serviceType == ServiceType.food ||
        serviceType == ServiceType.groceries ||
        serviceType == ServiceType.market ||
        serviceType == ServiceType.shop ||
        serviceType == ServiceType.pharmacy ||
        serviceType == ServiceType.laundry) {
      if (_selectedServiceType == serviceType) return;

      setState(() {
        _isLoading = true;
        _selectedServiceType = serviceType;
        _selectedTab = 0;
        _marketMode = 'browse'; // reset market mode on service switch
      });

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) setState(() => _isLoading = false);
      });
      return;
    }

    switch (serviceType) {
      case ServiceType.food:
      case ServiceType.groceries:
        break;
      case ServiceType.market:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const MarketScreen()));
        break;
      case ServiceType.shop:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    const VendorListScreen(serviceType: ServiceType.shop)));
        break;
      case ServiceType.pharmacy:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    const VendorListScreen(serviceType: ServiceType.pharmacy)));
        break;
      case ServiceType.laundry:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const LaundryVendorsScreen()));
        break;
      case ServiceType.parcel:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ParcelSelectionScreen()));
        break;
      case ServiceType.errand:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ErrandSelectionScreen()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeOrder = ref.watch(activeOrderProvider);
    final cartItems = ref.watch(foodCartProvider);
    final hasActiveOrder = activeOrder != null;
    final cartCount = cartItems.length;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true, // This allows the background to show through the notch cut-out
      floatingActionButton: _buildCartFab(cartCount),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildFoodKingBottomNav(),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedNav == 4 ? 2 : (_selectedNav == 3 ? 1 : 0),
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildHeader(),
                        _buildServiceTabs(),
                        const SizedBox(height: 23),
                        if (_isLoading)
                          _buildSkeletonContent()
                        else ...[
                          // Market Shopping List CTA (shown when market selected)
                          if (_selectedServiceType == ServiceType.market)
                            _buildMarketShoppingListCta(),
                          _buildStories(),
                          const SizedBox(height: 28),
                          _buildPromoCards(),
                          const SizedBox(height: 40),
                          _buildFilterTabs(),
                          const SizedBox(height: 16),
                          _buildPopularRestaurantsHeader(),
                          const SizedBox(height: 16),
                          _buildPopularRestaurants(),
                          const SizedBox(height: 40),
                          _buildFeaturedStreetFoodHeader(),
                          const SizedBox(height: 16),
                          _buildFeaturedStreetFood(),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _selectedServiceType == ServiceType.groceries
                                    ? 'All Grocery Stores around you'
                                    : _selectedServiceType == ServiceType.pharmacy
                                        ? 'Nearby Pharmacies'
                                        : 'All Restaurants around you',
                                style: AppFonts.inter(
                                  color: const Color(0xFF1B1B1B),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                  if (_isLoading)
                    _buildSkeletonSliverFeed()
                  else
                    _buildVerticalVendorFeed(),
                  // FoodKing-style food items grid below vendor list
                  if (!_isLoading)
                    SliverToBoxAdapter(child: _buildFoodItemsSection()),
                  SliverToBoxAdapter(
                    child: SizedBox(height: hasActiveOrder ? 180 : 100),
                  ),
                ],
              ),
              const OrdersScreen(),
              const ProfileScreen(),
            ],
          ),
          // FoodKing active order overlay at bottom
          if (hasActiveOrder)
            _buildActiveOrderBanner(activeOrder),
        ],
      ),
    );
  }

  // ── Market Shopping List CTA ───────────────────────────────────────────────
  Widget _buildMarketShoppingListCta() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MarketShoppingListScreen()),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF15803D), Color(0xFF22C55E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF16A34A).withOpacity(0.3),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.shopping_basket_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Can\'t find your vendor?',
                      style: AppFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Create a shopping list — a rider will shop for you at any market',
                      style: AppFonts.inter(
                          fontSize: 12, color: Colors.white.withOpacity(0.85)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildVerticalVendorFeed() {
    final activeTabList = _selectedServiceType == ServiceType.groceries
        ? _groceryFilterTabs
        : _selectedServiceType == ServiceType.market
            ? _marketFilterTabs
            : _selectedServiceType == ServiceType.shop
                ? _shopFilterTabs
                : _selectedServiceType == ServiceType.pharmacy
                    ? _pharmacyFilterTabs
                    : _filterTabs;
    final vendorsList = _selectedServiceType == ServiceType.groceries
        ? _allGroceryVendors
        : _selectedServiceType == ServiceType.market
            ? _allMarketVendors
            : _selectedServiceType == ServiceType.shop
                ? _allShopVendors
                : _selectedServiceType == ServiceType.pharmacy
                    ? _allPharmacyVendors
                    : _allVendors;

    // Safety check just in case tabs get mismatched during hot reload
    final String activeTab = _selectedTab < activeTabList.length ? activeTabList[_selectedTab] : activeTabList[0];

    final filteredVendors = activeTab == 'All'
        ? vendorsList
        : vendorsList.where((v) => v['cat'] == activeTab).toList();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final vendor = filteredVendors[index];
            return _buildVerticalVendorCard(vendor);
          },
          childCount: filteredVendors.length,
        ),
      ),
    );
  }

  Widget _buildVerticalVendorCard(Map<String, dynamic> vendor) {
    final isFavourite = _favouriteRestaurants.contains(vendor['name']);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantScreen(restaurantData: vendor),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    vendor['img']!,
                    width: double.infinity,
                    height: 176,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 176,
                        color: Colors.grey[200],
                        child: Icon(LucideIcons.utensils, size: 40, color: Colors.grey[400]),
                      );
                    },
                  ),
                ),
                // Store Closed overlay for Konadu OTC Store
                if (_selectedServiceType == ServiceType.pharmacy && vendor['name'] == 'Konadu OTC Store  - Regular')
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: Center(
                        child: Text(
                          'Store Closed',
                          style: AppFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isFavourite) {
                          _favouriteRestaurants.remove(vendor['name']);
                        } else {
                          _favouriteRestaurants.add(vendor['name']!);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        LucideIcons.heart,
                        size: 16,
                        color: isFavourite ? Colors.red : Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    vendor['name']!,
                    style: AppFonts.inter(
                      color: const Color(0xFF1E1E1E),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        vendor['cat']!,
                        style: AppFonts.inter(
                          color: const Color(0xFF838383),
                          fontSize: 10,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.star, size: 12, color: const Color(0xFFFFB135)),
                          const SizedBox(width: 4),
                          Text(
                            vendor['rating']!,
                            style: AppFonts.inter(
                              color: const Color(0xFF838383),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vendor['fee']!,
                        style: AppFonts.inter(
                          color: const Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7CA09),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          vendor['time']!,
                          style: AppFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonContent() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stories skeleton
          SizedBox(
            height: 84.5,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, _) => Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Column(
                  children: [
                    Container(width: 64, height: 64, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                    const SizedBox(height: 4),
                    Container(width: 50, height: 10, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          // Promos skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(width: double.infinity, height: 179, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(23))),
          ),
          const SizedBox(height: 40),
          // Filters skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: List.generate(4, (index) => Container(width: 60, height: 20, margin: const EdgeInsets.only(right: 24), color: Colors.white)),
            ),
          ),
          const SizedBox(height: 16),
          // Popular Header skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 150, height: 20, color: Colors.white),
                Container(width: 50, height: 15, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Popular list skeleton
          SizedBox(
            height: 257,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 19),
              itemCount: 2,
              itemBuilder: (context, _) => Container(width: 182, margin: const EdgeInsets.only(right: 24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSkeletonSliverFeed() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              height: 220,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            ),
          ),
          childCount: 3,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final topPad = MediaQuery.paddingOf(context).top;
    const searchBarHeight = 52.0;
    const searchTopBelowSafeArea = 168.0; // Figma y=212 minus 44px status bar
    const gapBelowSearchToTabs = 19.0;
    final heroHeight = topPad + searchTopBelowSafeArea + searchBarHeight / 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: heroHeight,
              width: double.infinity,
              child: ClipRect(
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned.fill(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            _selectedServiceType == ServiceType.groceries
                                ? 'assets/images/figma_groceries/hero_background.png'
                                : _selectedServiceType == ServiceType.pharmacy
                                    ? 'assets/images/figma_pharmacy/pharmacy_bg_main.jpg'
                                : _selectedServiceType == ServiceType.market
                                    ? 'assets/images/home/story_kfc.jpg'
                                    : _selectedServiceType == ServiceType.shop
                                        ? 'assets/images/home/restaurant_bigimage.jpg'
                                        : 'assets/images/home/hero_background.jpg',
                            fit: BoxFit.cover,
                            alignment: const Alignment(0, -0.004),
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: const Color(0xFF0068FF));
                            },
                          ),
                          // Pills overlay for pharmacy
                          if (_selectedServiceType == ServiceType.pharmacy)
                            Positioned(
                              right: 60,
                              top: 80,
                              child: Image.asset(
                                'assets/images/figma_pharmacy/pharmacy_pills_overlay.jpg',
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                              ),
                            ),
                          Container(
                            color: Colors.black.withValues(alpha: 0.2),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -14,
                      left: 0,
                      right: 0,
                      height: 253,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.42),
                              Colors.black.withValues(alpha: 0.12),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -63,
                      top: -73,
                      width: 146,
                      height: 146,
                      child: Image.asset(
                        'assets/images/home/hero_ellipse.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    SafeArea(
                      bottom: false,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8,
                            left: 24,
                            child: GestureDetector(
                              onTap: _onAddressTap,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Your Location',
                                        style: AppFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          height: 20 / 14,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        LucideIcons.chevronDown,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    children: [
                                      const Icon(
                                        LucideIcons.mapPin,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _locationName,
                                        style: AppFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          height: 20 / 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 15,
                            right: 24,
                            child: Row(
                              children: [
                                _buildHeaderIconButton(LucideIcons.search, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const SearchScreen()),
                                  );
                                }),
                                const SizedBox(width: 14),
                                // Bell with unread badge
                                Builder(builder: (ctx) {
                                  final unread = ref.watch(notificationUnreadCountProvider);
                                  return GestureDetector(
                                    onTap: () {
                                      ref.read(notificationsProvider.notifier).markAllRead();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const NotificationsScreen()),
                                      );
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        _buildHeaderIconButton(LucideIcons.bell, null),
                                        if (unread > 0)
                                          Positioned(
                                            top: -4,
                                            right: -4,
                                            child: Container(
                                              width: 18,
                                              height: 18,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFEF4444),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  unread > 9 ? '9+' : '$unread',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 69,
                            left: 24,
                            right: 24,
                            child: RichText(
                              text: TextSpan(
                                style: AppFonts.inter(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -2,
                                  height: 40 / 32,
                                ),
                                children: [
                                  TextSpan(
                                    text: _selectedServiceType == ServiceType.groceries
                                        ? 'Out of something?\n'
                                        : _selectedServiceType == ServiceType.market
                                            ? 'Need to shop?\n'
                                            : _selectedServiceType == ServiceType.shop
                                                ? 'Need to dress up?\n'
                                                : _selectedServiceType == ServiceType.pharmacy
                                                    ? 'Not feeling well?\n'
                                                    : 'Ready to eat?\n',
                                  ),
                                  TextSpan(
                                    text: _selectedServiceType == ServiceType.groceries
                                        ? 'Let\u2019s restock '
                                        : _selectedServiceType == ServiceType.market
                                            ? 'Let\u2019s find '
                                            : _selectedServiceType == ServiceType.shop
                                                ? 'Let\u2019s find '
                                                : _selectedServiceType == ServiceType.pharmacy
                                                    ? 'Let\u2019s get '
                                                    : 'Let\u2019s find ',
                                    style: TextStyle(
                                      color: _selectedServiceType == ServiceType.pharmacy
                                          ? const Color(0xFF22C55E)
                                          : const Color(0xFFFACC15),
                                    ),
                                  ),
                                  TextSpan(
                                    text: _selectedServiceType == ServiceType.groceries
                                        ? 'your kitchen'
                                        : _selectedServiceType == ServiceType.market
                                            ? 'your market'
                                            : _selectedServiceType == ServiceType.shop
                                                ? 'an outfit'
                                                : _selectedServiceType == ServiceType.pharmacy
                                                    ? 'your meds'
                                                    : 'you something',
                                    style: TextStyle(
                                      color: _selectedServiceType == ServiceType.pharmacy
                                          ? const Color(0xFF22C55E)
                                          : const Color(0xFFFFC700),
                                    ),
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
            Positioned(
              left: 22,
              right: 22,
              top: topPad + searchTopBelowSafeArea,
              child: _buildSearchBar(),
            ),
          ],
        ),
        SizedBox(height: searchBarHeight / 2 + gapBelowSearchToTabs),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchView()),
        );
      },
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFDDDDDD),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(
              LucideIcons.search,
              color: Color(0xFF878787),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _selectedServiceType == ServiceType.groceries
                    ? 'Search for Eggs. . .'
                    : _selectedServiceType == ServiceType.market
                        ? 'Search the Market. . .'
                        : _selectedServiceType == ServiceType.shop
                            ? 'Search for Clothes. . .'
                            : _selectedServiceType == ServiceType.pharmacy
                                ? 'Search for meds. . .'
                                : 'Search for Food. . .',
                style: AppFonts.inter(
                  color: const Color(0xFF878787),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                ),
              ),
            ),
            const Icon(
              LucideIcons.slidersHorizontal,
              color: Color(0xFF878787),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIconButton(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildServiceTabs() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _serviceGrid.length,
        itemBuilder: (context, i) {
          final svc = _serviceGrid[i];
          final serviceType = svc['type'] as ServiceType;
          final isSelected = serviceType == _selectedServiceType;
          return AnimatedPress(
            onTap: () => _onServiceTap(serviceType),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xC21463FF)
                    : const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(9999),
                border: isSelected
                    ? null
                    : Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: Text(
                svc['name'] as String,
                style: AppFonts.inter(
                  color:
                      isSelected ? Colors.white : const Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w400 : FontWeight.w500,
                  height: 1.43,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStories() {
    final vendorStoriesNotifier = ref.read(vendorStoriesProvider.notifier);
    final stories = vendorStoriesNotifier.getStoriesForService(_selectedServiceType);

    // Filter stories that have active posts (within 24 hours)
    final activeStories = stories.where((story) => story.hasActivePosts).toList();

    return SizedBox(
      height: 84.5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: activeStories.length + 1,
        itemBuilder: (context, i) {
          if (i == activeStories.length) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xFFE2E8F0), width: 2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(LucideIcons.ellipsis,
                          color: Color(0xFF94A3B8), size: 14),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'More',
                    style: AppFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            );
          }

          final story = activeStories[i];
          final isViewed = story.isViewed;

          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                // Mark story as viewed
                ref.read(vendorStoriesProvider.notifier).markStoryAsViewed(story.vendorId);
                
                // Navigate to vendor story screen with all stories
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VendorStoryScreen(
                      allVendorStories: activeStories,
                      initialVendorIndex: i,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isViewed
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF0052CC),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        story.vendorImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(LucideIcons.utensils,
                                color: Colors.grey[600]),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    story.vendorName,
                    style: AppFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF0F172A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoCards() {
    if (_selectedServiceType == ServiceType.pharmacy) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF22C55E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Have a prescription?',
                      style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Upload Now', style: AppFonts.inter(color: const Color(0xFF22C55E), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(color: const Color(0xFF4ADE80), borderRadius: BorderRadius.circular(12)),
                child: const Icon(LucideIcons.plus, color: Colors.white, size: 32),
              ),
            ],
          ),
        ),
      );
    }

    final promos = _selectedServiceType == ServiceType.groceries
      ? [
          {
            'image': 'assets/images/figma_groceries/promo_lettuce.png',
            'title': 'Free',
            'titleHighlight': 'Lettuce',
            'subtitle': 'For new carts',
            'badgeText': 'Papaye',
            'badgeColor': const Color(0xFF04D752),
            'badgeTextColor': Colors.white,
          },
          {
            'image': 'assets/images/home/promo_delivery.jpg',
            'title': '20%',
            'titleHighlight': 'Eggs',
            'subtitle': 'per',
            'badgeText': 'New Users',
            'badgeColor': Colors.white.withOpacity(0.8),
            'badgeTextColor': const Color(0xFF192126),
          },
        ]
      : _selectedServiceType == ServiceType.market
      ? [
          {
            'image': 'assets/images/home/promo_fufu.jpg',
            'title': '20%',
            'titleHighlight': 'Off Today',
            'subtitle': 'Kejetia Deals',
            'badgeText': 'Kejetia Market',
            'badgeColor': const Color(0xFFFF6B00),
            'badgeTextColor': Colors.white,
          },
          {
            'image': 'assets/images/home/promo_delivery.jpg',
            'title': 'Free',
            'titleHighlight': 'Delivery',
            'subtitle': '',
            'badgeText': 'New Shoppers',
            'badgeColor': Colors.white.withOpacity(0.8),
            'badgeTextColor': const Color(0xFF192126),
          },
        ]
      : _selectedServiceType == ServiceType.shop
      ? [
          {
            'image': 'assets/images/home/promo_fufu.jpg',
            'title': '15%',
            'titleHighlight': 'Discount',
            'subtitle': 'Designer Clothes',
            'badgeText': 'Accra Mall',
            'badgeColor': const Color(0xFF04D752),
            'badgeTextColor': Colors.white,
          },
        ]
      : [
          {
            'image': 'assets/images/home/promo_fufu.jpg',
            'title': '30%',
            'titleHighlight': 'Discount',
            'subtitle': 'Sunday Fufu',
            'badgeText': 'Papaye',
            'badgeColor': const Color(0xFF04D752),
            'badgeTextColor': Colors.white,
          },
          {
            'image': 'assets/images/home/promo_delivery.jpg',
            'title': 'Free',
            'titleHighlight': 'Delivery',
            'subtitle': '',
            'badgeText': 'New Users',
            'badgeColor': Colors.white.withOpacity(0.8),
            'badgeTextColor': const Color(0xFF192126),
          },
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 179,
          child: PageView.builder(
            controller: _promoController,
            itemCount: promos.length,
            onPageChanged: (i) => setState(() => _promoIndex = i),
            itemBuilder: (context, i) {
              final p = promos[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _buildPromoCard(
                  image: p['image'] as String,
                  title: p['title'] as String,
                  titleHighlight: p['titleHighlight'] as String,
                  subtitle: p['subtitle'] as String,
                  badgeText: p['badgeText'] as String,
                  badgeColor: p['badgeColor'] as Color,
                  badgeTextColor: p['badgeTextColor'] as Color,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: List.generate(promos.length, (i) {
              final isActive = i == _promoIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: isActive ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFF97316) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard({
    required String image,
    required String title,
    required String titleHighlight,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    Color badgeTextColor = Colors.white,
  }) {
    return Container(
      width: 288,
      height: 179,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.grey[800]);
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x82000000),
                    Color(0x00000000),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppFonts.inter(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(text: '$title '),
                      TextSpan(
                        text: titleHighlight,
                        style: const TextStyle(color: Color(0xFFFACC15)),
                      ),
                    ],
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: AppFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    badgeText,
                    style: AppFonts.inter(
                      color: badgeTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final tabsList = _selectedServiceType == ServiceType.groceries
        ? _groceryFilterTabs
        : _selectedServiceType == ServiceType.market
            ? _marketFilterTabs
            : _selectedServiceType == ServiceType.shop
                ? _shopFilterTabs
                : _filterTabs;
    return SizedBox(
      height: 26,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: tabsList.length,
        itemBuilder: (context, i) {
          final isActive = i == _selectedTab;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Column(
                children: [
                  Text(
                    tabsList[i],
                    style: AppFonts.inter(
                      fontSize: 12,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? Colors.black
                          : const Color(0x80000000),
                    ),
                  ),
                  if (isActive)
                    Container(
                      height: 2,
                      width: 14,
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularRestaurantsHeader() {
    final title = _selectedServiceType == ServiceType.groceries
        ? 'Top Grocery Stores'
        : _selectedServiceType == ServiceType.market
            ? 'Popular Market Stalls'
            : _selectedServiceType == ServiceType.shop
                ? 'Popular Shops'
                : _selectedServiceType == ServiceType.pharmacy
                    ? 'Health Needs?'
                    : 'Popular Restaurants';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppFonts.inter(
              color: const Color(0xFF1B1B1B),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const VendorListScreen(serviceType: ServiceType.food)));
            },
            child: Text(
              'See all',
              style: AppFonts.inter(
                color: const Color(0xFF838383),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularRestaurants() {
    if (_selectedServiceType == ServiceType.pharmacy) {
      final needs = [
        {'icon': '💊', 'label': 'Pain Relief'},
        {'icon': '🤧', 'label': 'Cold & Flu'},
        {'icon': '🩹', 'label': 'First Aid'},
        {'icon': '🧴', 'label': 'Skin Care'},
        {'icon': '👶', 'label': 'Baby Health'},
        {'icon': '🍏', 'label': 'Vitamins'},
      ];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        child: Wrap(
          spacing: 12, runSpacing: 12,
          children: needs.map((n) {
            return Container(
              width: (MediaQuery.of(context).size.width - 38 - 24) / 3,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Text(n['icon']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 8),
                  Text(n['label']!, style: AppFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1B1B1B)), textAlign: TextAlign.center),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }

    final list = _selectedServiceType == ServiceType.groceries
        ? _allGroceryVendors
        : _selectedServiceType == ServiceType.market
            ? _popularMarketStores
            : _selectedServiceType == ServiceType.shop
                ? _popularShopStores
                : _restaurants;
    return SizedBox(
      height: 257,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 19),
        itemCount: list.length,
        itemBuilder: (context, i) {
          final restaurant = list[i];
          final isFavourite =
              _favouriteRestaurants.contains(restaurant['name']);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      RestaurantScreen(restaurantData: restaurant),
                ),
              );
            },
            child: Container(
              width: 182,
              margin: const EdgeInsets.only(right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          restaurant['img']!,
                          width: 182,
                          height: 176,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 182,
                              height: 176,
                              color: Colors.grey[300],
                              child: Icon(LucideIcons.utensils,
                                  size: 50, color: Colors.grey[600]),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isFavourite) {
                                _favouriteRestaurants
                                    .remove(restaurant['name']);
                              } else {
                                _favouriteRestaurants
                                    .add(restaurant['name']!);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              LucideIcons.heart,
                              size: 16,
                              color: isFavourite
                                  ? Colors.red
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    restaurant['name']!,
                    style: AppFonts.inter(
                      color: const Color(0xFF1E1E1E),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurant['cat']!,
                        style: AppFonts.inter(
                          color: const Color(0xFF838383),
                          fontSize: 10,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(LucideIcons.star,
                              color: Color(0xFFFACC15), size: 12),
                          const SizedBox(width: 4),
                          Text(
                            restaurant['rating']!,
                            style: AppFonts.inter(
                              color: const Color(0xFF838383),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurant['price']!,
                        style: AppFonts.inter(
                          color: const Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7CA09),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          restaurant['time']!,
                          style: AppFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedStreetFoodHeader() {
    if (_selectedServiceType == ServiceType.pharmacy) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Health Needs?',
              style: AppFonts.inter(
                color: const Color(0xFF1B1B1B),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'See all',
              style: AppFonts.inter(
                color: const Color(0xFF838383),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    final title = _selectedServiceType == ServiceType.groceries
        ? 'Featured Stores'
        : _selectedServiceType == ServiceType.market
            ? 'Featured Market Picks'
            : _selectedServiceType == ServiceType.shop
                ? 'Featured Boutiques'
                : 'Featured Street food';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppFonts.inter(
              color: const Color(0xFF1B1B1B),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const VendorListScreen(serviceType: ServiceType.food)));
            },
            child: Text(
              'See All',
              style: AppFonts.inter(
                color: const Color(0xFF838383),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedStreetFood() {
    if (_selectedServiceType == ServiceType.pharmacy) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
          children: [
            _buildHealthNeedItem('💊', 'Pain Relief'),
            _buildHealthNeedItem('🤧', 'Cold & Flu'),
            _buildHealthNeedItem('🩹', 'First Aid'),
            _buildHealthNeedItem('🧴', 'Skin Care'),
            _buildHealthNeedItem('👶', 'Baby Health'),
            _buildHealthNeedItem('🍏', 'Vitamins'),
          ],
        ),
      );
    }

    final list = _selectedServiceType == ServiceType.groceries
        ? _featuredGroceryStores
        : _selectedServiceType == ServiceType.market
            ? _featuredMarketStores
            : _selectedServiceType == ServiceType.shop
                ? _featuredShopStores
                : _streetFood;
    return SizedBox(
      height: 205,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: list.length,
        itemBuilder: (context, i) {
          final food = list[i];
          return Container(
            width: 285,
            margin: const EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        food['img']!,
                        width: 285,
                        height: 154,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 285,
                            height: 154,
                            color: Colors.grey[300],
                            child: Icon(LucideIcons.utensilsCrossed,
                                size: 50, color: Colors.grey[600]),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 13,
                      right: 13,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_favouriteRestaurants.contains(food['name'])) {
                              _favouriteRestaurants.remove(food['name']);
                            } else {
                              _favouriteRestaurants.add(food['name']!);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            LucideIcons.heart,
                            size: 16,
                            color: _favouriteRestaurants.contains(food['name'])
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food['name']!,
                            style: AppFonts.inter(
                              color: const Color(0xFF202226),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(LucideIcons.star,
                                  color: Color(0xFFFACC15), size: 16),
                              const SizedBox(width: 4),
                              Text(
                                food['rating']!,
                                style: AppFonts.inter(
                                  color: const Color(0xFF212121),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${food['reviews']})',
                                style: AppFonts.inter(
                                  color: const Color(0xFFB3B3B3),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      food['price']!,
                      style: AppFonts.inter(
                        color: const Color(0xFF010E16),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── FoodKing BottomNavItem faithful port ──────────────────────────────
  Widget _buildFoodKingBottomNav() {
    int currentIndex = 0;
    if (_selectedNav == 0) currentIndex = 0;
    if (_selectedNav == 3) currentIndex = 1;
    if (_selectedNav == 2) currentIndex = 2;
    if (_selectedNav == 4) currentIndex = 3;

    // Use brand primary color instead of pink
    const Color fkPrimary = AppTheme.primary;

    return BottomAppBar(
      elevation: 25,
      shadowColor: Colors.black, // Darker shadow to make it visible
      surfaceTintColor: Colors.white, 
      notchMargin: 5,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: const CircularNotchedRectangle(),
      child: Row(
        children: [
          _fkNavItem('Home', const AssetImage('assets/icons/fk_home.png'), 0, currentIndex, fkPrimary),
          _fkNavItem('Orders', const AssetImage('assets/icons/fk_menu.png'), 1, currentIndex, fkPrimary),
          // Space for FAB notch
          const Expanded(child: SizedBox()),
          _fkNavItem('Analytics', const AssetImage('assets/icons/fk_offer.png'), 2, currentIndex, fkPrimary),
          _fkNavItem('Account', const AssetImage('assets/icons/fk_profile.png'), 3, currentIndex, fkPrimary),
        ],
      ),
    );
  }

  // Exact port of FoodKing's BottomNavItem widget
  Widget _fkNavItem(String title, AssetImage imageData, int index, int currentIndex, Color primaryColor) {
    final bool isSelected = currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            if (index == 0) _selectedNav = 0;
            if (index == 1) _selectedNav = 3;
            if (index == 2) _selectedNav = 2;
            if (index == 3) _selectedNav = 4;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                imageData,
                color: isSelected
                    ? primaryColor
                    : Theme.of(context).disabledColor.withOpacity(0.8),
                size: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 2),
                child: Text(
                  title,
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ).copyWith(
                    color: isSelected ? primaryColor : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Cart FAB (FoodKing style) ─────────────────────────────────────────
  Widget _buildCartFab(int cartCount) {
    // Use brand primary color instead of pink
    const Color fkPrimary = AppTheme.primary;
    
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {
          final cartNotifier = ref.read(foodCartProvider.notifier);
          final cartItems = ref.read(foodCartProvider);
          if (cartItems.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Your cart is empty', style: AppFonts.inter(color: Colors.white))),
            );
            return;
          }
          final subtotal = cartItems.fold(0.0, (sum, item) => sum + item.lineTotal);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckoutScreen(
                serviceType: ServiceType.food,
                cartItems: cartItems,
                subtotal: subtotal,
                totalItems: cartItems.length,
                vendorName: cartNotifier.currentVendorName,
                onPlaceOrder: () {
                  ref.read(foodCartProvider.notifier).clearCart();
                },
              ),
            ),
          );
        },
        child: Stack(
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundColor: fkPrimary,
                child: const ImageIcon(
                  AssetImage('assets/icons/fk_cart.png'),
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            if (cartCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: SizedBox(
                  child: const ImageIcon(
                    AssetImage('assets/icons/fk_cart_has_item.png'),
                    color: Colors.yellow,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Active Order Banner (FoodKing style) ─────────────────────────────
  Widget _buildActiveOrderBanner(ActiveOrder order) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderTrackingScreen(
                serviceType: order.serviceType,
                orderId: order.orderId,
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFF5722).withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            border: Border(
              top: BorderSide(
                color: const Color(0xFFFF5722).withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5722).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.bike, color: Color(0xFFFF5722), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.statusMessage,
                      style: AppFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFF5722),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${order.vendorName}  •  ETA: ${order.eta}',
                      style: AppFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: Color(0xFFFF5722), size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // ── FoodKing-style Food Items Grid Section ───────────────────────────
  Widget _buildFoodItemsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Food Items',
                style: AppFonts.inter(
                  color: const Color(0xFF1B1B1B),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchView()));
                },
                child: Text(
                  'See all',
                  style: AppFonts.inter(
                    color: const Color(0xFFFF5722),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _popularFoodItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 14,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              return _buildFoodItemCard(_popularFoodItems[index]);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFoodItemCard(Map<String, dynamic> item) {
    // FoodKing style with brand colors
    const Color fkItemBg = Color(0xffEFF0F6);
    const Color fkPrimary = AppTheme.primary; // Use brand primary instead of pink
    const Color fkGray = Color(0xff6E7191);
    const Color fkFontColor = Color(0xff1F1F39);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FoodDetailScreen(
              title: item['name'],
              description: item['description'],
              price: double.parse(item['price'].replaceAll(RegExp(r'[^0-9.]'), '')),
              imageUrl: item['img'],
              restaurantId: 'rest_123',
              restaurantName: item['restaurant'],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: fkItemBg),
        ),
        child: Column(
          children: [
            // Image top
            SizedBox(
              height: 110,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  item['img'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[400]!,
                    child: Container(color: Colors.grey),
                  ),
                ),
              ),
            ),
            // Content below image
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 6, bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                item['name'],
                                style: AppFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: fkFontColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['restaurant'],
                          textAlign: TextAlign.left,
                          style: AppFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: fkGray,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Price + ADD button row
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['price'],
                          style: AppFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        // ADD button — FoodKing style
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: fkItemBg,
                                offset: Offset(0.0, 4.0),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                color: fkItemBg,
                                offset: Offset(1.0, 0.0),
                                blurRadius: 1,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                LucideIcons.shoppingCart,
                                size: 12,
                                color: fkPrimary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'ADD',
                                style: AppFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: fkPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthNeedItem(String emoji, String title) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppFonts.inter(
              color: const Color(0xFF1A1A2E),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
