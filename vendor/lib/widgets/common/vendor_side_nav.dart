import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../screens/dashboard/vendor_dashboard_screen.dart';
import '../../screens/orders/vendor_orders_main_view_screen.dart';
import '../../screens/wallet/vendor_wallet_screen.dart';
import '../../screens/menu/menu_management_screen.dart';
import '../../screens/settings/store_settings_screen.dart';

class VendorSideNav extends StatelessWidget {
  final String currentRoute;

  const VendorSideNav({super.key, required this.currentRoute});

  Widget _navItem(BuildContext context, String label, IconData icon, String route, Widget destination) {
    final isActive = currentRoute == route;
    return ListTile(
      leading: Icon(icon, color: isActive ? AppColors.primary : const Color(0xFF64748B), size: 20),
      title: Text(
        label,
        style: AppTextStyles.subtitleMedium.copyWith(
          color: isActive ? AppColors.primary : const Color(0xFF0F172A),
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      selected: isActive,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        if (!isActive) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => destination));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Store Info Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(LucideIcons.store, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Papaye', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(4)),
                          child: const Text('PREMIUM', style: TextStyle(color: Color(0xFFB45309), fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Navigation Links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 8),
                    child: Text('MAIN', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8), letterSpacing: 1.2)),
                  ),
                  _navItem(context, 'Dashboard', LucideIcons.layoutDashboard, 'dashboard', const VendorDashboardScreen()),
                  _navItem(context, 'Orders', LucideIcons.package, 'orders', const VendorOrdersMainViewScreen()),
                  _navItem(context, 'Menu', LucideIcons.building2, 'menu', const MenuManagementScreen()),
                  _navItem(context, 'Wallet', LucideIcons.wallet, 'wallet', const VendorWalletScreen()),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 8),
                    child: Text('PREFERENCES', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8), letterSpacing: 1.2)),
                  ),
                  _navItem(context, 'Settings', LucideIcons.settings, 'settings', const StoreSettingsScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
