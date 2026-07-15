import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_type.dart';

// ── Notification type ─────────────────────────────────────────────────────

enum NotificationType { orderUpdate, promo, system, riderUpdate }

extension NotificationTypeX on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.orderUpdate:
        return Icons.shopping_bag_outlined;
      case NotificationType.promo:
        return Icons.local_offer_outlined;
      case NotificationType.system:
        return Icons.verified_outlined;
      case NotificationType.riderUpdate:
        return Icons.delivery_dining_outlined;
    }
  }

  Color get iconColor {
    switch (this) {
      case NotificationType.orderUpdate:
        return const Color(0xFF0068FF);
      case NotificationType.promo:
        return const Color(0xFFF59E0B);
      case NotificationType.system:
        return const Color(0xFF8B5CF6);
      case NotificationType.riderUpdate:
        return const Color(0xFF16A34A);
    }
  }

  Color get iconBg {
    switch (this) {
      case NotificationType.orderUpdate:
        return const Color(0xFFEFF5FF);
      case NotificationType.promo:
        return const Color(0xFFFEF3C7);
      case NotificationType.system:
        return const Color(0xFFF5F3FF);
      case NotificationType.riderUpdate:
        return const Color(0xFFF0FDF4);
    }
  }
}

// ── Model ─────────────────────────────────────────────────────────────────

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? orderId;
  final NotificationType type;
  final ServiceType? serviceType;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.orderId,
    this.type = NotificationType.orderUpdate,
    this.serviceType,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        body: body,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
        orderId: orderId,
        type: type,
        serviceType: serviceType,
      );

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────

class NotificationsNotifier extends Notifier<List<AppNotification>> {
  @override
  List<AppNotification> build() => [
        // Seed with a couple of pre-existing promos so the screen isn't empty
        AppNotification(
          id: 'promo-welcome',
          title: 'Welcome to swiftree! 🎉',
          body: 'Your first order gets free delivery. Use code WELCOME15.',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
          type: NotificationType.promo,
        ),
        AppNotification(
          id: 'promo-weekend',
          title: '30% Off This Weekend!',
          body: 'Get 30% off your next food order. Use code YEND30 at checkout.',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: true,
          type: NotificationType.promo,
        ),
      ];

  void add(AppNotification notification) {
    state = [notification, ...state];
  }

  void markRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n,
    ];
  }

  void markAllRead() {
    state = [for (final n in state) n.copyWith(isRead: true)];
  }

  void dismiss(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  void clearAll() => state = [];

  int get unreadCount => state.where((n) => !n.isRead).length;
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<AppNotification>>(
        NotificationsNotifier.new);

/// Convenience derived provider — just the unread count, so widgets that only
/// need the badge don't rebuild on every notification content change.
final notificationUnreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((n) => !n.isRead).length;
});
