import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for LogicalKeyboardKey, KeyDownEvent
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // for Timer
import '../core/constants/app_constants.dart';

// ─── Registration Data Model ──────────────────────────────────────────────────

class _RegistrationData {
  String phone;
  String firstName = '';
  String lastName = '';
  String email = '';
  String dateOfBirth = '';
  String referralCode = '';

  _RegistrationData({this.phone = ''});

  String get fullName => '$firstName $lastName'.trim();
}

// ─── Flow Step Count ─────────────────────────────────────────────────────────
// Steps 0–10 show the progress bar; step 11 (AllSetScreen) has none.
const int _totalSteps = 11;

// ─── Shared Widgets ───────────────────────────────────────────────────────────

Widget _buildAppBar(BuildContext context, String title, {
  VoidCallback? onBack,
  int? currentStep,
}) {
  return SafeArea(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(title, style: AppFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
              Positioned(
                left: 16,
                child: GestureDetector(
                  onTap: onBack ?? () => Navigator.maybePop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back_ios_new, size: 24, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Progress indicator (only shown for steps 0–11)
        if (currentStep != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: (currentStep + 1) / _totalSteps),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, _) => ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 4,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0068FF)),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

Widget _buildPrimaryButton(String label, VoidCallback onTap) {
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0068FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: Text(label, style: AppFonts.inter(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
    ),
  );
}



// ─── OTP/PIN Input Widget ─────────────────────────────────────────────────────

class _CodeInputRow extends StatefulWidget {
  final int length;
  final bool obscure;
  final ValueChanged<String>? onComplete; // passes the full code string
  final VoidCallback? onClear; // called when first field is cleared via backspace

  const _CodeInputRow({
    super.key,
    this.length = 4,
    this.obscure = false,
    this.onComplete,
    this.onClear,
  });

  @override
  State<_CodeInputRow> createState() => _CodeInputRowState();
}

class _CodeInputRowState extends State<_CodeInputRow> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (i) {
      final node = FocusNode();
      node.addListener(() {
        if (node.hasFocus && mounted) setState(() => _focusedIndex = i);
      });
      return node;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) { c.dispose(); }
    for (var f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  void clearAll() {
    for (var c in _controllers) { c.clear(); }
    if (mounted) {
      setState(() => _focusedIndex = 0);
      _focusNodes[0].requestFocus();
    }
  }

  void _handleChange(String value, int index) {
    if (value.isNotEmpty && index < widget.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isNotEmpty && index == widget.length - 1) {
      _focusNodes[index].unfocus();
      final code = _controllers.map((c) => c.text).join();
      if (code.length == widget.length) {
        widget.onComplete?.call(code);
      }
    }
  }

  void _handleBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    } else if (_controllers[index].text.isEmpty && index == 0) {
      widget.onClear?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (i) {
        final isFocused = i == _focusedIndex;
        return Container(
          width: 72, height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isFocused ? const Color(0xFF0068FF) : const Color(0xFFD8DDE2),
              width: isFocused ? 2 : 1,
            ),
          ),
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace) {
                _handleBackspace(i);
              }
            },
            child: TextField(
              controller: _controllers[i],
              focusNode: _focusNodes[i],
              maxLength: 1,
              textAlign: TextAlign.center,
              obscureText: widget.obscure,
              keyboardType: TextInputType.number,
              style: AppFonts.inter(fontSize: 22, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
              onChanged: (v) => _handleChange(v, i),
            ),
          ),
        );
      }),
    );
  }
}

// ─── OTP Code Verification ────────────────────────────────────────────────────

// ─── Verified Success Screen ──────────────────────────────────────────────────

class VerifiedSuccessScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const VerifiedSuccessScreen({
    super.key,
    required this.onContinue,
  });

  @override
  State<VerifiedSuccessScreen> createState() => _VerifiedSuccessScreenState();
}

