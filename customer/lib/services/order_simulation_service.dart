import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../models/service_type.dart';
import '../providers/active_order_provider.dart';
import '../providers/notifications_provider.dart';
import '../providers/order_history_provider.dart';
import '../providers/rider_location_provider.dart';
import '../widgets/notification_overlay.dart';

// ── Step definition ───────────────────────────────────────────────────────

class _SimStep {
  final int delaySeconds;       // seconds after the PREVIOUS step
  final OrderStatus status;
  final String statusMessage;   // shown in active-order banner + tracking card
  final String notifTitle;
  final String notifBody;
  final NotificationType notifType;
  final bool startRiderMovement; // triggers riderLocationProvider journey

  const _SimStep({
    required this.delaySeconds,
    required this.status,
    required this.statusMessage,
    required this.notifTitle,
    required this.notifBody,
    this.notifType = NotificationType.orderUpdate,
    this.startRiderMovement = false,
  });
}

// ── Steps per service type ────────────────────────────────────────────────

List<_SimStep> _stepsFor(ServiceType t, String vendorName) {
  switch (t) {
    case ServiceType.laundry:
      return [
        _SimStep(
          delaySeconds: 5,
          status: OrderStatus.confirmed,
          statusMessage: 'Order confirmed! Rider is on the way to collect',
          notifTitle: 'Order Confirmed',
          notifBody: 'Your laundry order has been confirmed.',
        ),
        _SimStep(
          delaySeconds: 12,
          status: OrderStatus.inTransit,
          statusMessage: 'Rider heading to you for pickup',
          notifTitle: 'Rider Assigned',
          notifBody: 'Kwame A. is on the way to collect your laundry.',
          notifType: NotificationType.riderUpdate,
          startRiderMovement: true,
        ),
        _SimStep(
          delaySeconds: 18,
          status: OrderStatus.processing,
          statusMessage: 'Laundry picked up — being processed at CleanPro',
          notifTitle: 'Laundry Picked Up',
          notifBody: 'Your clothes are now being washed at CleanPro Laundry.',
        ),
        _SimStep(
          delaySeconds: 25,
          status: OrderStatus.inTransit,
          statusMessage: 'Clean laundry on the way back to you!',
          notifTitle: 'Return Trip Started',
          notifBody: 'Your clean laundry is heading back to you now.',
          notifType: NotificationType.riderUpdate,
          startRiderMovement: true,
        ),
        _SimStep(
          delaySeconds: 20,
          status: OrderStatus.delivered,
          statusMessage: 'Laundry delivered! Fresh and clean 🧺',
          notifTitle: 'Laundry Delivered!',
          notifBody: 'Your clean laundry has been delivered. Enjoy!',
        ),
      ];

    case ServiceType.errand:
    case ServiceType.market:
      return [
        _SimStep(
          delaySeconds: 5,
          status: OrderStatus.confirmed,
          statusMessage: 'Order confirmed! Agent is heading to location',
          notifTitle: 'Order Confirmed',
          notifBody: 'Your ${t.label.toLowerCase()} request has been confirmed.',
        ),
        _SimStep(
          delaySeconds: 10,
          status: OrderStatus.inTransit,
          statusMessage: 'Agent assigned — on the way',
          notifTitle: 'Agent Assigned',
          notifBody: 'Ama B. (⭐ 4.9) is heading to the location now.',
          notifType: NotificationType.riderUpdate,
          startRiderMovement: true,
        ),
        _SimStep(
          delaySeconds: 20,
          status: OrderStatus.processing,
          statusMessage: 'Agent at location — completing your task',
          notifTitle: 'Agent at Location',
          notifBody: 'Your agent is at the location completing your request.',
        ),
        _SimStep(
          delaySeconds: 22,
          status: OrderStatus.delivered,
          statusMessage: 'Task completed! ✅',
          notifTitle: 'Task Completed!',
          notifBody: 'Your ${t.label.toLowerCase()} task has been completed.',
        ),
      ];

    case ServiceType.bill:
      return [
        _SimStep(
          delaySeconds: 3,
          status: OrderStatus.confirmed,
          statusMessage: 'Payment processing…',
          notifTitle: 'Processing Payment',
          notifBody: 'Your bill payment is being processed.',
        ),
        _SimStep(
          delaySeconds: 6,
          status: OrderStatus.delivered,
          statusMessage: 'Payment successful! ✅',
          notifTitle: 'Payment Successful!',
          notifBody: 'Your bill payment was processed successfully.',
        ),
      ];

    case ServiceType.queue:
      return [
        _SimStep(
          delaySeconds: 5,
          status: OrderStatus.confirmed,
          statusMessage: 'Agent confirmed — heading to queue',
          notifTitle: 'Agent Confirmed',
          notifBody: 'Your queue agent is heading to the location.',
        ),
        _SimStep(
          delaySeconds: 12,
          status: OrderStatus.inTransit,
          statusMessage: 'Agent in queue — position 4',
          notifTitle: 'Agent in Queue',
          notifBody: 'Your agent has joined the queue (position 4 of 7).',
          notifType: NotificationType.riderUpdate,
        ),
        _SimStep(
          delaySeconds: 20,
          status: OrderStatus.processing,
          statusMessage: 'Almost there — position 1!',
          notifTitle: 'Almost Done',
          notifBody: 'Your agent is next in line!',
          notifType: NotificationType.riderUpdate,
        ),
        _SimStep(
          delaySeconds: 15,
          status: OrderStatus.delivered,
          statusMessage: 'Queue service completed! ✅',
          notifTitle: 'Service Completed!',
          notifBody: 'Your queue service task has been completed.',
        ),
      ];

    default:
      // food, groceries, pharmacy, shop, parcel
      return [
        _SimStep(
          delaySeconds: 5,
          status: OrderStatus.confirmed,
          statusMessage: '$vendorName is preparing your order',
          notifTitle: 'Order Confirmed',
          notifBody: '$vendorName has accepted your order and is preparing it.',
        ),
        _SimStep(
          delaySeconds: 10,
          status: OrderStatus.inTransit,
          statusMessage: 'Rider assigned — heading to $vendorName',
          notifTitle: 'Rider Assigned',
          notifBody: 'Kwame A. (⭐ 4.8) has been assigned to your order.',
          notifType: NotificationType.riderUpdate,
          startRiderMovement: true,
        ),
        _SimStep(
          delaySeconds: 15,
          status: OrderStatus.inTransit,
          statusMessage: 'Rider at store — picking up your order',
          notifTitle: 'Rider at Store',
          notifBody: 'Your rider is at $vendorName collecting your order.',
          notifType: NotificationType.riderUpdate,
        ),
        _SimStep(
          delaySeconds: 18,
          status: OrderStatus.inTransit,
          statusMessage: 'Rider heading to you — almost there!',
          notifTitle: 'On the Way!',
          notifBody: 'Your order is on its way. Arriving in ~8 minutes.',
          notifType: NotificationType.riderUpdate,
        ),
        _SimStep(
          delaySeconds: 20,
          status: OrderStatus.delivered,
          statusMessage: 'Order delivered! Enjoy 🎉',
          notifTitle: 'Order Delivered!',
          notifBody: 'Your order from $vendorName has arrived. Enjoy!',
        ),
      ];
  }
}

