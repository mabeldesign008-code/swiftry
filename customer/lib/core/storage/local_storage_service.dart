import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../../models/address.dart';
import '../../models/cart_item.dart';
import '../../models/order.dart';

/// Local storage for non-sensitive data: cart, favourites, search history, addresses.
/// Prepares for backend sync - all methods have TODO for API sync when online.

class LocalStorageService {
  static const String _keyCart = 'swiftree_local_cart';
  static const String _keyAddresses = 'swiftree_local_addresses';
  static const String _keyOrdersCache = 'swiftree_orders_cache';
  static const String _keyWalletTransactions = 'swiftree_wallet_tx';

  // -- Onboarding
  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefKeyOnboardingDone) ?? false;
  }

  Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefKeyOnboardingDone, true);
  }

  // -- Favourites (set of restaurant IDs)
  Future<Set<String>> getFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(AppConstants.prefKeyFavourites) ?? [];
    return list.toSet();
  }

  Future<void> saveFavourites(Set<String> favs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(AppConstants.prefKeyFavourites, favs.toList());
  }

  // -- Search History
  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(AppConstants.prefKeySearchHistory) ?? [];
  }

  Future<void> addSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(AppConstants.prefKeySearchHistory) ?? [];
    history.remove(query); // remove duplicate
    history.insert(0, query);
    if (history.length > 20) history.removeLast();
    await prefs.setStringList(AppConstants.prefKeySearchHistory, history);
  }

  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefKeySearchHistory);
  }

  // -- Cart persistence (frontend - will sync with backend /cart)
  Future<void> saveCart(List<CartItem> cart) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = cart.map((e) => {
      'title': e.title,
      'description': e.description,
      'price': e.price,
      'quantity': e.quantity,
      'imageUrl': e.imageUrl,
      'restaurantId': e.restaurantId,
      'vendorId': e.vendorId,
      'vendorName': e.vendorName,
      'specialInstructions': e.specialInstructions,
      'selectedAddons': e.selectedAddons,
      'selectedVariants': e.selectedVariants,
    }).toList();
    await prefs.setString(_keyCart, jsonEncode(jsonList));
    // TODO Backend: Sync with POST /cart when online
  }

  Future<List<CartItem>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyCart);
    if (jsonStr == null) return [];
    try {
      final list = jsonDecode(jsonStr) as List;
      return list.map((m) => CartItem(
        title: m['title'],
        description: m['description'],
        price: (m['price'] as num).toDouble(),
        quantity: m['quantity'],
        imageUrl: m['imageUrl'],
        restaurantId: m['restaurantId'],
        vendorId: m['vendorId'],
        vendorName: m['vendorName'],
        specialInstructions: m['specialInstructions'],
        selectedAddons: List<Map<String, dynamic>>.from(m['selectedAddons'] ?? []),
        selectedVariants: List<Map<String, dynamic>>.from(m['selectedVariants'] ?? []),
      )).toList();
    } catch (_) {
      return [];
    }
  }

  // -- Addresses
  Future<void> saveAddresses(List<Address> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = addresses.map((a) => {
      'type': a.type,
      'label': a.label,
      'street': a.street,
      'ghanaPost': a.ghanaPost ?? a.NigeriaPost, // backward compat
      'what3words': a.what3words,
      'lat': a.latitude,
      'lng': a.longitude,
      'areaName': a.areaName,
      'landmark': a.landmark,
      'instructions': a.deliveryInstructions,
      'phone': a.contactPhone,
      'isDefault': a.isDefault,
    }).toList();
    await prefs.setString(_keyAddresses, jsonEncode(jsonList));
  }

  // -- Order cache (for offline viewing, syncs with backend history)
  Future<void> cacheOrders(List<Order> orders) async {
    final prefs = await SharedPreferences.getInstance();
    // Only cache IDs for now - full serialization will be done after json support
    final ids = orders.map((o) => o.id).toList();
    await prefs.setStringList(_keyOrdersCache, ids);
    // TODO Backend: Cache full orders JSON after implementing Order.toJson()
  }

  // -- Clear all local data (on logout)
  Future<void> clearAllLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCart);
    await prefs.remove(_keyAddresses);
    await prefs.remove(_keyOrdersCache);
    await prefs.remove(_keyWalletTransactions);
    await prefs.remove(AppConstants.prefKeyFavourites);
    await prefs.remove(AppConstants.prefKeySearchHistory);
  }
}