class _VerifiedSuccessScreenState extends State<VerifiedSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Auto-continue after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) widget.onContinue();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0068FF).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 80,
                      color: Color(0xFF0068FF),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Verified!',
                        style: AppFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1B1B1B),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your phone number has been\nsuccessfully verified',
                        textAlign: TextAlign.center,
                        style: AppFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF8A8A8E),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Setting up your account...',
                    style: AppFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF8A8A8E),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── OTP Code Verification ────────────────────────────────────────────────────

class OtpVerificationScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int? currentStep;
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.onNext,
    required this.phoneNumber,
    this.onBack,
    this.currentStep,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool _isCodeComplete = false;
  bool _showError = false;
  int _secondsLeft = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        if (mounted) setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onVerify() {
    if (!_isCodeComplete) {
      setState(() => _showError = true);
      return;
    }
    setState(() => _showError = false);
    // Show verified screen as an overlay, then call onNext
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerifiedSuccessScreen(
          onContinue: () {
            Navigator.pop(context); // Close verified screen
            widget.onNext(); // Continue to next step
          },
        ),
      ),
    );
  }

  void _onResend() {
    setState(() {
      _isCodeComplete = false;
      _showError = false;
    });
    _startTimer();
    // Mock API call to resend OTP
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent successfully (Mock)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context, 'Verification', onBack: widget.onBack, currentStep: widget.currentStep),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'OTP Code Verification',
                    style: AppFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: const Color(0xFF1B1B1B)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We sent an OTP code to your number ${widget.phoneNumber}',
                    style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E), height: 1.6),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Text(
                      'Change my number?',
                      style: AppFonts.inter(
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _CodeInputRow(
                    onComplete: (code) => setState(() => _isCodeComplete = code.length == 4),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _showError
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              'Please enter the full 4-digit code',
                              style: AppFonts.inter(fontSize: 14, color: const Color(0xFFE11D48)),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Didn't receive the code?",
                    style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E), height: 1.6),
                  ),
                  const SizedBox(height: 8),
                  if (_secondsLeft > 0)
                    RichText(
                      text: TextSpan(
                        style: AppFonts.inter(fontSize: 16),
                        children: [
                          const TextSpan(
                            text: 'You can resend code in ',
                            style: TextStyle(color: Color(0xFF8A8A8E)),
                          ),
                          TextSpan(
                            text: '${_secondsLeft}s',
                            style: const TextStyle(color: Color(0xFF2857FF), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _onResend,
                      child: Text(
                        'Resend OTP',
                        style: AppFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF0068FF),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  _buildPrimaryButton('Verify', _onVerify),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Create Account ───────────────────────────────────────────────────────────

class CreateAccountScreen extends StatefulWidget {
  final void Function(String firstName, String lastName, String email) onComplete;
  final VoidCallback? onBack;
  final int? currentStep;

  const CreateAccountScreen({
    super.key,
    required this.onComplete,
    this.onBack,
    this.currentStep,
  });

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    // Simulate pre-filled name from SmileID
    // TODO: Replace with actual SmileID data when API is ready
    _nameCtrl.text = 'Edward Mensah';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    final fullName = _nameCtrl.text.trim();
    final parts = fullName.split(' ');
    final firstName = parts.isNotEmpty ? parts[0] : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    
    widget.onComplete(
      firstName,
      lastName,
      _emailCtrl.text.trim(),
    );
  }

  Widget _formField(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      readOnly: readOnly,
      validator: validator,
      style: AppFonts.inter(fontSize: 16, color: const Color(0xFF0D1217)),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9F9FA),
        labelText: label,
        labelStyle: AppFonts.inter(fontSize: 14, color: const Color(0xFFA2A0A8)),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE9EAEB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE9EAEB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0068FF), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE11D48)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE11D48), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context, 'Complete Profile', onBack: widget.onBack, currentStep: widget.currentStep),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Complete your profile',
                      style: AppFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: const Color(0xFF1B1B1B)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We retrieved your name from your ID. You can edit it if needed.',
                      style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E), height: 1.6),
                    ),
                    const SizedBox(height: 32),

                    // Profile Picture (Optional)
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFF9F9FA),
                              border: Border.all(color: const Color(0xFFE9EAEB), width: 2),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              size: 50,
                              color: Color(0xFF8A8A8E),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0068FF),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Name field with edit button
                    _formField(
                      'Full Name',
                      _nameCtrl,
                      readOnly: !_isEditingName,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                      suffix: IconButton(
                        icon: Icon(
                          _isEditingName ? Icons.check : Icons.edit,
                          color: const Color(0xFF0068FF),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() => _isEditingName = !_isEditingName);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email (Optional)
                    _formField(
                      'Email Address (Optional)',
                      _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v != null && v.trim().isNotEmpty) {
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                            return 'Enter a valid email';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your email to receive order updates and receipts',
                      style: AppFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF8A8A8E),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildPrimaryButton('Continue', _onContinue),
                    const SizedBox(height: 24),
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

// ─── Find Account ─────────────────────────────────────────────────────────────

class FindAccountScreen extends StatefulWidget {
  const FindAccountScreen({super.key});

  @override
  State<FindAccountScreen> createState() => _FindAccountScreenState();
}

class _FindAccountScreenState extends State<FindAccountScreen> {
  final _ctrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onSearch() async {
    final val = _ctrl.text.trim();
    if (val.isEmpty) {
      setState(() => _error = 'Please enter your email or phone number');
      return;
    }
    setState(() {
      _error = null;
      _isLoading = true;
    });
    // Simulate lookup delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    // Navigate to OTP flow with the entered value as phone
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AuthFlowScreen(
          phoneNumber: val.startsWith('+') ? val : '+233$val',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context, 'Find Account'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Find Account',
                    style: AppFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: const Color(0xFF1B1B1B)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your email or phone number to find your account',
                    style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E), height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 56,
                    child: TextField(
                      controller: _ctrl,
                      keyboardType: TextInputType.emailAddress,
                      style: AppFonts.inter(fontSize: 16, color: const Color(0xFF0D1217)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF9F9FA),
                        hintText: 'Email or Phone Number',
                        hintStyle: AppFonts.inter(fontSize: 16, color: const Color(0xFFA2A0A8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE9EAEB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE9EAEB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF0068FF), width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: AppFonts.inter(fontSize: 13, color: const Color(0xFFE11D48)),
                    ),
                  ],
                  const SizedBox(height: 32),
                  _buildPrimaryButton(
                    _isLoading ? 'Searching...' : 'Search',
                    _isLoading ? () {} : _onSearch,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Accept Terms ─────────────────────────────────────────────────────────────

class AcceptTermsScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int? currentStep;
  const AcceptTermsScreen({super.key, required this.onNext, this.onBack, this.currentStep});

  @override
  State<AcceptTermsScreen> createState() => _AcceptTermsScreenState();
}

class _AcceptTermsScreenState extends State<AcceptTermsScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context, 'Accept Terms', onBack: widget.onBack, currentStep: widget.currentStep),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    "Accept swiftree's Terms\n& Review Privacy Notice",
                    style: AppFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: const Color(0xFF1B1B1B), height: 1.3),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'By selecting "I agree" I have reviewed and agree to the Terms of Use and acknowledge the privacy notice.',
                            style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E), height: 1.6),
                          ),
                          const SizedBox(height: 24),
                          _termSection('1. Terms of Service', 'By using swiftree, you agree to our terms and conditions. You must be at least 18 years old to create an account and use our services.'),
                          _termSection('2. Privacy Notice', 'We collect and process your personal data to provide our delivery services. This includes your name, phone number, email, and delivery addresses.'),
                          _termSection('3. Location Data', 'We use your location to connect you with nearby restaurants and delivery partners. Location data is only collected when the app is in use.'),
                          _termSection('4. Payment Terms', 'All payments are processed securely. You agree to pay for all orders placed through your account.'),
                          _termSection('5. Cancellation Policy', 'Orders can be cancelled within 2 minutes of placement. After that, cancellation fees may apply.'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'I agree',
                        style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF061623)),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _agreed = !_agreed),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 21, height: 21,
                          decoration: BoxDecoration(
                            color: _agreed ? const Color(0xFF1F61E9) : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _agreed ? const Color(0xFF1F61E9) : const Color(0xFF7E7E7E),
                              width: 1.5,
                            ),
                          ),
                          child: _agreed ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildPrimaryButton(
                    'Next',
                    _agreed
                        ? widget.onNext
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please agree to the terms to continue',
                                  style: AppFonts.inter(),
                                ),
                                backgroundColor: const Color(0xFFE11D48),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _termSection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1B1B1B))),
          const SizedBox(height: 8),
          Text(body, style: AppFonts.inter(fontSize: 14, color: const Color(0xFF8A8A8E), height: 1.6)),
        ],
      ),
    );
  }
}

