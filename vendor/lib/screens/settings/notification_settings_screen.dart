import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _newOrderSound = true;
  bool _vibration = true;
  bool _repeatAlerts = false;
  double _soundVolume = 0.8;

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
        title: Text('Order Notifications', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('SOUND & ALERTS', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary)),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildToggleRow(
                    title: 'New order sound',
                    subtitle: 'Standard chime',
                    value: _newOrderSound,
                    onChanged: (val) => setState(() => _newOrderSound = val),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.volume2, size: 18, color: AppColors.textSecondary),
                            const SizedBox(width: 12),
                            Expanded(child: Text('Sound volume', style: AppTextStyles.subtitleMedium)),
                            Text('${(_soundVolume * 100).toInt()}%', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: _soundVolume,
                          activeColor: AppColors.primary,
                          inactiveColor: AppColors.primary.withOpacity(0.2),
                          onChanged: (val) {
                            setState(() => _soundVolume = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  _buildToggleRow(
                    title: 'Vibration',
                    subtitle: 'Haptic feedback on new orders',
                    value: _vibration,
                    onChanged: (val) => setState(() => _vibration = val),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  _buildToggleRow(
                    title: 'Repeat alerts',
                    subtitle: 'Every 30 seconds',
                    value: _repeatAlerts,
                    onChanged: (val) => setState(() => _repeatAlerts = val),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('SCHEDULE', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary)),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.white,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quiet hours', style: AppTextStyles.subtitleMedium),
                            Text('10PM - 8AM (matches store hours)', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFFCBD5E1)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.4),
            ),
            child: Text('Save Changes', style: AppTextStyles.subtitleMedium.copyWith(color: Colors.white, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.subtitleMedium),
                Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
