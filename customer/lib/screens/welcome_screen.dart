import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../core/constants/app_constants.dart';
import 'onboarding_screen.dart';
import 'get_started_screen.dart';
import 'home_screen_v2.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    // Fade-in animation for logo + tagline.
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    // Auto-navigate after splash completes.
    Future.delayed(const Duration(seconds: 3), _navigate);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final destination = await _resolveDestination();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  /// Returns the correct first screen based on session state.
  Future<Widget> _resolveDestination() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone =
        prefs.getBool(AppConstants.prefKeyOnboardingDone) ?? false;
    final loggedIn =
        prefs.getBool(AppConstants.prefKeyUserLoggedIn) ?? false;

    if (!onboardingDone) return const OnboardingScreen();
    if (loggedIn) return const HomeScreenV2();
    return const GetStartedScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigate,
        child: SizedBox.expand(
          child: Stack(
            children: [
              // ── Top-left decorative pill ────────────────────────────
              Positioned(
                left: -112,
                top: -31,
                width: 325,
                height: 364,
                child: Center(
                  child: Transform.rotate(
                    angle: 38.56 * math.pi / 180,
                    child: Container(
                      width: 125,
                      height: 366,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x006978A0),
                            Color(0x4DFFFFFF),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Bottom-right decorative pill ────────────────────────
              Positioned(
                left: 200,
                top: 333,
                width: 325,
                height: 364,
                child: Center(
                  child: Transform.rotate(
                    angle: 38.56 * math.pi / 180,
                    child: Container(
                      width: 125,
                      height: 366,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x4D6978A0),
                            Color(0x00FFFFFF),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Main content (fades in) ──────────────────────────────
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    children: [
                      const Spacer(flex: 12),
                      // Logo
                      Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 140,
                          height: 147,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Spacer(flex: 15),
                      // Tagline
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Opacity(
                          opacity: 0.60,
                          child: Text(
                            'Food, groceries, pharmacy, parcel, errands '
                            'and more — all in one app!',
                            textAlign: TextAlign.center,
                            style: AppFonts.inter(
                              color: const Color(0xFFD8DDE2),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
