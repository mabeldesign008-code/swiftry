import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import '../models/review.dart';
import '../providers/reviews_provider.dart';

const Color _dark = Color(0xFF0F172A);
const Color _mid = Color(0xFF64748B);
const Color _border = Color(0xFFE8EDF2);
const Color _star = Color(0xFFF59E0B);

/// A vendor's public reviews — rating breakdown + list. Previously there
/// was no way to browse a vendor's reviews at all; only a post-order
/// "write a review" form existed.
///
/// Real reviews the current user has written for [vendorName] (via
/// `reviews_provider`) are merged with a few seeded demo reviews so the
/// screen isn't empty for vendors nobody has reviewed yet.
class VendorReviewsScreen extends ConsumerWidget {
  final String vendorName;
  final double vendorRating;

  const VendorReviewsScreen({super.key, required this.vendorName, this.vendorRating = 4.6});

  List<Review> get _seedReviews => [
        Review(
          id: 'seed-1',
          orderId: '',
          vendorName: vendorName,
          foodRating: 5,
          riderRating: 5,
          tags: const {'Great Food', 'Fast Delivery'},
          comment: 'Always consistent — great quality and packaging every time.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          authorName: 'Kwame A.',
        ),
        Review(
          id: 'seed-2',
          orderId: '',
          vendorName: vendorName,
          foodRating: 4,
          riderRating: 4.5,
          tags: const {'Good Portions'},
          comment: 'Good value, delivery took a little longer than expected.',
          createdAt: DateTime.now().subtract(const Duration(days: 6)),
          authorName: 'Abena O.',
        ),
        Review(
          id: 'seed-3',
          orderId: '',
          vendorName: vendorName,
          foodRating: 5,
          riderRating: 4,
          tags: const {'Would Recommend', 'Hot & Fresh'},
          comment: 'My go-to order every week!',
          createdAt: DateTime.now().subtract(const Duration(days: 12)),
          authorName: 'Yaw B.',
        ),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myReviews = ref.watch(reviewsProvider).where((r) => r.vendorName == vendorName).toList();
    final reviews = [...myReviews, ..._seedReviews];
    final avg = reviews.isEmpty ? vendorRating : reviews.fold(0.0, (s, r) => s + r.overallRating) / reviews.length;

    // Histogram of rounded overall ratings 1-5.
    final histogram = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in reviews) {
      final bucket = r.overallRating.round().clamp(1, 5);
      histogram[bucket] = (histogram[bucket] ?? 0) + 1;
    }
    final maxBucket = histogram.values.fold(1, (a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Reviews', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: _border, height: 1)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: _border)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(avg.toStringAsFixed(1), style: AppFonts.inter(fontSize: 36, fontWeight: FontWeight.w900, color: _dark)),
                    Row(
                      children: List.generate(5, (i) => Icon(
                            i < avg.round() ? Icons.star_rounded : Icons.star_border_rounded,
                            color: _star,
                            size: 16,
                          )),
                    ),
                    const SizedBox(height: 4),
                    Text('${reviews.length} reviews', style: AppFonts.inter(fontSize: 12, color: _mid)),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [5, 4, 3, 2, 1].map((star) {
                      final count = histogram[star] ?? 0;
                      final ratio = maxBucket == 0 ? 0.0 : count / maxBucket;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Text('$star', style: AppFonts.inter(fontSize: 11, color: _mid)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: ratio,
                                  minHeight: 6,
                                  backgroundColor: const Color(0xFFF1F5F9),
                                  color: _star,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...reviews.map((r) => _reviewTile(r)),
        ],
      ),
    );
  }

  Widget _reviewTile(Review r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundColor: const Color(0xFFEFF6FF), child: Text(r.authorName.isNotEmpty ? r.authorName[0] : '?', style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF0068FF)))),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.authorName, style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: _dark)),
                    Row(
                      children: List.generate(5, (i) => Icon(
                            i < r.overallRating.round() ? Icons.star_rounded : Icons.star_border_rounded,
                            color: _star,
                            size: 13,
                          )),
                    ),
                  ],
                ),
              ),
              Text(_relativeTime(r.createdAt), style: AppFonts.inter(fontSize: 11, color: _mid)),
            ],
          ),
          if (r.comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(r.comment, style: AppFonts.inter(fontSize: 13, color: const Color(0xFF334155), height: 1.4)),
          ],
          if (r.tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: r.tags.map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20)),
                    child: Text(t, style: AppFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    return 'Just now';
  }
}
