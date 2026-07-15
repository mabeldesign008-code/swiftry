import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 112, height: 112,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 10))],
                          image: const DecorationImage(
                            image: NetworkImage('https://i.pravatar.cc/300'), // Placeholder
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(LucideIcons.camera, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Kofi Mensah', style: AppTextStyles.heading2.copyWith(fontSize: 24)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text('VENDOR #88291', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary)),
                  ),
                  const SizedBox(height: 8),
                  Text('Member since Oct 2023', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 14)),
                ],
              ),
            ),
            
            // Personal Details Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Color(0x0C000000), blurRadius: 20, offset: Offset(0, -4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PERSONAL DETAILS', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  
                  _detailCard('Email Address', 'kofi.mensah@email.com', LucideIcons.mail, AppColors.primary),
                  const SizedBox(height: 12),
                  
                  _detailCard('Phone Number', '+233 24 555 0123', LucideIcons.phone, AppColors.primary),
                  const SizedBox(height: 12),
                  
                  _detailCard('Password', '••••••••••••', LucideIcons.lock, AppColors.primary),
                  
                  const SizedBox(height: 120), // Padding for scrolling
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.subtitleMedium),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, size: 20, color: Color(0xFFCBD5E1)),
        ],
      ),
    );
  }
}
