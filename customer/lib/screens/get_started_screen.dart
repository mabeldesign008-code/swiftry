import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'auth_flow_screens.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final TextEditingController _phoneCtrl = TextEditingController();
  bool _isLoading = false;
  String? _phoneError;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    final raw = _phoneCtrl.text.trim().replaceAll(RegExp(r'[-\s]'), '');
    String digits = raw.startsWith('0') ? raw.substring(1) : raw;
    if (digits.length < 9) {
      setState(() => _phoneError = 'Enter a valid 9-digit phone number');
      return;
    }
    setState(() => _phoneError = null);
    final fullPhone = '+233$digits';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AuthFlowScreen(phoneNumber: fullPhone),
      ),
    );
  }

  void _showPhoneInputModal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _PhoneInputFullScreen(
          controller: _phoneCtrl,
          onContinue: (String phone) {
            final fullPhone = '+233$phone';
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => AuthFlowScreen(phoneNumber: fullPhone),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showComingSoon(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppFonts.inter(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: AppTheme.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (flipped horizontally)
          Positioned.fill(
            child: Transform.scale(
              scaleX: -1,
              child: Image.asset(
                'assets/images/get_started_bg.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          // Dark Overlay
          Positioned.fill(
            child: Container(
              color: const Color(0x33000000),
            ),
          ),

          // Title Section
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Akwaaba!',
                  style: AppFonts.inter(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: AppFonts.inter(
                      color: Colors.white,
                      fontSize: 16.96,
                    ),
                    children: const [
                      TextSpan(
                          text: 'Welcome to ',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      TextSpan(
                          text: 'swiftree',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ', Login or\nsign up to order.',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Card
          Positioned(
            bottom: 31,
            left: 16,
            right: 16,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Get Started Now!',
                      style: AppFonts.inter(
                        color: const Color(0xFF1B1B1B),
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Enter your phone number',
                      style: AppFonts.inter(
                        color: const Color(0xFF8A8A8E),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Phone Input - Now acts as a button
                    GestureDetector(
                      onTap: _showPhoneInputModal,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9FA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE9EAEB)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/Nigeria_flag.png',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '+233',
                                style: AppFonts.inter(
                                  color: const Color(0xFF1B1B1B),
                                  fontSize: 16.96,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '|',
                                style: AppFonts.inter(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 16.96,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _phoneCtrl.text.isEmpty
                                      ? 'Phone Number'
                                      : _phoneCtrl.text,
                                  style: AppFonts.inter(
                                    color: _phoneCtrl.text.isEmpty
                                        ? const Color(0xFFA2A0A8)
                                        : const Color(0xFF1B1B1B),
                                    fontSize: 16,
                                    fontWeight: _phoneCtrl.text.isEmpty
                                        ? FontWeight.w400
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Inline error text
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _phoneError != null
                          ? Padding(
                              key: const ValueKey('error'),
                              padding:
                                  const EdgeInsets.only(top: 6, left: 4),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _phoneError!,
                                  style: AppFonts.inter(
                                    color: const Color(0xFFE11D48),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(key: ValueKey('no-error')),
                    ),

                    const SizedBox(height: 16),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Continue',
                                style: AppFonts.inter(
                                  color: Colors.white,
                                  fontSize: 19.23,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // OR Divider
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(
                                color: Color(0xFFE2E8F0), thickness: 1)),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: AppFonts.inter(
                              color: const Color(0xFF8A8A8E),
                              fontSize: 16.96,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            child: Divider(
                                color: Color(0xFFE2E8F0), thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Continue with Google
                    _SocialButton(
                      icon: const FaIcon(FontAwesomeIcons.google,
                          color: Colors.black, size: 20),
                      label: 'Continue with Google',
                      onTap: () => _showComingSoon(
                        'Google Sign-In coming soon. Please use your phone number for now.',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Continue with Apple
                    _SocialButton(
                      icon: const FaIcon(FontAwesomeIcons.apple,
                          color: Colors.black, size: 24),
                      label: 'Continue with Apple',
                      onTap: () => _showComingSoon(
                        'Apple Sign-In coming soon. Please use your phone number for now.',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Continue with Email
                    _SocialButton(
                      icon: const Icon(Icons.mail_outline,
                          color: Colors.black, size: 24),
                      label: 'Continue with Email',
                      onTap: () => _showComingSoon(
                        'Email Sign-In coming soon. Please use your phone number for now.',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // OR Divider
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(
                                color: Color(0xFFE2E8F0), thickness: 1)),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: AppFonts.inter(
                              color: const Color(0xFF8A8A8E),
                              fontSize: 16.96,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            child: Divider(
                                color: Color(0xFFE2E8F0), thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Find my account
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FindAccountScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Find my account',
                        style: AppFonts.inter(
                          color: const Color(0xFF8A8A8E),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEDEDED)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: AppFonts.inter(
                color: const Color(0xFF1B1B1B),
                fontSize: 19.23,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// WhatsApp/Bolt-style Full Screen Phone Input
class _PhoneInputFullScreen extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onContinue;

  const _PhoneInputFullScreen({
    required this.controller,
    required this.onContinue,
  });

  @override
  State<_PhoneInputFullScreen> createState() => _PhoneInputFullScreenState();
}

class _PhoneInputFullScreenState extends State<_PhoneInputFullScreen> {
  String? _phoneError;
  String _verificationMethod = 'SMS'; // 'SMS' or 'WhatsApp'

  void _handleContinue() {
    final raw = widget.controller.text.trim().replaceAll(RegExp(r'[-\s]'), '');
    String digits = raw.startsWith('0') ? raw.substring(1) : raw;
    if (digits.length < 9) {
      setState(() => _phoneError = 'Enter a valid 9-digit phone number');
      return;
    }
    setState(() => _phoneError = null);
    widget.onContinue(digits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Title
              Text(
                'Enter your number',
                style: AppFonts.inter(
                  color: const Color(0xFF1B1B1B),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We\'ll send a code for verification',
                style: AppFonts.inter(
                  color: const Color(0xFF8A8A8E),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Country Selector + Phone Input
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Country selector button
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE9EAEB)),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/Nigeria_flag.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+233',
                          style: AppFonts.inter(
                            color: const Color(0xFF1B1B1B),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF8A8A8E),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Phone Input
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 56,
                          child: TextField(
                            controller: widget.controller,
                            autofocus: true,
                            keyboardType: TextInputType.phone,
                            style: AppFonts.inter(
                              color: const Color(0xFF1B1B1B),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Phone number',
                              hintStyle: AppFonts.inter(
                                color: const Color(0xFFA2A0A8),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color(0xFF0068FF), width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color(0xFFE9EAEB)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color(0xFF0068FF), width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color(0xFFE11D48), width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color(0xFFE11D48), width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                            ),
                            onSubmitted: (_) => _handleContinue(),
                          ),
                        ),
                        // Error text
                        if (_phoneError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6, left: 4),
                            child: Text(
                              _phoneError!,
                              style: AppFonts.inter(
                                color: const Color(0xFFE11D48),
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Verification Method Options
              _VerificationOption(
                label: 'Use SMS',
                isSelected: _verificationMethod == 'SMS',
                onTap: () => setState(() => _verificationMethod = 'SMS'),
              ),
              const SizedBox(height: 16),
              _VerificationOption(
                label: 'Use WhatsApp',
                isSelected: _verificationMethod == 'WhatsApp',
                onTap: () => setState(() => _verificationMethod = 'WhatsApp'),
              ),
              const SizedBox(height: 24),

              // Privacy text
              Text(
                'swiftree will not send anything without your consent.',
                style: AppFonts.inter(
                  color: const Color(0xFF8A8A8E),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // Continue Button
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0068FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Continue',
                      style: AppFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

// Verification Option Widget (Radio button style)
class _VerificationOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _VerificationOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0068FF) : const Color(0xFFE9EAEB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0068FF)
                      : const Color(0xFFD1D5DB),
                  width: 2,
                ),
                color: Colors.white,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0068FF),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppFonts.inter(
                color: const Color(0xFF1B1B1B),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
