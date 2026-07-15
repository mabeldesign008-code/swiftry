import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class PreparationTimeSettingsScreen extends StatefulWidget {
  const PreparationTimeSettingsScreen({super.key});

  @override
  State<PreparationTimeSettingsScreen> createState() => _PreparationTimeSettingsScreenState();
}

class _PreparationTimeSettingsScreenState extends State<PreparationTimeSettingsScreen> {
  int _selectedTime = 10;
  bool _smartPause = true;
  int _pauseThreshold = 5;

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
        title: Text('Preparation Settings', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('SAVE', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Default Preparation Time
            Row(
              children: [
                const Icon(LucideIcons.clock, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Default Preparation Time', style: AppTextStyles.heading2.copyWith(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Estimated time to prepare a standard order.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [10, 15, 20, 25, 30].map((time) {
                final isSelected = _selectedTime == time;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTime = time),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : const Color(0xFFF1F5F9),
                      border: Border.all(color: isSelected ? AppColors.primary.withOpacity(0.3) : Colors.transparent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$time min',
                      style: AppTextStyles.subtitleMedium.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Divider(color: AppColors.border),
            const SizedBox(height: 24),

            // Safety & Auto-Pause
            Row(
              children: [
                const Icon(LucideIcons.shield, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Safety & Auto-Pause', style: AppTextStyles.heading2.copyWith(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Smart Pause', style: AppTextStyles.subtitleMedium),
                            const SizedBox(height: 4),
                            Text(
                              'Temporarily stop accepting new orders when current queue is full.',
                              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _smartPause,
                        activeColor: AppColors.primary,
                        onChanged: (val) => setState(() => _smartPause = val),
                      ),
                    ],
                  ),
                  if (_smartPause) ...[
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pause when orders reach:', style: AppTextStyles.subtitleMedium),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (_pauseThreshold > 1) setState(() => _pauseThreshold--);
                              },
                              icon: const Icon(LucideIcons.minusCircle, size: 20, color: AppColors.textSecondary),
                            ),
                            Text('$_pauseThreshold', style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                            IconButton(
                              onPressed: () {
                                setState(() => _pauseThreshold++);
                              },
                              icon: const Icon(LucideIcons.plusCircle, size: 20, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'System will resume orders automatically after 15 minutes or when queue drops below 3.',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(LucideIcons.lightbulb, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '"Accurate prep times lead to 24% higher customer satisfaction and better driver ratings."',
                      style: AppTextStyles.subtitleMedium.copyWith(fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
