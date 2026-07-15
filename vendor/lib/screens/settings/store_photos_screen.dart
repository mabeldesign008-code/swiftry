import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StorePhotosScreen extends StatelessWidget {
  const StorePhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 1,
        shadowColor: AppColors.border,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Store Photos', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Photo
            Text('Cover Photo', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
            const SizedBox(height: 4),
            Text('This is the first image customers see on your profile.', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1)),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    color: const Color(0xFFE2E8F0),
                    alignment: Alignment.center,
                    child: const Icon(LucideIcons.image, size: 40, color: Color(0xFF94A3B8)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Main Storefront', style: AppTextStyles.heading3.copyWith(fontSize: 18)),
                            const SizedBox(height: 4),
                            Text('Last updated 2 days ago', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.edit2, size: 14, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('Change cover', style: AppTextStyles.subtitleMedium.copyWith(color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Pro Tips
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFEDD5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.lightbulb, size: 20, color: Color(0xFFEA580C)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pro Tips for Better Sales', style: AppTextStyles.subtitleMedium),
                        const SizedBox(height: 8),
                        _proTipItem('Use natural daylight for interior shots'),
                        _proTipItem('Capture both wide angles and close-up details'),
                        _proTipItem('Keep the background clean and uncluttered'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Gallery
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Gallery', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                Text('5 / 20 photos', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 6, // 1 add button + 5 photos
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3), style: BorderStyle.solid), // dashed ideally
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.plus, size: 24, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text('Add Photo', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  );
                }
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: NetworkImage('https://placehold.co/400x400/png'), // Placeholder
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                    ),
                    child: const Icon(LucideIcons.trash2, size: 14, color: AppColors.error),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _proTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4, height: 4,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))),
        ],
      ),
    );
  }
}
