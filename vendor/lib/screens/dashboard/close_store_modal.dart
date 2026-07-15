import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CloseStoreModal extends StatefulWidget {
  const CloseStoreModal({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
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
  String _selectedOption = 'Close until I reopen manually';

  final List<String> _options = [
    'Close until I reopen manually',
    'Close for today',
    'Close for a specific duration',
  ];

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48, height: 6,
              decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(height: 24),
            Container(
              width: 56, height: 56,
              decoration: const BoxDecoration(color: Color(0xFFFEE2E2), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Icon(Icons.store_outlined, size: 28, color: AppColors.error),
            ),
            const SizedBox(height: 16),
            Text('Close your store?', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
            const SizedBox(height: 8),
            Text(
              'Select how long you\'d like to pause your operations.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: _options.map((option) {
                  final isSelected = _selectedOption == option;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedOption = option),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20, height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: isSelected ? AppColors.primary : const Color(0xFFCBD5E1), width: 2),
                              color: isSelected ? AppColors.primary : Colors.transparent,
                            ),
                            child: isSelected ? const Icon(Icons.circle, size: 8, color: Colors.white) : null,
                          ),
                          const SizedBox(width: 16),
                          Text(option, style: AppTextStyles.subtitleMedium),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _selectedOption),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Close Store', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
