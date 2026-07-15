import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/custom_text_field.dart';

class EditStoreProfileScreen extends StatelessWidget {
  const EditStoreProfileScreen({super.key});

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: AppColors.border,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Edit Store Profile', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Save', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Photo Section
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 128, height: 128,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(LucideIcons.store, size: 48, color: AppColors.primary),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(LucideIcons.camera, size: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Papaye Fast Food', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text('Tap to change logo (PNG, JPG up to 5MB)', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // General Information
            _sectionTitle('GENERAL INFORMATION'),
            CustomTextField(
              label: 'Store Name',
              hint: 'e.g., Papaye Fast Food',
              initialValue: 'Papaye Fast Food',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Business Type',
              hint: 'e.g., Restaurant',
              initialValue: 'Restaurant',
              suffixIcon: const Icon(LucideIcons.chevronDown, size: 20, color: AppColors.textSecondary),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Cuisine Style',
              hint: 'e.g., Nigeriaian, Fast Food',
              initialValue: 'Nigeriaian, Fast Food',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Description',
              hint: 'Briefly describe your store',
              initialValue: 'Quality Nigeriaian local dishes and continental meals delivered fresh to your doorstep.',
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            // Contact Information
            _sectionTitle('CONTACT INFORMATION'),
            CustomTextField(
              label: 'Phone Number',
              hint: 'e.g., +233 24 000 0000',
              initialValue: '+233 24 000 0000',
              prefixIcon: const Icon(LucideIcons.phone, size: 18, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email Address',
              hint: 'e.g., contact@papayefastfood.com',
              initialValue: 'contact@papayefastfood.com',
              prefixIcon: const Icon(LucideIcons.mail, size: 18, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            // Store Location
            _sectionTitle('STORE LOCATION'),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.mapPin, size: 32, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text('Oxford Street, Osu, Accra, Nigeria', style: AppTextStyles.subtitleMedium),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 12, right: 12,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.edit2, size: 14, color: AppColors.textPrimary),
                      label: Text('Edit Address', style: AppTextStyles.captionBold.copyWith(color: AppColors.textPrimary)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.textPrimary,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Dangerous Zone
            Container(
              padding: const EdgeInsets.only(top: 32),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFEE2E2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.alertTriangle, size: 20, color: Color(0xFFDC2626)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Deactivate Store Profile',
                          style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFFDC2626)),
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFFDC2626)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
