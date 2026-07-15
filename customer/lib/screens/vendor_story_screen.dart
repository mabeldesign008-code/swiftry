import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/theme/app_fonts.dart';
import '../models/vendor_story.dart';
import '../widgets/animated_press.dart';
import 'vendor_store_screen.dart';
import 'restaurant_screen.dart';
import 'food_detail_screen.dart';

class VendorStoryScreen extends StatefulWidget {
  final List<VendorStory> allVendorStories;
  final int initialVendorIndex;
  final int initialPostIndex;

  const VendorStoryScreen({
    super.key,
    required this.allVendorStories,
    required this.initialVendorIndex,
    this.initialPostIndex = 0,
  });

  @override
  State<VendorStoryScreen> createState() => _VendorStoryScreenState();
}

class _VendorStoryScreenState extends State<VendorStoryScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  int _currentVendorIndex = 0;
  int _currentPostIndex = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _currentVendorIndex = widget.initialVendorIndex;
    _currentPostIndex = widget.initialPostIndex;
    _pageController = PageController(initialPage: _currentPostIndex);
    _progressController = AnimationController(
      duration: const Duration(seconds: 8), // Increased from 5 to 8 seconds
      vsync: this,
    );
    _startProgress();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  VendorStory get currentVendor => widget.allVendorStories[_currentVendorIndex];
  List<VendorStoryPost> get currentPosts => currentVendor.activePosts;

  void _startProgress() {
    if (_isPaused) return;
    
    _progressController.forward().then((_) {
      if (!_isPaused && mounted) {
        _nextPost();
      }
    });
  }

  void _pauseProgress() {
    setState(() => _isPaused = true);
    _progressController.stop();
  }

  void _resumeProgress() {
    setState(() => _isPaused = false);
    _startProgress();
  }

  void _nextPost() {
    if (_currentPostIndex < currentPosts.length - 1) {
      setState(() => _currentPostIndex++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _progressController.reset();
      _startProgress();
    } else {
      _nextVendor();
    }
  }

  void _nextVendor() {
    if (_currentVendorIndex < widget.allVendorStories.length - 1) {
      setState(() {
        _currentVendorIndex++;
        _currentPostIndex = 0;
      });
      _pageController = PageController();
      _progressController.reset();
      _startProgress();
    } else {
      _closeStory();
    }
  }

  void _previousPost() {
    if (_currentPostIndex > 0) {
      setState(() => _currentPostIndex--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _progressController.reset();
      _startProgress();
    } else {
      _previousVendor();
    }
  }

  void _previousVendor() {
    if (_currentVendorIndex > 0) {
      setState(() {
        _currentVendorIndex--;
        _currentPostIndex = widget.allVendorStories[_currentVendorIndex].activePosts.length - 1;
      });
      _pageController = PageController(initialPage: _currentPostIndex);
      _progressController.reset();
      _startProgress();
    }
  }

  void _closeStory() {
    Navigator.of(context).pop();
  }

  void _navigateToVendorStore() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RestaurantScreen(
          restaurantData: {
            'img': currentVendor.vendorImage,
            'name': currentVendor.vendorName,
            'cat': 'Restaurant',
            'time': '25 mins',
            'fee': '₵10 Delivery',
            'rating': '4.7',
            'price': '₵35'
          },
        ),
      ),
    );
  }

  void _navigateToFoodDetail() {
    final currentPost = currentPosts[_currentPostIndex];
    if (currentPost.productName != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FoodDetailScreen(
            title: currentPost.productName!,
            price: currentPost.price ?? 45.00,
            imageUrl: currentPost.mediaUrl,
            description: currentPost.caption ?? 'Delicious food from ${currentVendor.vendorName}',
            restaurantId: currentVendor.vendorId,
            restaurantName: currentVendor.vendorName,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentPosts.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.clock,
                color: Colors.white54,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'No active stories',
                style: AppFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Stories expire after 24 hours',
                style: AppFonts.inter(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth * 0.3) {
            _previousPost();
          } else if (details.globalPosition.dx > screenWidth * 0.7) {
            _nextPost();
          }
        },
        onLongPressStart: (_) => _pauseProgress(),
        onLongPressEnd: (_) => _resumeProgress(),
        onVerticalDragEnd: (details) {
          // Handle swipe up gesture
          if (details.primaryVelocity != null && details.primaryVelocity! < -500) {
            _navigateToVendorStore();
          }
        },
        child: Stack(
          children: [
            // Background image/video - full screen
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentPosts.length,
              onPageChanged: (index) {
                setState(() => _currentPostIndex = index);
              },
              itemBuilder: (context, index) {
                final post = currentPosts[index];
                return Container(
                  child: post.mediaType == MediaType.image 
                    ? Image.asset(
                        post.mediaUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(
                                LucideIcons.image,
                                color: Colors.white54,
                                size: 64,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.black,
                        child: Stack(
                          children: [
                            // Placeholder for video - you can replace this with actual video player
                            Image.asset(
                              post.mediaUrl, // For now, treat as image until video player is added
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[800],
                                  child: const Center(
                                    child: Icon(
                                      LucideIcons.play,
                                      color: Colors.white54,
                                      size: 64,
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Video play indicator
                            const Center(
                              child: Icon(
                                LucideIcons.play,
                                color: Colors.white70,
                                size: 80,
                              ),
                            ),
                          ],
                        ),
                      ),
                );
              },
            ),

            // Gradient overlays for readability
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 168,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 268,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            
            // Progress indicators - exact Figma design
            Positioned(
              top: 60,
              left: 16,
              right: 16,
              child: Row(
                children: List.generate(
                  currentPosts.length,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(
                        right: index < currentPosts.length - 1 ? 6 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          double progress = 0.0;
                          if (index < _currentPostIndex) {
                            progress = 1.0;
                          } else if (index == _currentPostIndex) {
                            progress = _progressController.value;
                          }
                          
                          return FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                color: index == _currentPostIndex ? const Color(0xFF0052CC) : Colors.white,
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Header with vendor info - exact Figma design
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _navigateToVendorStore,
                    child: Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0052CC), width: 2),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          currentVendor.vendorImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                LucideIcons.user,
                                color: Colors.white,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _navigateToVendorStore,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentVendor.vendorName,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.35,
                            ),
                          ),
                          Text(
                            _getTimeAgo(currentPosts[_currentPostIndex].createdAt),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color.fromRGBO(255, 255, 255, 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedPress(
                    onTap: _closeStory,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.x,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom content - exact Figma design
            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (currentPosts[_currentPostIndex].productName != null)
                          Text(
                            currentPosts[_currentPostIndex].productName!,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.25,
                            ),
                          ),
                        const SizedBox(height: 4),
                        if (currentPosts[_currentPostIndex].caption != null)
                          Text(
                            currentPosts[_currentPostIndex].caption!,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                              height: 1.43,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Order Now button - exact Figma design
                  if (currentPosts[_currentPostIndex].productName != null)
                    AnimatedPress(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _navigateToFoodDetail();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0052CC),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0052CC).withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: const Color(0xFF0052CC).withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.shoppingCart,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Order Now',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 19.2,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: -0.46,
                                  height: 1.35,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'GHS ${currentPosts[_currentPostIndex].price?.toInt() ?? 45}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  
                  // Swipe up indicator
                  GestureDetector(
                    onTap: _navigateToVendorStore,
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            LucideIcons.chevronUp,
                            color: Colors.white.withOpacity(0.4),
                            size: 12,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'SWIPE UP TO VIEW MENU',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.4),
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}