// ─── Confirm Your Details ─────────────────────────────────────────────────────

class ConfirmDetailsScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int? currentStep;
  final String initialEmail;
  final String initialName;

  const ConfirmDetailsScreen({
    super.key,
    required this.onNext,
    this.onBack,
    this.currentStep,
    this.initialEmail = '',
    this.initialName = '',
  });

  @override
  State<ConfirmDetailsScreen> createState() => _ConfirmDetailsScreenState();
}

class _ConfirmDetailsScreenState extends State<ConfirmDetailsScreen> {
  late final TextEditingController _emailCtrl;
  late final TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.initialEmail);
    _nameCtrl = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Widget _field(String label, TextEditingController ctrl, {TextInputType? type}) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        style: AppFonts.inter(fontSize: 16, color: const Color(0xFF0D1217)),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9F9FA),
          labelText: label,
          labelStyle: AppFonts.inter(fontSize: 14, color: const Color(0xFFA2A0A8)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE9EAEB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE9EAEB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0068FF), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context, 'Setup your Profile', onBack: widget.onBack, currentStep: widget.currentStep),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Stack(
                    children: [
                      Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFEEF2FF),
                          border: Border.all(color: const Color(0xFF0068FF).withValues(alpha: 0.2), width: 2),
                        ),
                        child: const Icon(Icons.person, size: 70, color: Color(0xFF0068FF)),
                      ),
                      Positioned(
                        bottom: 4, right: 4,
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFCC00),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Confirm your details',
                    style: AppFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: const Color(0xFF1B1B1B)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _field('Email', _emailCtrl, type: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _field('Full Name', _nameCtrl),
                  const SizedBox(height: 40),
                  _buildPrimaryButton('Complete Setup', widget.onNext),
                  const SizedBox(height: 12),
                  Text(
                    'By tapping Complete Setup, you agree to our Terms of Service.',
                    textAlign: TextAlign.center,
                    style: AppFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8), height: 1.4),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Enable Location Access ───────────────────────────────────────────────────

class EnableLocationScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int? currentStep;
  const EnableLocationScreen({super.key, required this.onNext, this.onBack, this.currentStep});

  @override
  State<EnableLocationScreen> createState() => _EnableLocationScreenState();
}

class _EnableLocationScreenState extends State<EnableLocationScreen> {
  bool _isRequesting = false;

  Future<void> _requestLocation() async {
    setState(() => _isRequesting = true);
    
    // For web, use browser's geolocation API
    try {
      // This is a simplified version - in production you'd use geolocator package
      // or direct web API calls
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate request
      if (mounted) {
        widget.onNext();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not access location. You can set it manually in the next step.',
              style: AppFonts.inter(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF0F172A),
          ),
        );
        widget.onNext();
      }
    } finally {
      if (mounted) setState(() => _isRequesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context, 'Location Access', onBack: widget.onBack, currentStep: widget.currentStep),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140, height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(70),
                    ),
                    child: const Icon(Icons.location_on, size: 80, color: Color(0xFF0068FF)),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Enable Location Access',
                    style: AppFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B1B1B),
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We need your location to find restaurants and stores near you',
                    textAlign: TextAlign.center,
                    style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E), height: 1.6),
                  ),
                  const SizedBox(height: 48),
                  _isRequesting
                      ? const CircularProgressIndicator()
                      : _buildPrimaryButton('Allow Location', _requestLocation),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: widget.onNext,
                    child: Text('Not now', style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Set Your Delivery ────────────────────────────────────────────────────────

class SetDeliveryScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int? currentStep;
  const SetDeliveryScreen({super.key, required this.onNext, this.onBack, this.currentStep});

  void _navigateToLocationMethod(BuildContext context, String method) {
    // Navigate to specific location input screen based on method
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _LocationInputScreen(
          method: method,
          onComplete: () {
            Navigator.pop(context);
            onNext();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context, 'Select Location', onBack: onBack, currentStep: currentStep),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Set your delivery location',
                    style: AppFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: const Color(0xFF1B1B1B)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'How do you want to add your address?',
                    style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E), height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  _locationOption(
                    context,
                    Icons.location_on_outlined,
                    'Use Current Location',
                    'Let us detect your location automatically',
                    () => _navigateToLocationMethod(context, 'current'),
                  ),
                  const SizedBox(height: 16),
                  _locationOption(
                    context,
                    Icons.language,
                    'What3Words',
                    'Enter a What3Words address',
                    () => _navigateToLocationMethod(context, 'what3words'),
                  ),
                  const SizedBox(height: 16),
                  _locationOption(
                    context,
                    Icons.map_outlined,
                    'NigeriaPostGPS',
                    'Enter your NigeriaPostGPS code',
                    () => _navigateToLocationMethod(context, 'Nigeriapost'),
                  ),
                  const SizedBox(height: 16),
                  _locationOption(
                    context,
                    Icons.my_location,
                    'Pick on Map',
                    'Tap to select location on a map',
                    () => _navigateToLocationMethod(context, 'map'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationOption(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF0068FF), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1B1B1B))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppFonts.inter(fontSize: 12, color: const Color(0xFF8A8A8E))),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF8A8A8E)),
          ],
        ),
      ),
    );
  }
}

