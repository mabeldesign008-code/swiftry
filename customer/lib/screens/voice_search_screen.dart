import 'dart:async';
import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';

class VoiceSearchScreen extends StatefulWidget {
  const VoiceSearchScreen({super.key});

  @override
  State<VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

class _VoiceSearchScreenState extends State<VoiceSearchScreen>
    with SingleTickerProviderStateMixin {
  String _status = 'idle'; // idle | listening | processing | done
  String _recognizedText = '';
  Timer? _timer;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<String> _mockResults = [
    'Jollof Rice',
    'Fried Chicken',
    'Paracetamol',
    'iPhone Case',
    'Tomatoes',
  ];

  final List<String> _recentVoiceSearches = [
    'Jollof Rice',
    'Fried Chicken Combo',
    'Vitamin C',
    'Polo T-Shirt',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _status = 'listening';
      _recognizedText = '';
    });
    _pulseController.repeat();

    _timer = Timer(const Duration(seconds: 2), () {
      setState(() => _status = 'processing');

      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          _status = 'done';
          _recognizedText =
              _mockResults[DateTime.now().second % _mockResults.length];
        });
        _pulseController.stop();
        _pulseController.reset();
      });
    });
  }

  void _clear() {
    _timer?.cancel();
    _pulseController.stop();
    _pulseController.reset();
    setState(() {
      _status = 'idle';
      _recognizedText = '';
    });
  }

  void _simulateChipSearch(String phrase) {
    setState(() {
      _status = 'listening';
      _recognizedText = '';
    });
    _pulseController.repeat();

    _timer = Timer(const Duration(milliseconds: 800), () {
      setState(() => _status = 'processing');

      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          _status = 'done';
          _recognizedText = phrase;
        });
        _pulseController.stop();
        _pulseController.reset();
      });
    });
  }

  String get _statusLabel {
    switch (_status) {
      case 'listening':
        return 'Listening...';
      case 'processing':
        return 'Processing...';
      case 'done':
        return _recognizedText;
      default:
        return 'Tap the mic to start';
    }
  }

  Color get _micBgColor {
    return (_status == 'listening' || _status == 'processing')
        ? AppTheme.primary
        : AppTheme.border;
  }

  Color get _micIconColor {
    return (_status == 'listening' || _status == 'processing')
        ? Colors.white
        : const Color(0xFF94A3B8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Voice Search',
          style: AppFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // ── Status label / recognized text ──
                    _buildStatusArea(),

                    const SizedBox(height: 48),

                    // ── Animated mic button ──
                    _buildMicButton(),

                    const SizedBox(height: 16),

                    // ── Tap hint ──
                    if (_status == 'idle')
                      Text(
                        'or choose a recent search below',
                        style: AppFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),

                    if (_status == 'listening' || _status == 'processing')
                      Text(
                        _status == 'listening'
                            ? 'Speak now…'
                            : 'Hang tight…',
                        style: AppFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                      ),

                    const SizedBox(height: 48),

                    // ── Result card ──
                    if (_status == 'done') _buildResultCard(),

                    // ── Recent voice searches (idle only) ──
                    if (_status == 'idle') _buildRecentChips(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Status area ────────────────────────────────────────────────────────────

  Widget _buildStatusArea() {
    final bool isDone = _status == 'done';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isDone
          ? const SizedBox.shrink()
          : Container(
              key: ValueKey(_status),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                _statusLabel,
                textAlign: TextAlign.center,
                style: AppFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _status == 'idle'
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0068FF),
                ),
              ),
            ),
    );
  }

  // ─── Animated mic button ─────────────────────────────────────────────────────

  Widget _buildMicButton() {
    final bool isActive =
        _status == 'listening' || _status == 'processing';

    return GestureDetector(
      onTap: _status == 'idle' ? _startListening : null,
      child: SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse ring (only when active)
            if (isActive)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  final double scale = 1.0 + _pulseAnimation.value * 0.55;
                  final double opacity = 1.0 - _pulseAnimation.value;
                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity.clamp(0.0, 1.0),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0068FF).withValues(alpha: 0.25),
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Second, slightly smaller pulse ring for depth
            if (isActive)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  final double scale = 1.0 + _pulseAnimation.value * 0.35;
                  final double opacity =
                      (1.0 - _pulseAnimation.value).clamp(0.0, 1.0);
                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity * 0.4,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0068FF).withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Inner mic circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _micBgColor,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0068FF).withValues(alpha: 0.30),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                _status == 'processing'
                    ? Icons.hourglass_top_rounded
                    : Icons.mic,
                color: _micIconColor,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Result card ─────────────────────────────────────────────────────────────

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You said:',
            style: AppFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF94A3B8),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '"$_recognizedText"',
            style: AppFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0068FF),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, _recognizedText),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0068FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Search',
                        style: AppFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _clear,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF0068FF)),
                    ),
                    child: Center(
                      child: Text(
                        'Clear',
                        style: AppFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0068FF),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Recent voice search chips ───────────────────────────────────────────────

  Widget _buildRecentChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent voice searches',
          style: AppFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _recentVoiceSearches.map((phrase) {
            return GestureDetector(
              onTap: () => _simulateChipSearch(phrase),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.mic_none_rounded,
                      size: 15,
                      color: Color(0xFF0068FF),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      phrase,
                      style: AppFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
