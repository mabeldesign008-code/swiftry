import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class VendorNotification {
  final int id;
  final String section;
  final String title;
  final String body;
  final String time;
  final bool unread;
  final Color bgColor;
  final Color iconColor;
  final String type;

  VendorNotification({
    required this.id,
    required this.section,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
    required this.bgColor,
    required this.iconColor,
    required this.type,
  });

  VendorNotification copyWith({bool? unread}) {
    return VendorNotification(
      id: id,
      section: section,
      title: title,
      body: body,
      time: time,
      unread: unread ?? this.unread,
      bgColor: bgColor,
      iconColor: iconColor,
      type: type,
    );
  }
}

class VendorNotificationsScreen extends StatefulWidget {
  const VendorNotificationsScreen({super.key});

  @override
  State<VendorNotificationsScreen> createState() => _VendorNotificationsScreenState();
}

class _VendorNotificationsScreenState extends State<VendorNotificationsScreen> {
  late List<VendorNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      VendorNotification(
        id: 1, section: 'today', type: 'order', unread: true,
        title: 'New Order received (#YDO-78430)',
        body: 'A customer just placed an order for 3 items. Total: ₵45.00.',
        time: '2m ago', bgColor: const Color(0x1A0052CC), iconColor: const Color(0xFF0052CC),
      ),
      VendorNotification(
        id: 2, section: 'today', type: 'pickup', unread: true,
        title: 'Order Update (picked up)',
        body: 'Order #YDO-78430 has been picked up by the delivery partner.',
        time: '1h ago', bgColor: const Color(0xFFFFEDD5), iconColor: const Color(0xFFEA580C),
      ),
      VendorNotification(
        id: 3, section: 'today', type: 'review', unread: true,
        title: 'New Review from Kofi M',
        body: '"Excellent service and fast delivery! Will definitely order again."',
        time: '3h ago', bgColor: const Color(0xFFFEF9C3), iconColor: const Color(0xFFCA8A04),
      ),
      VendorNotification(
        id: 4, section: 'yesterday', type: 'settlement', unread: false,
        title: 'Settlement processed',
        body: 'Your settlement of ₵1,240.50 for last week has been processed.',
        time: '1d ago', bgColor: const Color(0xFFDCFCE7), iconColor: const Color(0xFF16A34A),
      ),
      VendorNotification(
        id: 5, section: 'yesterday', type: 'alert', unread: true,
        title: 'Subscription renewal alert',
        body: 'Your Vendor Pro subscription expires in 3 days. Renew now to avoid interruption.',
        time: '1d ago', bgColor: const Color(0xFFFEE2E2), iconColor: const Color(0xFFDC2626),
      ),
    ];
  }

  void _markAllRead() {
    setState(() {
      _notifications = _notifications.map((n) => n.copyWith(unread: false)).toList();
    });
  }

  void _markRead(int id) {
    setState(() {
      _notifications = _notifications.map((n) => n.id == id ? n.copyWith(unread: false) : n).toList();
    });
  }

  Widget _buildIcon(String type, Color bgColor, Color iconColor) {
    IconData iconData;
    switch (type) {
      case 'order': iconData = LucideIcons.shoppingCart; break;
      case 'pickup': iconData = LucideIcons.package; break;
      case 'review': iconData = LucideIcons.star; break;
      case 'settlement': iconData = LucideIcons.wallet; break;
      case 'alert': iconData = LucideIcons.creditCard; break;
      default: iconData = LucideIcons.bell;
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
      alignment: Alignment.center,
      child: Icon(iconData, size: 20, color: iconColor),
    );
  }

  Widget _buildList(List<VendorNotification> items) {
    return Column(
      children: items.map((n) {
        return Material(
          color: n.unread ? const Color(0xFFFAFBFF) : Colors.white,
          child: InkWell(
            onTap: () => _markRead(n.id),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF8FAFC))),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIcon(n.type, n.bgColor, n.iconColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                n.title,
                                style: AppTextStyles.subtitle.copyWith(
                                  fontWeight: n.unread ? FontWeight.bold : FontWeight.w600,
                                  color: n.unread ? AppColors.textPrimary : const Color(0xFF334155),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                Text(n.time, style: AppTextStyles.caption.copyWith(fontSize: 11, color: const Color(0xFF94A3B8))),
                                if (n.unread) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                  ),
                                ]
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          n.body,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = _notifications.where((n) => n.section == 'today').toList();
    final yesterday = _notifications.where((n) => n.section == 'yesterday').toList();
    final hasUnread = _notifications.any((n) => n.unread);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Notifications', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
        actions: [
          if (hasUnread)
            TextButton(
              onPressed: _markAllRead,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: AppTextStyles.subtitleMedium,
              ),
              child: const Text('Mark all read'),
            ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: const Color(0xFFF8FAFC),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'TODAY',
                style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8), letterSpacing: 1),
              ),
            ),
            _buildList(today),
            Container(
              color: const Color(0xFFF8FAFC),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              child: Text(
                'YESTERDAY',
                style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8), letterSpacing: 1),
              ),
            ),
            _buildList(yesterday),
          ],
        ),
      ),
    );
  }
}
