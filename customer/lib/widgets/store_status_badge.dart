import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/store_status_provider.dart';
import '../core/theme/app_fonts.dart';

/// Small pill badge showing Open / Closing Soon / Closed.
/// Watches [storeStatusProvider] so it updates live every minute.
class StoreStatusBadge extends ConsumerWidget {
  const StoreStatusBadge({
    super.key,
    required this.vendorName,
    this.compact = false,
  });

  final String vendorName;
  /// [compact] = icon only (for tight spaces like the hero image overlay).
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(storeStatusProvider(vendorName));
    if (compact) {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: status.color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, color: status.color, size: 11),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: AppFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width banner shown at the top of a vendor/restaurant screen
/// when the store is closed or closing soon.
class StoreClosedBanner extends ConsumerWidget {
  const StoreClosedBanner({super.key, required this.vendorName});
  final String vendorName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(storeStatusProvider(vendorName));
    if (status == StoreStatus.open) return const SizedBox.shrink();

    final isClosed = status == StoreStatus.closed;
    final bg    = isClosed ? const Color(0xFFFEF2F2) : const Color(0xFFFEF9C3);
    final fg    = isClosed ? const Color(0xFFDC2626) : const Color(0xFFD97706);
    final icon  = isClosed ? Icons.store_outlined : Icons.schedule_rounded;
    final title = isClosed ? 'Store is currently closed' : 'Store is closing soon';
    final sub   = isClosed
        ? nextOpenLabel(vendorName)
        : 'You can still place an order now';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        border: Border(bottom: BorderSide(color: fg.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: fg)),
                Text(sub,
                    style: AppFonts.inter(
                        fontSize: 12, color: fg.withOpacity(0.8))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
