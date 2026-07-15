import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ProductOptionsMenuSheet extends StatelessWidget {
  final String productName;

  const ProductOptionsMenuSheet({super.key, required this.productName});

  static Future<String?> show(BuildContext context, String productName) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductOptionsMenuSheet(productName: productName),
    );
  }

  Widget _action(BuildContext context, String title, IconData icon, String value, {bool isDanger = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDanger ? AppColors.error.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 20, color: isDanger ? AppColors.error : AppColors.primary),
      ),
      title: Text(title, style: AppTextStyles.subtitleMedium.copyWith(color: isDanger ? AppColors.error : AppColors.textPrimary)),
      onTap: () => Navigator.pop(context, value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48, height: 6,
                decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(3)),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productName, style: AppTextStyles.heading2.copyWith(fontSize: 22)),
                  const SizedBox(height: 8),
                  Text('Manage your product listing details and availability.', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _action(context, 'Edit item', LucideIcons.edit2, 'edit'),
            _action(context, 'Duplicate item', LucideIcons.copy, 'duplicate'),
            _action(context, 'Move to category', LucideIcons.folder, 'move'),
            _action(context, 'Mark out of stock', LucideIcons.eyeOff, 'out_of_stock'),
            _action(context, 'Delete item', LucideIcons.trash2, 'delete', isDanger: true),
          ],
        ),
      ),
    );
  }
}
