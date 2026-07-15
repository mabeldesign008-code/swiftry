import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import 'get_started_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      image: 'assets/images/splash1.png',
      titleSpans: [
        const TextSpan(text: 'Food and '),
        const TextSpan(
          text: 'Shopping',
          style: TextStyle(color: Color(0xFF0088FF)),
        ),
        const TextSpan(text: ' made Easy'),
      ],
      subtitle: 'Order meals, market items, and shop products from nearby stores.',
    ),
    _OnboardingPage(
      image: 'assets/images/splash2.png',
      titleSpans: [
        const TextSpan(text: 'Your Daily '),
        const TextSpan(
          text: 'Essentials',
          style: TextStyle(color: Color(0xFF0088FF)),
        ),
        const TextSpan(text: ' Delivered'),
      ],
      subtitle:
          'Get pharmacy, laundry, school, and business services with ease.',
    ),
    _OnboardingPage(
      image: 'assets/images/splash3.png',
      titleSpans: [
        const TextSpan(text: 'We run '),
        const TextSpan(
          text: 'Errands',
          style: TextStyle(color: Color(0xFF0088FF)),
        ),
        const TextSpan(text: ' for You'),
      ],
      subtitle: 'Send parcels, move items and complete tasks without stress.',
    ),
    _OnboardingPage(
      image: 'assets/images/splash4.png',
      titleSpans: [
        const TextSpan(text: 'Send and Receive '),
        const TextSpan(
          text: 'Parcels',
          style: TextStyle(color: Color(0xFF0088FF)),
        ),
        const TextSpan(text: ' Fast'),
      ],
      subtitle:
          'Deliver packages across town safely and on time. We handle all that for you.',
    ),
  ];

  bool get _isLastPage => _currentIndex == _pages.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefKeyOnboardingDone, true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GetStartedScreen()),
    );
  }

  void _onSkip() => _finish();

  void _onContinue() {
    if (_isLastPage) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: AppConstants.animNormal,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Skip button (hidden on last page) ─────────────────────
            if (!_isLastPage)
              Positioned(
                top: 8,
                right: 8,
                child: TextButton(
                  onPressed: _onSkip,
                  child: Text(
                    'Skip',
                    style: AppFonts.inter(
                      color: const Color(0xFF8A8A8E),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

            // ── PageView ──────────────────────────────────────────────
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentIndex = index),
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              Image.asset(
                                page.image,
                                height: 350,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 40),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: AppFonts.inter(
                                    color: const Color(0xFF1B1B1B),
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                    letterSpacing: -1,
                                  ),
                                  children: page.titleSpans,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                page.subtitle,
                                textAlign: TextAlign.center,
                                style: AppFonts.inter(
                                  color: const Color(0xFF8A8A8E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Bottom controls ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 32.0, left: 32.0, right: 32.0),
                  child: Column(
                    children: [
                      // Pagination dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_pages.length, (index) {
                          final isActive = index == _currentIndex;
                          return AnimatedContainer(
                            duration: AppConstants.animNormal,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 4,
                            width: isActive ? 32 : 16,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF2F74FA)
                                  : const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 40),
                      // Continue / Get Started button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _onContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0068FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _isLastPage ? 'Get Started' : 'Continue',
                            style: AppFonts.inter(
                              color: Colors.white,
                              fontSize: 19.2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final String image;
  final List<TextSpan> titleSpans;
  final String subtitle;

  const _OnboardingPage({
    required this.image,
    required this.titleSpans,
    required this.subtitle,
  });
}
