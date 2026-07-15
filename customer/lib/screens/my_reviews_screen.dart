import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import '../models/review.dart';
import '../providers/reviews_provider.dart';

const Color _dark = Color(0xFF0F172A);
const Color _mid = Color(0xFF64748B);
const Color _border = Color(0xFFE8EDF2);
const Color _star = Color(0xFFF59E0B);

/// Reviews the current user has written. Previously Profile → "My Reviews"
/// opened `RateReviewScreen()` with no arguments — a blank "write a review"
/// form, not a list of anything the user had actually written.
class MyReviewsScreen extends ConsumerWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(reviewsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('My Reviews', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: _border, height: 1)),
      ),
      body: reviews.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(color: Color(0xFFE2E8F0), shape: BoxShape.circle),
                    child: const Icon(Icons.star_outline_rounded, size: 48, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 16),
                  Text('No reviews yet', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
                  const SizedBox(height: 8),
                  Text('Reviews you write after delivery will show up here.', style: AppFonts.inter(fontSize: 14, color: _mid)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reviews.length,
              itemBuilder: (context, i) => _tile(reviews[i]),
            ),
    );
  }

  Widget _tile(Review r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(r.vendorName, style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: _dark))),
              Text(_formatDate(r.createdAt), style: AppFonts.inter(fontSize: 11, color: _mid)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Row(children: List.generate(5, (i) => Icon(i < r.overallRating.round() ? Icons.star_rounded : Icons.star_border_rounded, color: _star, size: 16))),
              if (r.tip > 0) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(10)),
                  child: Text('Tipped ₵${r.tip.toStringAsFixed(0)}', style: AppFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF16A34A))),
                ),
              ],
            ],
          ),
          if (r.comment.isNotEmpty) ...[
            const SizedBox(height: 8),
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

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}
