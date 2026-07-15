import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ImportProductsScreen extends StatelessWidget {
  const ImportProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 1,
        shadowColor: AppColors.border,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload a CSV or Excel file', style: AppTextStyles.heading2.copyWith(fontSize: 24)),
            const SizedBox(height: 8),
            Text(
              'Add multiple products to your catalog at once by uploading your data sheet.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(LucideIcons.downloadCloud, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Download template',
                  style: AppTextStyles.subtitleMedium.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Upload Area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2, style: BorderStyle.solid), // Should be dashed but solid is easier for now
              ),
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(LucideIcons.uploadCloud, size: 32, color: AppColors.primary),
                  ),
                  const SizedBox(height: 24),
                  Text('Tap to upload', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    'or drag and drop your file here\n(CSV, XLSX, XLS)',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text('Select File', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Tips
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.info, size: 18, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Import Tips', style: AppTextStyles.subtitleMedium),
                        const SizedBox(height: 4),
                        Text(
                          'Ensure your headers match the template. Image URLs must be publicly accessible.',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 4,
                  shadowColor: AppColors.primary.withOpacity(0.4),
                ),
                child: const Text('Preview Import', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'SUPPORTS FILES UP TO 50MB',
                style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
