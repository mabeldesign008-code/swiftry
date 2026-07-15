import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:share_plus/share_plus.dart';

class ReferEarnScreen extends StatelessWidget {
  const ReferEarnScreen({super.key});

  static const _referralCode = 'YEND-BISMARK10';
  static const _shareMessage =
      'Join swiftree with my referral code YEND-BISMARK10 and get ₵5 off your first order! '
      'Download here: https://swiftree.com/app';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Refer & Earn',
          style: AppFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: ListView(
        children: [
          _HeroBanner(),
          const SizedBox(height: 20),
          _HowItWorksCard(),
          const SizedBox(height: 16),
          _ReferralCodeCard(
            onCopy: () => _copyCode(context),
            onShare: () => _shareCode(context),
          ),
          const SizedBox(height: 16),
          _StatsCard(),
          const SizedBox(height: 16),
          _ReferredFriendsCard(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _copyCode(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: _referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code copied!', style: AppFonts.inter()),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0068FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareCode(BuildContext context) {
    SharePlus.instance.share(ShareParams(text: _shareMessage));
  }
}

// ── Hero banner ──────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/refer_friend.png',
            fit: BoxFit.cover,
          ),
          // gradient overlay — blue at bottom, transparent at top
          DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xCC0068FF), // ~80 % blue at bottom
                  Color(0x000068FF), // transparent at top
                ],
              ),
            ),
          ),
          // text overlay
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Refer a Friend',
                  style: AppFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Earn ₵10 for each referral!',
                  style: AppFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── How It Works card ────────────────────────────────────────────────────────

class _HowItWorksCard extends StatelessWidget {
  static const _steps = [
    _Step(
      number: '1',
      title: 'Share your code',
      description: 'Send your unique referral code to friends and family.',
    ),
    _Step(
      number: '2',
      title: 'They sign up',
      description: 'Your friend creates an account using your referral code.',
    ),
    _Step(
      number: '3',
      title: 'You both earn',
      description:
          'You get ₵10 wallet credit when they place their first order.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How It Works',
              style: AppFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 20),
            ..._steps.asMap().entries.map((e) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: e.key < _steps.length - 1 ? 18 : 0),
                child: _StepRow(step: e.value),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final _Step step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // numbered circle
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: Color(0xFF0068FF),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            step.number,
            style: AppFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: AppFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                step.description,
                style: AppFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Step {
  const _Step({
    required this.number,
    required this.title,
    required this.description,
  });

  final String number;
  final String title;
  final String description;
}

// ── Referral code card ───────────────────────────────────────────────────────

class _ReferralCodeCard extends StatelessWidget {
  const _ReferralCodeCard({required this.onCopy, required this.onShare});

  final VoidCallback onCopy;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF0068FF),
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // dashed divider row effect via a custom painter
            Text(
              'Your Referral Code',
              style: AppFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 10),
            // dashed border container around the code
            CustomPaint(
              painter: _DashedBorderPainter(
                color: const Color(0xFF0068FF),
                strokeWidth: 1.5,
                dashWidth: 6,
                dashSpace: 4,
                radius: 12,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                child: Text(
                  ReferEarnScreen._referralCode,
                  style: AppFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0068FF),
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onCopy,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0068FF),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.copy_outlined,
                        size: 18, color: Colors.white),
                    label: Text(
                      'Copy Code',
                      style: AppFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onShare,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0068FF),
                      side: const BorderSide(color: Color(0xFF0068FF)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: Text(
                      'Share',
                      style: AppFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

// Custom painter for a dashed border around the code
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final dashPath = _buildDashedPath(path);
    canvas.drawPath(dashPath, paint);
  }

  Path _buildDashedPath(Path source) {
    final metric = source.computeMetrics();
    final dash = Path();
    for (final m in metric) {
      double dist = 0;
      while (dist < m.length) {
        final end = (dist + dashWidth).clamp(0.0, m.length);
        dash.addPath(m.extractPath(dist, end), Offset.zero);
        dist += dashWidth + dashSpace;
      }
    }
    return dash;
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.dashWidth != dashWidth ||
      old.dashSpace != dashSpace ||
      old.radius != radius;
}

// ── Stats row card ───────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  static const _stats = [
    _Stat(value: '3', label: 'Total Referrals'),
    _Stat(value: '1', label: 'Pending'),
    _Stat(value: '₵20.00', label: 'Total Earned'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: _stats.asMap().entries.map((e) {
            final idx = e.key;
            final stat = e.value;
            return Expanded(
              child: Row(
                children: [
                  Expanded(child: _StatColumn(stat: stat)),
                  if (idx < _stats.length - 1)
                    Container(
                      height: 40,
                      width: 1,
                      color: const Color(0xFFF1F5F9),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.stat});

  final _Stat stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          stat.value,
          style: AppFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stat.label,
          textAlign: TextAlign.center,
          style: AppFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

class _Stat {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;
}

// ── Referred friends card ────────────────────────────────────────────────────

class _ReferredFriendsCard extends StatelessWidget {
  static const _friends = [
    _Friend(
      initials: 'AA',
      avatarColor: Color(0xFF6366F1),
      name: 'Ama Asante',
      phone: '+233 24 XXX XXXX',
      status: 'Joined 2 days ago',
      earning: '₵10 earned',
      earned: true,
    ),
    _Friend(
      initials: 'KB',
      avatarColor: Color(0xFF0EA5E9),
      name: 'Kwame Boateng',
      phone: '+233 55 XXX XXXX',
      status: 'Joined 1 week ago',
      earning: '₵10 earned',
      earned: true,
    ),
    _Friend(
      initials: 'AM',
      avatarColor: Color(0xFFF97316),
      name: 'Adjoa Mensah',
      phone: '+233 20 XXX XXXX',
      status: 'Pending first order',
      earning: 'Pending',
      earned: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Referred Friends (3)',
              style: AppFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            ..._friends.asMap().entries.map((e) {
              return Column(
                children: [
                  _FriendRow(friend: e.value),
                  if (e.key < _friends.length - 1)
                    const Divider(
                      height: 24,
                      color: Color(0xFFF1F5F9),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FriendRow extends StatelessWidget {
  const _FriendRow({required this.friend});

  final _Friend friend;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // avatar circle with initials
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: friend.avatarColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            friend.initials,
            style: AppFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                friend.name,
                style: AppFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${friend.phone} · ${friend.status}',
                style: AppFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // status chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: friend.earned
                ? const Color(0xFFDCFCE7)
                : const Color(0xFFFEF9C3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            friend.earning,
            style: AppFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: friend.earned
                  ? const Color(0xFF16A34A)
                  : const Color(0xFFB45309),
            ),
          ),
        ),
      ],
    );
  }
}

class _Friend {
  const _Friend({
    required this.initials,
    required this.avatarColor,
    required this.name,
    required this.phone,
    required this.status,
    required this.earning,
    required this.earned,
  });

  final String initials;
  final Color avatarColor;
  final String name;
  final String phone;
  final String status;
  final String earning;
  final bool earned;
}
