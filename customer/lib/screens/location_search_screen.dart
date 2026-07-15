import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';
import 'package:swiftree/models/address.dart';
import 'package:swiftree/services/place_api_provider.dart';
import 'package:swiftree/models/place_models.dart';
import 'package:uuid/uuid.dart';

/// Full-screen location search with 3 tabs: Search, GhanaPostGPS, what3words
/// Adapted from Houzi's AddressSearch pattern with tabbed interface
class LocationSearchScreen extends StatefulWidget {
  final Address? initialAddress;

  const LocationSearchScreen({super.key, this.initialAddress});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _addressType;
  String _sessionToken = '';

  // Search tab
  final TextEditingController _searchController = TextEditingController();
  List<Suggestion> _suggestions = [];
  bool _isSearching = false;
  PlaceDetails? _selectedPlace;

  // GhanaPostGPS tab
  final TextEditingController _gpsController = TextEditingController();
  final _gpsFormKey = GlobalKey<FormState>();

  // what3words tab
  final TextEditingController _w3wController = TextEditingController();
  final _w3wFormKey = GlobalKey<FormState>();

  late PlaceApiProvider _placeApi;

  @override
  void initState() {
    super.initState();
    _sessionToken = const Uuid().v4();
    _placeApi = PlaceApiProvider(_sessionToken);
    _tabController = TabController(length: 3, vsync: this);
    _addressType = widget.initialAddress?.type ?? 'Home';

    // Pre-fill if editing
    if (widget.initialAddress != null) {
      _searchController.text = widget.initialAddress!.street;
      _gpsController.text = widget.initialAddress!.ghanaPost ?? '';
      _w3wController.text = widget.initialAddress!.what3words ?? '';
    }

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _gpsController.dispose();
    _w3wController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _suggestions = [];
        _selectedPlace = null;
      });
      return;
    }

    if (_searchController.text.length < 3) return;

    setState(() => _isSearching = true);

    _placeApi.fetchSuggestions(_searchController.text).then((suggestions) {
      if (mounted) {
        setState(() {
          _suggestions = suggestions;
          _isSearching = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    });
  }

  Future<void> _onSuggestionSelected(Suggestion suggestion) async {
    setState(() => _isSearching = true);

    try {
      final response =
          await PlaceApiProvider.getPlaceDetailFromPlaceId(suggestion.placeId!);

      if (response != null) {
        setState(() {
          _selectedPlace = response;
          _searchController.text = response.location ?? '';
          _suggestions = [];
          _isSearching = false;
        });
      } else {
        setState(() => _isSearching = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to get location details',
                  style: AppFonts.inter(color: Colors.white)),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isSearching = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location details',
                style: AppFonts.inter(color: Colors.white)),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _saveLocation() {
    Address? address;

    switch (_tabController.index) {
      case 0: // Search tab
        if (_searchController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please enter or search for a location',
                  style: AppFonts.inter(color: Colors.white)),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
          return;
        }
        address = Address(
          type: _addressType,
          street: _searchController.text.trim(),
          latitude: _selectedPlace?.latitude,
          longitude: _selectedPlace?.longitude,
        );
        break;

      case 1: // GhanaPostGPS tab
        if (!_gpsFormKey.currentState!.validate()) return;
        address = Address(
          type: _addressType,
          street: '', // GPS is primary identifier
          ghanaPost: _gpsController.text.trim(),
        );
        break;

      case 2: // what3words tab
        if (!_w3wFormKey.currentState!.validate()) return;
        address = Address(
          type: _addressType,
          street: '', // w3w is primary identifier
          what3words: _w3wController.text.trim(),
        );
        break;
    }

    Navigator.pop(context, address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Address type chips
            _buildAddressTypeChips(),

            const SizedBox(height: 16),

            // Tabs
            _buildTabBar(),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSearchTab(),
                  _buildGPSTab(),
                  _buildW3WTab(),
                ],
              ),
            ),

            // Save button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Set Delivery Location',
              textAlign: TextAlign.center,
              style: AppFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildAddressTypeChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _typeChip('Home', Icons.home_rounded),
          const SizedBox(width: 10),
          _typeChip('Work', Icons.work_rounded),
          const SizedBox(width: 10),
          _typeChip('Other', Icons.location_on_rounded),
        ],
      ),
    );
  }

  Widget _typeChip(String label, IconData icon) {
    final isSelected = _addressType == label;
    return GestureDetector(
      onTap: () => setState(() => _addressType = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primary,
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppFonts.inter(fontSize: 14),
        indicatorColor: AppTheme.primary,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: '🔍 Search'),
          Tab(text: '📍 GhanaPost'),
          Tab(text: '#️⃣ what3words'),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: AppFonts.inter(fontSize: 15, color: const Color(0xFF0F172A)),
              decoration: InputDecoration(
                hintText: 'Search for your street, area, landmark...',
                hintStyle: AppFonts.inter(
                  fontSize: 15,
                  color: const Color(0xFF94A3B8),
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF94A3B8)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _suggestions = [];
                            _selectedPlace = null;
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),

        // Loading indicator
        if (_isSearching)
          const Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),

        // Suggestions list
        if (!_isSearching && _suggestions.isNotEmpty)
          Expanded(
            child: ListView.separated(
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return ListTile(
                  leading: const Icon(Icons.location_on,
                      color: Color(0xFF64748B), size: 20),
                  title: Text(
                    suggestion.description ?? '',
                    style: AppFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  onTap: () => _onSuggestionSelected(suggestion),
                );
              },
            ),
          ),

        // Selected place preview
        if (_selectedPlace != null && _suggestions.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: AppTheme.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Location',
                          style: AppFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedPlace!.location ?? '',
                          style: AppFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Empty state
        if (!_isSearching &&
            _suggestions.isEmpty &&
            _selectedPlace == null &&
            _searchController.text.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Start typing to search for a location',
                    style: AppFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGPSTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _gpsFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GhanaPostGPS',
              style: AppFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your GhanaPostGPS digital address code',
              style: AppFonts.inter(
                fontSize: 13,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextFormField(
                controller: _gpsController,
                style: AppFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: 'GA-123-4567',
                  hintStyle: AppFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF94A3B8),
                  ),
                  prefixIcon: const Icon(Icons.share_location_rounded,
                      color: Color(0xFF94A3B8), size: 24),
                  border: InputBorder.none,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFEF4444)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFEF4444)),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please enter your GhanaPostGPS code';
                  }
                  final pattern =
                      RegExp(r'^[A-Z]{2}-\d{3,4}-\d{4}$', caseSensitive: false);
                  if (!pattern.hasMatch(v.trim())) {
                    return 'Format: XX-123-4567';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: Color(0xFF0284C7), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Find your GPS code at Nigeriapostgps.com',
                      style: AppFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF0369A1),
                      ),
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

  Widget _buildW3WTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _w3wFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'what3words',
              style: AppFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your 3 word address',
              style: AppFonts.inter(
                fontSize: 13,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextFormField(
                controller: _w3wController,
                style: AppFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: '///filled.count.soap',
                  hintStyle: AppFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF94A3B8),
                  ),
                  prefixIcon: const Icon(Icons.grid_3x3_rounded,
                      color: Color(0xFF94A3B8), size: 24),
                  border: InputBorder.none,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFEF4444)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFEF4444)),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please enter your what3words address';
                  }
                  final pattern = RegExp(r'^\/\/\/[a-z]+\.[a-z]+\.[a-z]+$');
                  if (!pattern.hasMatch(v.trim())) {
                    return 'Format: ///word.word.word';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: Color(0xFF0284C7), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Find your 3 word address at what3words.com',
                      style: AppFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF0369A1),
                      ),
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

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _saveLocation,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 0,
          ),
          child: Text(
            'Use This Location',
            style: AppFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
