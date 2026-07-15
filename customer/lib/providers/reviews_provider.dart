import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/review.dart';

/// Reviews the current user has written. Powers "My Reviews" in Profile and
/// is merged into a vendor's public review list so a review you just wrote
/// shows up immediately when browsing that vendor's reviews.
///
/// Previously Profile's "My Reviews" opened the write-a-review form itself
/// (with no order context) instead of showing anything the user had written.
class ReviewsNotifier extends Notifier<List<Review>> {
  @override
  List<Review> build() => [];

  void addReview(Review review) {
    state = [review, ...state];
  }

  List<Review> forVendor(String vendorName) =>
      state.where((r) => r.vendorName == vendorName).toList();
}

final reviewsProvider = NotifierProvider<ReviewsNotifier, List<Review>>(ReviewsNotifier.new);