// ── Service ───────────────────────────────────────────────────────────────

class OrderSimulationService {
  /// Starts the auto-progression for [order]. Call immediately after
  /// `orderHistoryProvider.placeOrder(order)` in CheckoutScreen.
  ///
  /// [context] is needed for the in-app overlay. It must be a context that
  /// has an [Overlay] ancestor (any screen context satisfies this).
  static void start({
    required WidgetRef ref,
    required BuildContext context,
    required Order order,
  }) {
    final steps = _stepsFor(order.serviceType, order.vendorName);
    _scheduleSteps(ref, context, order.id, order.serviceType, steps, 0);
  }

  static void _scheduleSteps(
    WidgetRef ref,
    BuildContext context,
    String orderId,
    ServiceType serviceType,
    List<_SimStep> steps,
    int index,
  ) {
    if (index >= steps.length) return;
    final step = steps[index];

    Timer(Duration(seconds: step.delaySeconds), () {
      // Guard: context might be gone if user force-navigated away
      if (!context.mounted) return;

      // 1. Update order status in history
      ref.read(orderHistoryProvider.notifier).updateStatus(orderId, step.status);

      // 2. Update active order banner message
      ref.read(activeOrderProvider.notifier).updateStatus(step.statusMessage);

      // 3. Start rider map movement if this step triggers it
      if (step.startRiderMovement) {
        ref.read(riderLocationProvider.notifier).startJourney();
      }

      // 4. Add to notification inbox
      final notif = AppNotification(
        id: '${orderId}_step_$index',
        title: step.notifTitle,
        body: step.notifBody,
        createdAt: DateTime.now(),
        orderId: orderId,
        type: step.notifType,
        serviceType: serviceType,
      );
      ref.read(notificationsProvider.notifier).add(notif);

      // 5. Show in-app overlay toast
      NotificationOverlay.show(
        context,
        title: step.notifTitle,
        body: step.notifBody,
        type: step.notifType,
      );

      // 6. When delivered, clear the active order banner
      if (step.status == OrderStatus.delivered) {
        ref.read(activeOrderProvider.notifier).clearOrder();
      }

      // 7. Schedule the next step
      _scheduleSteps(ref, context, orderId, serviceType, steps, index + 1);
    });
  }
}
