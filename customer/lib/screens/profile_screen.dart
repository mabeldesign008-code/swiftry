import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import 'edit_profile_screen.dart';
import 'saved_addresses_screen.dart';
import 'wallet_screen.dart';
import 'orders_screen.dart';
import 'favourites_screen.dart';
import 'help_support_screen.dart';
import 'refer_earn_screen.dart';
import 'my_reviews_screen.dart';
import 'payment_methods_screen.dart';
import 'settings_screen.dart';
import 'vouchers_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'swiftree User';
  String _userPhone = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _userName = prefs.getString(AppConstants.prefKeyUserName) ?? 'swiftree User';
      _userPhone = prefs.getString(AppConstants.prefKeyUserPhone) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profile Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 24, bottom: 32),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      image: const DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/150?img=11'), // Placeholder avatar
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userName,
                    style: AppFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userPhone.isNotEmpty ? _userPhone : 'No phone number',
                    style: AppFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildMenuGroup(
                    title: 'Account Settings',
                    items: [
                      _buildMenuItem(Icons.person_outline, 'Personal Information', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                      }),
                      _buildMenuItem(Icons.location_on_outlined, 'Saved Addresses', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedAddressesScreen()));
                      }),
                      _buildMenuItem(Icons.payment_outlined, 'Payment Methods', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()));
                      }),
                      _buildMenuItem(Icons.account_balance_wallet_outlined, 'Wallet', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildMenuGroup(
                    title: 'Activity',
                    items: [
                      _buildMenuItem(Icons.receipt_long_outlined, 'Order History', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
                      }),
                      _buildMenuItem(Icons.favorite_outline, 'Favorites', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const FavouritesScreen()));
                      }),
                      _buildMenuItem(Icons.star_outline, 'My Reviews', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const MyReviewsScreen()));
                      }),
                      _buildMenuItem(Icons.local_offer_outlined, 'Vouchers', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const VouchersScreen()));
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildMenuGroup(
                    title: 'More',
                    items: [
                      _buildMenuItem(Icons.card_giftcard_outlined, 'Refer & Earn', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferEarnScreen()));
                      }),
                      _buildMenuItem(Icons.settings_outlined, 'Settings', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                      }),
                      _buildMenuItem(Icons.help_outline, 'Help & Support', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
                      }),
                      _buildMenuItem(Icons.info_outline, 'About swiftree', onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'swiftree',
                          applicationVersion: '1.0.0',
                          applicationIcon: Image.asset(
                            'assets/images/logo.png',
                            width: 56, height: 56,
                            errorBuilder: (_, __, ___) => Icon(Icons.local_shipping, size: 56, color: AppTheme.primary),
                          ),
                          children: [
                            Text(
                              'Food, groceries, pharmacy, parcel, errands and more — all in one app!',
                              style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '© 2025 swiftree. Made in Nigeria 🇬🇭',
                              style: AppFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _confirmLogout(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444), side: const BorderSide(color: Color(0xFFEF4444)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'Log Out',
                        style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Log Out', style: AppFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
        content: Text('Are you sure you want to log out?', style: AppFonts.inter(color: const Color(0xFF64748B))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: AppFonts.inter(color: const Color(0xFF64748B))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Log Out', style: AppFonts.inter(color: const Color(0xFFEF4444), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true && context.mounted) {
        // Clear session from prefs
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.prefKeyUserLoggedIn, false);
        await prefs.remove(AppConstants.prefKeyUserPhone);
        await prefs.remove(AppConstants.prefKeyUserName);
        await prefs.remove(AppConstants.prefKeyUserEmail);
        if (!context.mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/welcome',
          (route) => false,
        );
      }
    });
  }

  Widget _buildMenuGroup({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
            children: items.asMap().entries.map((entry) {
              final int idx = entry.key;
              final Widget item = entry.value;
              return Column(
                children: [
                  item,
                  if (idx < items.length - 1)
                    const Divider(height: 1, indent: 56, endIndent: 16, color: Color(0xFFF1F5F9)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: AppFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF0F172A),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
    );
  }
}