// ─── Location Input Screen (Dedicated page for each method) ───────────────────

class _LocationInputScreen extends StatefulWidget {
  final String method;
  final VoidCallback onComplete;

  const _LocationInputScreen({
    required this.method,
    required this.onComplete,
  });

  @override
  State<_LocationInputScreen> createState() => _LocationInputScreenState();
}

class _LocationInputScreenState extends State<_LocationInputScreen> {
  final _textCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.method) {
      case 'current':
        return 'Current Location';
      case 'what3words':
        return 'What3Words';
      case 'Nigeriapost':
        return 'NigeriaPostGPS';
      case 'map':
        return 'Pick on Map';
      default:
        return 'Location';
    }
  }

  String get _placeholder {
    switch (widget.method) {
      case 'what3words':
        return 'e.g. ///filled.count.soap';
      case 'Nigeriapost':
        return 'e.g. GA-123-4567';
      default:
        return 'Enter location';
    }
  }

  Future<void> _handleSubmit() async {
    if (widget.method == 'current') {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1)); // Simulate location fetch
      if (mounted) {
        setState(() => _isLoading = false);
        widget.onComplete();
      }
    } else if (widget.method == 'map') {
      // For map, just complete (in real app, would show map picker)
      widget.onComplete();
    } else {
      if (_textCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid $_title', style: AppFonts.inter()),
            backgroundColor: const Color(0xFFE11D48),
          ),
        );
        return;
      }
      widget.onComplete();
    }
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
        title: Text(
          _title,
          style: AppFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B1B1B),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.method == 'current') ...[
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.my_location,
                        size: 50,
                        color: Color(0xFF0068FF),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Detecting your location...',
                      style: AppFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1B1B1B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please wait while we get your current location',
                      textAlign: TextAlign.center,
                      style: AppFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF8A8A8E),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ] else if (widget.method == 'map') ...[
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.map,
                        size: 50,
                        color: Color(0xFF0068FF),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Map Picker',
                      style: AppFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1B1B1B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Interactive map picker would appear here',
                      textAlign: TextAlign.center,
                      style: AppFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF8A8A8E),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ] else ...[
              Text(
                'Enter your $_title',
                style: AppFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B1B1B),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _textCtrl,
                autofocus: true,
                style: AppFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF1B1B1B),
                ),
                decoration: InputDecoration(
                  hintText: _placeholder,
                  hintStyle: AppFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFFA2A0A8),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF9F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE9EAEB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE9EAEB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF0068FF), width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                onSubmitted: (_) => _handleSubmit(),
              ),
              const Spacer(),
            ],
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0068FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Confirm Location',
                        style: AppFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Current Location (Map View) ──────────────────────────────────────────────

class CurrentLocationScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int? currentStep;
  const CurrentLocationScreen({super.key, required this.onNext, this.onBack, this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE8F5E9), Color(0xFFE3F2FD)],
                ),
              ),
              child: CustomPaint(painter: _MapGridPainter()),
            ),
          ),
          const Center(child: Icon(Icons.location_pin, size: 60, color: Color(0xFF0068FF))),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, 'Current Location', onBack: onBack, currentStep: currentStep),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 10)],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      const Icon(Icons.search, color: Color(0xFF878787)),
                      const SizedBox(width: 8),
                      Text('Search location...', style: AppFonts.inter(color: const Color(0xFF878787), fontSize: 14)),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 20)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3E8FC),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Obuasi, Kumasi', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF1B1B1B))),
                  const SizedBox(height: 4),
                  Text('Ashanti Region, Nigeria', style: AppFonts.inter(fontSize: 14, color: const Color(0xFF8A8A8E))),
                  const SizedBox(height: 20),
                  _buildPrimaryButton('Confirm Location', onNext),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCCDDD8)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 6;
    canvas.drawLine(Offset(size.width * 0.2, 0), Offset(size.width * 0.2, size.height), road);
    canvas.drawLine(Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.4), road);
    canvas.drawLine(Offset(size.width * 0.6, 0), Offset(size.width * 0.6, size.height), road);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7), road);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Fingerprint ──────────────────────────────────────────────────────────────

class FingerprintScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int? currentStep;
  const FingerprintScreen({super.key, required this.onNext, this.onBack, this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context, 'Fingerprint', onBack: onBack, currentStep: currentStep),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140, height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(70),
                    ),
                    child: const Icon(Icons.fingerprint, size: 80, color: Color(0xFF0068FF)),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Set Up Fingerprint',
                    style: AppFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B1B1B),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Use your fingerprint to login quickly and securely',
                    textAlign: TextAlign.center,
                    style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E), height: 1.6),
                  ),
                  const SizedBox(height: 48),
                  _buildPrimaryButton('Enable Fingerprint', onNext),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: onNext,
                    child: Text('Skip for now', style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PIN Setup ────────────────────────────────────────────────────────────────

class PinSetupScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int? currentStep;
  const PinSetupScreen({super.key, required this.onNext, this.onBack, this.currentStep});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  int _pinStep = 0; // 0 = enter PIN, 1 = confirm PIN
  String _firstPin = '';
  bool _showMismatch = false;
  bool _isComplete = false;

  void _onCodeComplete(String code) {
    setState(() => _isComplete = true);
    if (_pinStep == 0) {
      setState(() {
        _firstPin = code;
        _pinStep = 1;
        _isComplete = false;
        _showMismatch = false;
      });
    } else {
      if (code == _firstPin) {
        widget.onNext();
      } else {
        setState(() {
          _showMismatch = true;
          _pinStep = 0;
          _firstPin = '';
          _isComplete = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context, 'Set up PIN', onBack: widget.onBack, currentStep: widget.currentStep),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Create a 4-Digit PIN',
                    style: AppFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: const Color(0xFF1B1B1B)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _pinStep == 0
                        ? 'Add a PIN as a backup for biometric logins.'
                        : 'Re-enter your PIN to confirm.',
                    style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E), height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  // ValueKey resets the widget when _pinStep changes
                  _CodeInputRow(
                    key: ValueKey(_pinStep),
                    obscure: true,
                    onComplete: _onCodeComplete,
                  ),
                  if (_showMismatch) ...[
                    const SizedBox(height: 12),
                    Text(
                      "PINs don't match. Please try again.",
                      style: AppFonts.inter(fontSize: 14, color: const Color(0xFFE11D48)),
                    ),
                  ],
                  const Spacer(),
                  _buildPrimaryButton(
                    _pinStep == 0 ? 'Continue' : 'Confirm PIN',
                    _isComplete
                        ? () => _onCodeComplete(_pinStep == 0 ? _firstPin : '')
                        : () {},
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: widget.onNext,
                      child: Text('Skip for now', style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E))),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Passkey Setup (3 steps) ──────────────────────────────────────────────────

class PasskeyScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int? currentStep;
  final int step;
  const PasskeyScreen({super.key, required this.onNext, required this.step, this.onBack, this.currentStep});

  @override
  Widget build(BuildContext context) {
    final titles = ['Set Up Passkey', 'Create Your Passkey', 'Passkey Created!'];
    final subtitles = [
      'A passkey is a secure, password-free sign-in method using your device biometrics.',
      'Follow the prompts on your device to create a passkey using Face ID or fingerprint.',
      'Your passkey has been created. You can now sign in quickly and securely.',
    ];
    final icons = [Icons.key_rounded, Icons.face_rounded, Icons.verified_rounded];
    final btnLabels = ['Set Up Passkey', 'Continue', 'Done'];
    final isLast = step == 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context, 'Passkey', onBack: onBack, currentStep: currentStep),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == step ? 24 : 8, height: 8,
                      decoration: BoxDecoration(
                        color: i == step ? const Color(0xFF0068FF) : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    width: 130, height: 130,
                    decoration: BoxDecoration(
                      color: isLast ? const Color(0xFFEEF8F0) : const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(65),
                    ),
                    child: Icon(
                      icons[step],
                      size: 70,
                      color: isLast ? const Color(0xFF16A34A) : const Color(0xFF0068FF),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    titles[step],
                    style: AppFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B1B1B),
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    subtitles[step],
                    textAlign: TextAlign.center,
                    style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E), height: 1.6),
                  ),
                  const SizedBox(height: 48),
                  _buildPrimaryButton(btnLabels[step], onNext),
                  if (!isLast) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: onNext,
                      child: Text('Skip for now', style: AppFonts.inter(fontSize: 16, color: const Color(0xFF8A8A8E))),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── You Are All Set ──────────────────────────────────────────────────────────

class AllSetScreen extends StatelessWidget {
  final VoidCallback onNext;
  const AllSetScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x804263EB), width: 2),
                    ),
                  ),
                  Container(
                    width: 113, height: 113,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF5F7FE)),
                    child: const Icon(Icons.check_rounded, color: Color(0xFF4263EB), size: 60),
                  ),
                  const Positioned(top: 8, right: 8, child: Icon(Icons.star, color: Color(0xFF4263EB), size: 22)),
                  const Positioned(bottom: 12, left: 4, child: Icon(Icons.star, color: Color(0x334263EB), size: 18)),
                  const Positioned(top: 8, left: 8, child: Icon(Icons.star, color: Color(0xFF4263EB), size: 28)),
                  const Positioned(bottom: 8, right: 8, child: Icon(Icons.star, color: Color(0x334263EB), size: 16)),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'You are all Set',
                style: AppFonts.inter(fontSize: 26, fontWeight: FontWeight.w600, color: const Color(0xFF15141F), letterSpacing: -1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Start exploring and order anything you need.',
                textAlign: TextAlign.center,
                style: AppFonts.inter(fontSize: 16, color: const Color(0xFFA2A0A8), height: 1.6),
              ),
              const Spacer(),
              _buildPrimaryButton('Done', onNext),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Full Auth + Setup Flow ───────────────────────────────────────────────────

