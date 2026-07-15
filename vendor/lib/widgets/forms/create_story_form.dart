import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../screens/analytics/story_preview_screen.dart';

/// Extracted form widget matching the CreateStoryForm Figma export.
/// Contains media source buttons, preview zone, caption input,
/// and product tagging section. Embeddable in CreateStoryScreen.
class CreateStoryForm extends StatefulWidget {
  const CreateStoryForm({super.key});

  @override
  State<CreateStoryForm> createState() => _CreateStoryFormState();
}

class _CreateStoryFormState extends State<CreateStoryForm> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isProductTagged = false;

  @override
  void dispose() {
    _captionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Media Source Selection
        Text('MEDIA SOURCE', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.7)),
        const SizedBox(height: 12),
        Row(
          children: [
            _mediaSourceButton(LucideIcons.camera, 'Camera'),
            const SizedBox(width: 12),
            _mediaSourceButton(LucideIcons.image, 'Gallery'),
            const SizedBox(width: 12),
            _mediaSourceButton(LucideIcons.video, 'Record'),
          ],
        ),
        const SizedBox(height: 24),

        // Preview Zone
        Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.image, size: 48, color: Color(0xFF94A3B8)),
                  const SizedBox(height: 12),
                  Text('No media selected yet', style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFF94A3B8))),
                  Text('Videos must be under 30s', style: AppTextStyles.caption.copyWith(color: const Color(0xFF94A3B8))),
                ],
              ),
              Positioned(
                bottom: 16, right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.edit2, size: 14, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('Change Media', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Caption
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Caption', style: AppTextStyles.subtitleMedium),
            Text('0 / 150', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _captionController,
          maxLines: 4,
          maxLength: 150,
          decoration: InputDecoration(
            hintText: "Tell your customers what's happening...",
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            counterText: '',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
          ),
        ),
        const SizedBox(height: 24),

        // Product Tagging
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(LucideIcons.tag, size: 20, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tag a Product', style: AppTextStyles.subtitleMedium),
                          Text('Feature a menu item in this story', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isProductTagged,
                      onChanged: (val) => setState(() => _isProductTagged = val),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              if (_isProductTagged)
                Container(
                  color: const Color(0xFFF8FAFC),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search your menu...',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          prefixIcon: const Icon(LucideIcons.search, size: 18, color: AppColors.textSecondary),
                          filled: true, fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4)),
                              child: const Icon(LucideIcons.image, size: 20, color: AppColors.textSecondary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Summer Avocado Salad', style: AppTextStyles.subtitleMedium.copyWith(fontSize: 12)),
                                  Text('GHS 12.50', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.x, size: 16, color: AppColors.textSecondary),
                              onPressed: () {},
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
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

        // Publish CTA
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => StoryPreviewScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Preview & Publish', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _mediaSourceButton(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.subtitleMedium.copyWith(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
