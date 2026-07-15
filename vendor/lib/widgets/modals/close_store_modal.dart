import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CloseStoreModal extends StatefulWidget {
  const CloseStoreModal({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CloseStoreModal(),
    );
  }

  @override
  State<CloseStoreModal> createState() => _CloseStoreModalState();
}

class _CloseStoreModalState extends State<CloseStoreModal> {
  String _selectedOption = 'manual'; // manual, today, duration
  String _selectedDuration = '2h'; // 1h, 2h, 4h, custom

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Icon + title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE2E2), // red-100
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.alertCircle, size: 26, color: Color(0xFFDC2626)),
                ),
                const SizedBox(height: 12),
                Text('Close your store?', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                const SizedBox(height: 4),
                Text(
                  'Select how long you want to pause operations.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OptionTile(
                  label: 'Close until I reopen manually',
                  isSelected: _selectedOption == 'manual',
                  onTap: () => setState(() => _selectedOption = 'manual'),
                ),
                const SizedBox(height: 10),
                _OptionTile(
                  label: 'Close for today',
                  isSelected: _selectedOption == 'today',
                  onTap: () => setState(() => _selectedOption = 'today'),
                ),
                const SizedBox(height: 10),
                _OptionTile(
                  label: 'Close for a specific duration',
                  isSelected: _selectedOption == 'duration',
                  onTap: () => setState(() => _selectedOption = 'duration'),
                ),

                // Duration pills
                if (_selectedOption == 'duration') ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      'DURATION',
                      style: AppTextStyles.captionBold.copyWith(
                        color: AppColors.textTertiary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _DurationPill(label: '1h', isSelected: _selectedDuration == '1h', onTap: () => setState(() => _selectedDuration = '1h')),
                      const SizedBox(width: 8),
                      _DurationPill(label: '2h', isSelected: _selectedDuration == '2h', onTap: () => setState(() => _selectedDuration = '2h')),
                      const SizedBox(width: 8),
                      _DurationPill(label: '4h', isSelected: _selectedDuration == '4h', onTap: () => setState(() => _selectedDuration = '4h')),
                      const SizedBox(width: 8),
                      _DurationPill(label: 'custom', isSelected: _selectedDuration == 'custom', onTap: () => setState(() => _selectedDuration = 'custom')),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.surfaceSecondary,
                        foregroundColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: AppTextStyles.buttonTextSmall,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1463FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: AppTextStyles.buttonTextSmall,
                        elevation: 0,
                      ),
                      child: const Text('Close Store'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1463FF).withOpacity(0.04) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF1463FF) : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1463FF) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF1463FF) : AppColors.border,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: isSelected ? const Icon(LucideIcons.check, size: 10, color: Colors.white) : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.subtitleMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DurationPill({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1463FF).withOpacity(0.1) : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF1463FF) : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.subtitleMedium.copyWith(
            color: isSelected ? const Color(0xFF1463FF) : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
