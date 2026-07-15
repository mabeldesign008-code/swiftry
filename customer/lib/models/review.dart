/// A review the user has submitted for a completed order — powers both
/// "My Reviews" (in Profile) and a vendor's public review list.
class Review {
  final String id;
  final String orderId;
  final String vendorName;
  final double foodRating; // or "service rating" for non-food orders
  final double riderRating;
  final Set<String> tags;
  final String comment;
  final double tip;
  final DateTime createdAt;
  final String authorName;

  const Review({
    required this.id,
    required this.orderId,
    required this.vendorName,
    required this.foodRating,
    required this.riderRating,
    this.tags = const {},
    this.comment = '',
    this.tip = 0,
    required this.createdAt,
    this.authorName = 'You',
  });

  /// Overall rating shown in list views — average of food/service + rider.
  double get overallRating => ((foodRating + riderRating) / 2);
}
