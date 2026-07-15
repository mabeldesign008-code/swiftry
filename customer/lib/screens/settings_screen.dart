import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import '../providers/settings_provider.dart';

const Color _primary = Color(0xFF0068FF);
const Color _dark = Color(0xFF0F172A);
const Color _mid = Color(0xFF64748B);
const Color _border = Color(0xFFE8EDF2);

const List<String> _kLanguages = ['English', 'Twi', 'Ga', 'Français'];

/// App preferences — notifications, language, theme. Previously there was
/// no Settings screen at all; `notifications_screen.dart` only shows the
/// notification *feed*, not preferences for what to be notified about.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _pickLanguage(BuildContext context, WidgetRef ref, String current) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _kLanguages.map((lang) {
              return ListTile(
                title: Text(lang, style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: _dark)),
                trailing: lang == current ? const Icon(Icons.check_rounded, color: _primary) : null,
                onTap: () {
                  ref.read(settingsProvider.notifier).setLanguage(lang);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Settings', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: _border, height: 1)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionLabel('NOTIFICATIONS'),
          _card([
            _switchRow('Push notifications', 'Order updates, promos and offers', settings.pushNotifications, notifier.setPushNotifications),
            _divider(),
            _switchRow('Email notifications', 'Receipts and account emails', settings.emailNotifications, notifier.setEmailNotifications),
            _divider(),
            _switchRow('SMS notifications', 'Order status via text message', settings.smsNotifications, notifier.setSmsNotifications),
          ]),
          const SizedBox(height: 20),
          _sectionLabel('APPEARANCE'),
          _card([
            _switchRow('Dark mode', 'Coming soon — preference is saved for later', settings.darkMode, notifier.setDarkMode),
          ]),
          const SizedBox(height: 20),
          _sectionLabel('REGION'),
          _card([
            _tapRow(
              icon: Icons.language_rounded,
              label: 'Language',
              value: settings.language,
              onTap: () => _pickLanguage(context, ref, settings.language),
            ),
          ]),
          const SizedBox(height: 20),
          _sectionLabel('ACCOUNT'),
          _card([
            _tapRow(
              icon: Icons.delete_outline_rounded,
              label: 'Delete account',
              value: '',
              danger: true,
              onTap: () => _confirmDelete(context),
            ),
          ]),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete your account?', style: AppFonts.inter(fontWeight: FontWeight.w700, fontSize: 17)),
        content: Text(
          'This will permanently delete your swiftree account, order history, and saved details. This cannot be undone.',
          style: AppFonts.inter(fontSize: 14, color: _mid),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: AppFonts.inter(fontWeight: FontWeight.w600, color: _mid))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account deletion requested. This is a demo action.', style: AppFonts.inter(color: Colors.white)),
                  backgroundColor: const Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Text('Delete', style: AppFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 4),
        child: Text(label, style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: _mid, letterSpacing: 0.8)),
      );

  Widget _card(List<Widget> children) => Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(children: children),
      );

  Widget _divider() => const Divider(height: 1, color: Color(0xFFF1F5F9));

  Widget _switchRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: onChanged,
      activeThumbColor: _primary,
      title: Text(title, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
      subtitle: Text(subtitle, style: AppFonts.inter(fontSize: 12, color: _mid)),
    );
  }

  Widget _tapRow({required IconData icon, required String label, required String value, VoidCallback? onTap, bool danger = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: danger ? const Color(0xFFEF4444) : _mid, size: 20),
      title: Text(label, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: danger ? const Color(0xFFEF4444) : _dark)),
      trailing: value.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: AppFonts.inter(fontSize: 13, color: _mid)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, color: _mid, size: 18),
              ],
            )
          : const Icon(Icons.chevron_right_rounded, color: _mid, size: 18),
      onTap: onTap,
    );
  }
}
