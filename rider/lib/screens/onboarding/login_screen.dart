import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../models/rider.dart';
import '../../providers/rider_provider.dart';
import '../home/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _onLogin() async {
    if (_phoneCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter phone number')));
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Mock

    // TODO Backend: Replace with real OTP request POST /rider/auth/otp/send
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Mock rider creation
    ref.read(riderProvider.notifier).setRider(Rider(
      id: 'rider_${_phoneCtrl.text.hashCode}',
      name: 'Kwame Asante',
      phone: _phoneCtrl.text.trim(),
      email: 'kwame@swiftry.com',
      rating: 4.8,
      totalDeliveries: 342,
      isOnline: false,
      isVerified: true,
      vehicleType: 'motor',
    ));

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Icon(Icons.delivery_dining, size: 64, color: AppColors.primary),
              const SizedBox(height: 16),
              const Text('Welcome Rider', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Enter your phone to continue', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 32),
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixText: '+233 ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onLogin,
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              const Center(child: Text('Mock: Any number works for now\nBackend TODO: Implement OTP', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.textTertiary))),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
