import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'edit_store_profile_screen.dart';
import 'operating_hours_screen.dart';
import 'location_delivery_screen.dart';
import 'notification_settings_screen.dart';
import 'account_settings_screen.dart';
import 'documents_management_screen.dart';
import 'preparation_time_settings_screen.dart';
import 'store_photos_screen.dart';
import '../support/help_center_screen.dart';
import 'advanced_settings_screen.dart';

class StoreSettingsScreen extends StatelessWidget {
  const StoreSettingsScreen({super.key});

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 18)),
    );
  }

  Widget _button({required IconData icon, required String label, required VoidCallback onTap, Color color = AppColors.primary, Color? iconBg}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: iconBg ?? color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTextStyles.subtitleMedium.copyWith(color: color))),
            const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white.withOpacity(0.9),
            pinned: true,
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('Store Settings', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
            actions: [
              TextButton(
                onPressed: () {},
                child: Text('Save', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: AppColors.border, height: 1),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Store Profile Section
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader('Store Profile'),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            // Banner
                            Container(
                              height: 120,
                              color: const Color(0xFFE2E8F0),
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.only(left: 16, bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Logo
                                  Container(
                                    width: 80, height: 80,
                                    margin: const EdgeInsets.only(bottom: -40),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 4),
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(LucideIcons.store, size: 32, color: AppColors.primary),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => const StorePhotosScreen(),
                                      ));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(16)),
                                      child: Row(
                                        children: [
                                          const Icon(LucideIcons.image, size: 12, color: AppColors.textPrimary),
                                          const SizedBox(width: 4),
                                          Text('Edit Cover', style: AppTextStyles.captionBold),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 48),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('STORE NAME', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.6)),
                                  const SizedBox(height: 2),
                                  Text('Main Tree Supermarket', style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
                                  const SizedBox(height: 16),
                                  Text('DESCRIPTION', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.6)),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Fresh organic groceries, farm-to-table produce, and daily household essentials delivered to your doorstep within 30 minutes.',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 44,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_) => const EditStoreProfileScreen(),
                                        ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary.withOpacity(0.1),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                                      ),
                                      child: Text('Edit Profile Details', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: AppColors.border),

                // Operating Hours
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _sectionHeader('Operating Hours'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(16)),
                            child: Text('OPEN NOW', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF15803D), fontSize: 10)),
                          ),
                        ],
                      ),
                      _scheduleRow('Mon - Fri', '08:00 AM - 10:00 PM'),
                      const SizedBox(height: 8),
                      _scheduleRow('Saturday', '09:00 AM - 11:00 PM'),
                      const SizedBox(height: 8),
                      _scheduleRow('Sunday', 'Closed', isClosed: true),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const OperatingHoursScreen(),
                          ));
                        },
                        child: Row(
                          children: [
                            const Icon(LucideIcons.calendar, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text('Update Schedule', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: AppColors.border),

                // Delivery Settings
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader('Delivery Settings'),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(LucideIcons.clock, size: 18, color: AppColors.primary),
                                  const SizedBox(height: 8),
                                  Text('PREP TIME', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 0.6)),
                                  const SizedBox(height: 2),
                                  Text('15-20 mins', style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(LucideIcons.mapPin, size: 18, color: AppColors.primary),
                                  const SizedBox(height: 8),
                                  Text('RADIUS', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 0.6)),
                                  const SizedBox(height: 2),
                                  Text('5.0 km', style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const LocationDeliveryScreen(),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border)),
                          child: Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: const Icon(LucideIcons.map, size: 18, color: AppColors.primary),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Delivery Zone', style: AppTextStyles.subtitleMedium),
                                    Text('View areas covered on map', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFFCBD5E1)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: AppColors.border),

                // Account Management
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader('Account Management'),
                      _button(
                        icon: LucideIcons.user,
                        label: 'Personal Details & Password',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const AccountSettingsScreen(),
                          ));
                        },
                        color: AppColors.textPrimary,
                        iconBg: AppColors.textSecondary.withOpacity(0.1),
                      ),
                      const SizedBox(height: 12),
                      _button(
                        icon: LucideIcons.bell,
                        label: 'Notification Settings',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const NotificationSettingsScreen(),
                          ));
                        },
                        color: AppColors.textPrimary,
                        iconBg: AppColors.textSecondary.withOpacity(0.1),
                      ),
                      const SizedBox(height: 12),
                      _button(
                        icon: LucideIcons.fileBadge2,
                        label: 'Documents & Compliance',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const DocumentsManagementScreen(),
                          ));
                        },
                        color: AppColors.textPrimary,
                        iconBg: AppColors.textSecondary.withOpacity(0.1),
                      ),
                      const SizedBox(height: 12),
                      _button(icon: LucideIcons.trash2, label: 'Delete Account', onTap: () {}, color: const Color(0xFFDC2626), iconBg: const Color(0xFFFECACA)),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 16),
                      _button(
                        icon: LucideIcons.clock,
                        label: 'Preparation Time Settings',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const PreparationTimeSettingsScreen(),
                          ));
                        },
                        color: AppColors.textPrimary,
                        iconBg: AppColors.textSecondary.withOpacity(0.1),
                      ),
                      const SizedBox(height: 12),
                      _button(
                        icon: LucideIcons.helpCircle,
                        label: 'Help Center',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const HelpCenterScreen(),
                          ));
                        },
                        color: AppColors.textPrimary,
                        iconBg: AppColors.textSecondary.withOpacity(0.1),
                      ),
                      const SizedBox(height: 12),
                      _button(
                        icon: LucideIcons.settings,
                        label: 'Advanced Settings',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => AdvancedSettingsScreen(),
                          ));
                        },
                        color: AppColors.textPrimary,
                        iconBg: AppColors.textSecondary.withOpacity(0.1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleRow(String day, String time, {bool isClosed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(day, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        Text(
          time,
          style: AppTextStyles.subtitleMedium.copyWith(color: isClosed ? AppColors.textPrimary : AppColors.textPrimary),
        ),
      ],
    );
  }
}
