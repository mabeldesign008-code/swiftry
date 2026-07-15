class VendorStoryPost {
  final String id;
  final String mediaUrl;
  final MediaType mediaType;
  final String? caption;
  final String? productName;
  final double? price;
  final DateTime createdAt;
  final Duration duration;

  VendorStoryPost({
    required this.id,
    required this.mediaUrl,
    required this.mediaType,
    this.caption,
    this.productName,
    this.price,
    required this.createdAt,
    this.duration = const Duration(seconds: 5),
  });
}

enum MediaType {
  image,
  video,
}

class VendorStory {
  final String vendorId;
  final String vendorName;
  final String vendorImage;
  final List<VendorStoryPost> posts;
  final bool isViewed;

  VendorStory({
    required this.vendorId,
    required this.vendorName,
    required this.vendorImage,
    required this.posts,
    this.isViewed = false,
  });

  bool get hasActivePosts {
    final now = DateTime.now();
    return posts.any((post) => 
      now.difference(post.createdAt).inHours < 24
    );
  }

  List<VendorStoryPost> get activePosts {
    final now = DateTime.now();
    return posts.where((post) => 
      now.difference(post.createdAt).inHours < 24
    ).toList();
  }
}