import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';

const Color _primary = Color(0xFF0068FF);
const Color _dark = Color(0xFF0F172A);
const Color _mid = Color(0xFF64748B);

/// Generic "you're offline" state. This app has no real network calls to
/// fail (it's a frontend-only prototype), so nothing triggers this screen
/// automatically yet — wire `onRetry` to an actual connectivity/API check
/// once there's a backend. It's included so the app has a ready-made offline
/// state instead of silently hanging or crashing when that day comes.
class NoConnectionScreen extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoConnectionScreen({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), shape: BoxShape.circle),
                child: const Icon(Icons.wifi_off_rounded, color: _primary, size: 56),
              ),
              const SizedBox(height: 28),
              Text(
                'No internet connection',
                style: AppFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: _dark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Check your Wi-Fi or mobile data and try again. Your cart and order history are saved.',
                style: AppFonts.inter(fontSize: 14, color: _mid, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onRetry ?? () => Navigator.maybePop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.refresh_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text('Try Again', style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
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
