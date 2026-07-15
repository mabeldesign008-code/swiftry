import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class OperatingHoursScreen extends StatefulWidget {
  const OperatingHoursScreen({super.key});

  @override
  State<OperatingHoursScreen> createState() => _OperatingHoursScreenState();
}

class _OperatingHoursScreenState extends State<OperatingHoursScreen> {
  bool _isOverrideOpen = true;

  // Mock schedule data
  final Map<String, dynamic> _schedule = {
    'Monday': {'isOpen': true, 'slots': ['09:00 AM - 05:00 PM']},
    'Tuesday': {'isOpen': true, 'slots': ['09:00 AM - 05:00 PM', '07:00 PM - 10:00 PM']},
    'Wednesday': {'isOpen': true, 'slots': ['09:00 AM - 05:00 PM']},
    'Thursday': {'isOpen': true, 'slots': ['09:00 AM - 05:00 PM']},
    'Friday': {'isOpen': true, 'slots': ['09:00 AM - 08:00 PM']},
    'Saturday': {'isOpen': true, 'slots': ['10:00 AM - 10:00 PM']},
    'Sunday': {'isOpen': false, 'slots': []},
  };

  Widget _dayCard(String day, Map<String, dynamic> data) {
    bool isOpen = data['isOpen'];
    List<String> slots = data['slots'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        data['isOpen'] = !isOpen;
                      });
                    },
                    child: Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: isOpen ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isOpen ? AppColors.primary : AppColors.textSecondary.withOpacity(0.5)),
                      ),
                      child: isOpen ? const Icon(LucideIcons.check, size: 16, color: Colors.white) : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(day, style: AppTextStyles.subtitleMedium),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isOpen ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isOpen ? 'Open' : 'Closed',
                  style: AppTextStyles.captionBold.copyWith(color: isOpen ? const Color(0xFF15803D) : AppColors.textSecondary),
                ),
              ),
            ],
          ),
          if (isOpen && slots.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...slots.map((slot) {
              final times = slot.split(' - ');
              return Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 36),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(times[0], style: AppTextStyles.bodyMedium),
                            const Icon(LucideIcons.minus, size: 12, color: AppColors.textSecondary),
                            Text(times[1], style: AppTextStyles.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(LucideIcons.trash2, size: 20, color: AppColors.textSecondary),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              );
            }).toList(),
            Padding(
              padding: const EdgeInsets.only(left: 36, top: 4),
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.plus, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text('Add split hours', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

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
        title: Text('Operating Hours', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Save', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Quick Status
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Open Now', style: AppTextStyles.subtitleMedium),
                        const SizedBox(height: 4),
                        Text('Override schedule to show as open', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isOverrideOpen,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _isOverrideOpen = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Weekly Schedule Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Weekly Schedule', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.plus, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text('Add Hours', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Schedule Cards
            ..._schedule.entries.map((e) => _dayCard(e.key, e.value)).toList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
