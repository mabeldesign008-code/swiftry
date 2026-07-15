import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class DocumentsManagementScreen extends StatelessWidget {
  const DocumentsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        shadowColor: AppColors.border,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Documents Management', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alert Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB), // Amber-50
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFEF3C7)), // Amber-100
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.alertTriangle, color: Color(0xFFD97706), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Document Expiring Soon', style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFF92400E))),
                        const SizedBox(height: 4),
                        Text(
                          'Your Food Hygiene Certificate expires in 30 days. Please update it to avoid service interruption.',
                          style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFFB45309)),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD97706),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            elevation: 0,
                          ),
                          child: const Text('Update Now', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Verification Status
            Text('Verification Status', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
            const SizedBox(height: 16),

            _documentCard(
              title: 'Business Registration',
              status: 'Verified',
              isVerified: true,
              icon: LucideIcons.building,
            ),
            const SizedBox(height: 12),
            _documentCard(
              title: "Owner's Nigeria Card",
              status: 'Verified',
              isVerified: true,
              icon: LucideIcons.creditCard,
            ),
            const SizedBox(height: 12),
            _documentCard(
              title: 'Food Hygiene Certificate',
              status: '30 Days Remaining',
              isVerified: false,
              isExpiring: true,
              icon: LucideIcons.fileBadge2,
            ),
            const SizedBox(height: 12),
            _documentCard(
              title: 'TIN Certificate',
              status: 'Verified',
              isVerified: true,
              icon: LucideIcons.fileText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _documentCard({
    required String title,
    required String status,
    required bool isVerified,
    bool isExpiring = false,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isExpiring ? const Color(0xFFFEF3C7) : AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: isExpiring ? const Color(0xFFFFFBEB) : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isExpiring ? const Color(0xFFD97706) : AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.subtitleMedium),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (isVerified) const Icon(LucideIcons.checkCircle2, size: 14, color: AppColors.success),
                    if (isExpiring) const Icon(LucideIcons.alertCircle, size: 14, color: Color(0xFFD97706)),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: AppTextStyles.captionBold.copyWith(
                        color: isVerified ? AppColors.success : (isExpiring ? const Color(0xFFD97706) : AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(isExpiring ? 'Update' : 'View', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
