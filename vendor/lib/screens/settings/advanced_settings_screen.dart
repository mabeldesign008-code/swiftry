import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AdvancedSettingsScreen extends StatelessWidget {
  const AdvancedSettingsScreen({super.key});

  Widget _buildLink(String title, IconData icon, VoidCallback onTap, {bool isDanger = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDanger ? const Color(0xFFFEF2F2) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDanger ? const Color(0xFFFECACA) : AppColors.border),
          boxShadow: [
            if (!isDanger)
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isDanger ? AppColors.error : const Color(0xFF475569)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.subtitleMedium.copyWith(color: isDanger ? AppColors.error : const Color(0xFF0F172A)),
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 16, color: isDanger ? AppColors.error : const Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

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
        title: Text('Advanced Settings', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Configuration', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.6)),
            const SizedBox(height: 12),
            _buildLink('General Settings', LucideIcons.settings, () {}),
            _buildLink('Inventory Management API', LucideIcons.database, () {}),
            _buildLink('Data Export / Reports', LucideIcons.downloadCloud, () {}),
            _buildLink('Support & Diagnostics', LucideIcons.lifeBuoy, () {}),
            
            const SizedBox(height: 32),
            Text('Danger Zone', style: AppTextStyles.captionBold.copyWith(color: AppColors.error, letterSpacing: 0.6)),
            const SizedBox(height: 12),
            _buildLink('Deactivate Store', LucideIcons.powerOff, () {}, isDanger: true),
            _buildLink('Delete Account', LucideIcons.trash2, () {}, isDanger: true),
          ],
        ),
      ),
    );
  }
}
