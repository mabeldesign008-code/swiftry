import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';

/// Reusable empty state widget for lists, tabs, and screens with no data.
/// Optionally shows a GIF/image, title, subtitle, and a CTA button.
class EmptyStateWidget extends StatelessWidget {
  final String? imagePath;
  final String title;
  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonTap;
  final Color? buttonColor;
  final double imageHeight;
  final bool isGif;

  const EmptyStateWidget({
    super.key,
    this.imagePath,
    required this.title,
    this.subtitle,
    this.buttonLabel,
    this.onButtonTap,
    this.buttonColor,
    this.imageHeight = 140,
    this.isGif = false,
  });

  // Convenience constructors for common cases
  factory EmptyStateWidget.notLoggedIn({
    required VoidCallback onLogin,
  }) {
    return EmptyStateWidget(
      imagePath: 'assets/images/login.gif',
      isGif: true,
      imageHeight: 140,
      title: 'Please Log In to Continue',
      subtitle: "You're not logged in. Sign in to access your account and explore all features.",
      buttonLabel: 'Log In',
      onButtonTap: onLogin,
    );
  }

  factory EmptyStateWidget.noOrders({VoidCallback? onExplore}) {
    return EmptyStateWidget(
      imagePath: 'assets/images/food_delivery.gif',
      isGif: true,
      imageHeight: 140,
      title: 'No Orders Yet',
      subtitle: 'Looks like you haven\'t placed any orders. Start exploring and order something delicious!',
      buttonLabel: onExplore != null ? 'Explore' : null,
      onButtonTap: onExplore,
    );
  }

  factory EmptyStateWidget.noFavourites({VoidCallback? onExplore}) {
    return EmptyStateWidget(
      imagePath: 'assets/images/offer_gif.gif',
      isGif: true,
      imageHeight: 140,
      title: 'No Favourites Yet',
      subtitle: 'Tap the heart icon on any restaurant or dish to save it here for quick access.',
      buttonLabel: onExplore != null ? 'Explore Restaurants' : null,
      onButtonTap: onExplore,
    );
  }

  factory EmptyStateWidget.noResults({String? query}) {
    return EmptyStateWidget(
      title: 'No Results Found',
      subtitle: query != null
          ? 'We couldn\'t find anything for "$query". Try a different search term.'
          : 'We couldn\'t find what you\'re looking for. Try adjusting your filters.',
    );
  }

  factory EmptyStateWidget.noRestaurantsInZone({
    required VoidCallback onChangeLocation,
  }) {
    return EmptyStateWidget(
      imagePath: 'assets/images/location.gif',
      isGif: true,
      imageHeight: 140,
      title: 'No Restaurants Found',
      subtitle: 'Currently, there are no available restaurants in your area. Try changing your location.',
      buttonLabel: 'Change Location',
      onButtonTap: onChangeLocation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (imagePath != null) ...[
              Image.asset(
                imagePath!,
                height: imageHeight,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
            ] else ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF5FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.inbox_outlined,
                  color: Color(0xFF0068FF),
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
                height: 1.3,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.6,
                ),
              ),
            ],
            if (buttonLabel != null && onButtonTap != null) ...[
              const SizedBox(height: 28),
              SizedBox(
                width: 220,
                height: 52,
                child: ElevatedButton(
                  onPressed: onButtonTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor ?? const Color(0xFF0068FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    buttonLabel!,
                    style: AppFonts.inter(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
