import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class LocationPreview extends StatelessWidget {
  const LocationPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.border, // #e2e8f0 matching React's background
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Map Placeholder Image (In a real app, this might be flutter_map or a network image)
            // For now, we simulate the React location map preview behavior
            Container(
              color: const Color(0xFFE2E8F0), // Matches bg-[#e2e8f0]
              width: double.infinity,
              height: double.infinity,
              // We could use Image.asset here if the map preview is available in assets
            ),
            
            // Map Pin Icon in center
            Center(
              child: Container(
                width: 30,
                height: 37,
                alignment: Alignment.topCenter,
                child: const Icon(
                  LucideIcons.mapPin,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
            ),

            // Blur Overlay
            Positioned(
              left: 9,
              right: 9,
              bottom: 9,
              child: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9), // bg-[rgba(255,255,255,0.9)]
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  // Note: To match backdrop-blur-[2px], we could use BackdropFilter,
                  // but a semi-transparent white background usually suffices.
                ),
                child: Text(
                  'Tap to adjust pinned location accurately',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