class AuthFlowScreen extends StatefulWidget {
  final int startStep;
  final String phoneNumber;

  const AuthFlowScreen({super.key, this.startStep = 0, this.phoneNumber = ''});

  @override
  State<AuthFlowScreen> createState() => _AuthFlowScreenState();
}

class _AuthFlowScreenState extends State<AuthFlowScreen> {
  late int _step;
  late final _RegistrationData _userData;

  @override
  void initState() {
    super.initState();
    _step = widget.startStep;
    _userData = _RegistrationData(phone: widget.phoneNumber);
  }

  void _next() => setState(() => _step++);

  void _back() {
    if (_step > widget.startStep) {
      setState(() => _step--);
    } else {
      Navigator.maybePop(context);
    }
  }

  Future<void> _handleComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefKeyUserLoggedIn, true);
    if (_userData.phone.isNotEmpty) {
      await prefs.setString(AppConstants.prefKeyUserPhone, _userData.phone);
    }
    if (_userData.fullName.isNotEmpty) {
      await prefs.setString(AppConstants.prefKeyUserName, _userData.fullName);
    }
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.15, 0), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
      child: _buildScreen(),
    );
  }

  Widget _buildScreen() {
    switch (_step) {
      case 0:
        return OtpVerificationScreen(
          key: const ValueKey(0),
          onNext: _next,
          onBack: _back,
          currentStep: _step,
          phoneNumber: _userData.phone,
        );
      case 1:
        return CreateAccountScreen(
          key: const ValueKey(1),
          onComplete: (firstName, lastName, email) {
            _userData.firstName = firstName;
            _userData.lastName = lastName;
            _userData.email = email;
            _next();
          },
          onBack: _back,
          currentStep: _step,
        );
      case 2:
        return AcceptTermsScreen(
          key: const ValueKey(2),
          onNext: _next,
          onBack: _back,
          currentStep: _step,
        );
      case 3:
        return EnableLocationScreen(
          key: const ValueKey(3),
          onNext: _next,
          onBack: _back,
          currentStep: _step,
        );
      case 4:
        return SetDeliveryScreen(
          key: const ValueKey(4),
          onNext: _next,
          onBack: _back,
          currentStep: _step,
        );
      case 5:
        return CurrentLocationScreen(
          key: const ValueKey(5),
          onNext: _next,
          onBack: _back,
          currentStep: _step,
        );
      case 6:
        return FingerprintScreen(
          key: const ValueKey(6),
          onNext: _next,
          onBack: _back,
          currentStep: _step,
        );
      case 7:
        return PinSetupScreen(
          key: const ValueKey(7),
          onNext: _next,
          onBack: _back,
          currentStep: _step,
        );
      case 8:
        return PasskeyScreen(
          key: const ValueKey(8),
          onNext: _next,
          onBack: _back,
          currentStep: _step,
          step: 0,
        );
      case 9:
        return PasskeyScreen(
          key: const ValueKey(9),
          onNext: _next,
          onBack: _back,
          currentStep: _step,
          step: 1,
        );
      case 10:
        return PasskeyScreen(
          key: const ValueKey(10),
          onNext: _next,
          onBack: _back,
          currentStep: _step,
          step: 2,
        );
      case 11:
        return AllSetScreen(
          key: const ValueKey(11),
          onNext: () { _handleComplete(); },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
