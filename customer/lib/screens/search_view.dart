// Faithful port of FoodKing's search_view.dart
// GetX -> StatefulWidget, flutter_screenutil -> native sizing,
// get_storage -> local state, network images -> local assets
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swiftree/core/theme/app_fonts.dart';

// FoodKing colour tokens
const Color _fkPrimary = Color(0xffFF006B);
const Color _fkItemBg = Color(0xffEFF0F6);
const Color _fkGray = Color(0xff6E7191);
const Color _fkFontColor = Color(0xff1F1F39);

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  // 0 = list view, 1 = grid view  (mirrors FoodKing's get_storage 'viewValue')
  int _viewValue = 0;

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allItems = [
    {
      'name': 'Fufu & Light Soup',
      'description': 'Rich, hearty Nigeriaian fufu served with fresh light soup and goat meat.',
      'price': 'GH₵ 55.00',
      'restaurant': "Nana's Kitchen",
      'img': 'assets/images/home/promo_fufu.jpg',
    },
    {
      'name': 'Abaawa Special Kebab',
      'description': 'Succulent grilled kebab skewers marinated in a spicy Nigeriaian blend.',
      'price': 'GH₵ 24.00',
      'restaurant': 'Abaawa Chop Bar',
      'img': 'assets/images/home/street_abaawa.jpg',
    },
    {
      'name': 'Waakye & Salad',
      'description': 'Classic Nigeriaian waakye (rice & beans) served with fresh vegetable salad.',
      'price': 'GH₵ 30.00',
      'restaurant': 'Area Mama',
      'img': 'assets/images/home/street_areamama.jpg',
    },
    {
      'name': 'Jollof Rice & Chicken',
      'description': 'Smoky, well-seasoned Nigeriaian jollof rice served with grilled chicken.',
      'price': 'GH₵ 45.00',
      'restaurant': 'Nana Konadu Joint',
      'img': 'assets/images/home/restaurant_nana.jpg',
    },
    {
      'name': 'Banku & Tilapia',
      'description': 'Fermented corn dough served with grilled whole tilapia and pepper sauce.',
      'price': 'GH₵ 65.00',
      'restaurant': 'Big Image Paradise',
      'img': 'assets/images/home/restaurant_bigimage.jpg',
    },
    {
      'name': 'Papaye Combo',
      'description': 'Fried rice with chicken and coleslaw — Papaye style.',
      'price': 'GH₵ 80.00',
      'restaurant': 'Papaye Fast Food',
      'img': 'assets/images/home/story_papaye.jpg',
    },
  ];

  List<Map<String, dynamic>> _foundItems = [];

  @override
  void initState() {
    super.initState();
    _foundItems = List.from(_allItems);
    _searchController.addListener(() {
      _filterItems(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() => _foundItems = List.from(_allItems));
      return;
    }
    setState(() {
      _foundItems = _allItems.where((item) {
        return item['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
            item['restaurant'].toString().toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: -5,
        title: Text(
          'Search',
          style: AppFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: _fkPrimary, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                // Search bar — direct port of FoodKing's search TextField
                SizedBox(
                  height: 52,
                  child: TextField(
                    showCursor: true,
                    readOnly: false,
                    controller: _searchController,
                    autofocus: true,
                    style: AppFonts.inter(fontSize: 14, color: _fkFontColor),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: _fkGray),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(14),
                        child: Icon(LucideIcons.search, color: _fkGray, size: 20),
                      ),
                      suffixIcon: _searchController.text.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.all(12),
                              child: InkWell(
                                onTap: () {
                                  _searchController.clear();
                                  _filterItems('');
                                },
                                child: const Icon(
                                  LucideIcons.circleX,
                                  color: _fkPrimary,
                                  size: 20,
                                ),
                              ),
                            ),
                      filled: true,
                      fillColor: _fkItemBg,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        borderSide: const BorderSide(color: _fkItemBg, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        borderSide: const BorderSide(width: 0, color: _fkItemBg),
                      ),
                    ),
                  ),
                ),
                _menuContent(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuContent(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        color: _fkPrimary,
        onRefresh: () async => _filterItems(''),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Count row + list/grid toggle — exact FoodKing layout
              SizedBox(
                height: 34,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_foundItems.length} ITEMS AVAILABLE',
                      style: AppFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: _fkPrimary,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                      width: 66,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => setState(() => _viewValue = 0),
                            child: Icon(
                              LucideIcons.list,
                              size: 20,
                              color: _viewValue == 0 ? _fkPrimary : _fkGray,
                            ),
                          ),
                          const SizedBox(width: 18),
                          InkWell(
                            onTap: () => setState(() => _viewValue = 1),
                            child: Icon(
                              LucideIcons.layoutGrid,
                              size: 20,
                              color: _viewValue == 1 ? _fkPrimary : _fkGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_foundItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 17),
                  child: _viewValue == 1 ? _buildGridView() : _buildListView(),
                )
              else
                _buildNoItems(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // Grid view — mirrors menuItemSectionGrid
  Widget _buildGridView() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _foundItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) => _buildItemCardGrid(index),
    );
  }

  // List view — mirrors menuItemSectionList
  Widget _buildListView() {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: _foundItems.length,
      itemBuilder: (context, index) => _buildItemCardList(index),
    );
  }

  // Grid card — faithful port of FoodKing's item_card_grid.dart
  Widget _buildItemCardGrid(int index) {
    final item = _foundItems[index];
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: _fkItemBg),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 90,
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: AppFonts.inter(fontWeight: FontWeight.w500, fontSize: 14, color: _fkFontColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['description'],
                          style: AppFonts.inter(fontWeight: FontWeight.w400, fontSize: 10, color: _fkGray),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['price'],
                          style: AppFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        _addButton(),
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

  // List card — faithful port of FoodKing's item_card_list.dart style
  Widget _buildItemCardList(int index) {
    final item = _foundItems[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _fkItemBg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item['img'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: _fkItemBg,
                child: const Icon(Icons.fastfood_outlined, color: _fkGray),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: AppFonts.inter(fontWeight: FontWeight.w500, fontSize: 14, color: _fkFontColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item['description'],
                  style: AppFonts.inter(fontWeight: FontWeight.w400, fontSize: 11, color: _fkGray),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['price'],
                      style: AppFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    _addButton(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ADD button — exact FoodKing style with shadow
  Widget _addButton() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: _fkItemBg,
            offset: Offset(0.0, 4.0),
            blurRadius: 5,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: _fkItemBg,
            offset: Offset(1.0, 0.0),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.shoppingCart, size: 12, color: _fkPrimary),
          const SizedBox(width: 2),
          Text(
            'ADD',
            style: AppFonts.inter(fontWeight: FontWeight.w500, fontSize: 12, color: _fkPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildNoItems() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(LucideIcons.searchX, size: 48, color: _fkGray.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            'No items available',
            style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: _fkGray),
          ),
        ],
      ),
    );
  }
}
