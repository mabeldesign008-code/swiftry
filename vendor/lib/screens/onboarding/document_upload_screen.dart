import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/top_bar.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/forms/custom_text_field.dart';
import 'bank_details_screen.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  // Required documents state
  String? _businessRegDoc;
  String? _NigeriaCardFront;
  String? _NigeriaCardBack;

  // Optional document toggles
  bool _includeTIN = false;
  bool _includeBusinessPhotos = true; // pre-toggled on in React design
  bool _includeVAT = false;

  bool get _canContinue => _businessRegDoc != null && _NigeriaCardFront != null && _NigeriaCardBack != null;

  void _simulateUpload(String docType) {
    setState(() {
      switch (docType) {
        case 'businessReg':
          _businessRegDoc = 'business_reg.pdf';
          break;
        case 'NigeriaCardFront':
          _NigeriaCardFront = 'Nigeria_card_front.jpg';
          break;
        case 'NigeriaCardBack':
          _NigeriaCardBack = 'Nigeria_card_back.jpg';
          break;
      }
    });
  }

  void _onContinue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const BankDetailsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: TopBar(
          title: 'Vendor Registration',
          step: 4,
          total: 5,
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page heading
                  Text('Business Documents', style: AppTextStyles.heading2),
                  const SizedBox(height: 4),
                  Text(
                    'Please provide the necessary legal documents for verification.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 32),

                  // ── Required Documents ───────────────────────────
                  Row(
                    children: [
                      const Icon(LucideIcons.fileText, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('Required Documents', style: AppTextStyles.heading3),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Doc 1: Business Registration Certificate
                  Text(
                    'Business Registration Certificate',
                    style: AppTextStyles.subtitleMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _UploadZone(
                    label: 'Upload or Take Photo',
                    sublabel: 'PDF, JPG or PNG up to 5MB',
                    icon: LucideIcons.fileUp,
                    uploaded: _businessRegDoc != null,
                    filename: _businessRegDoc,
                    onTap: () => _simulateUpload('businessReg'),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    name: 'registrationNumber',
                    label: 'Registration number',
                    hintText: 'e.g. BN-123,456,789',
                  ),
                  const SizedBox(height: 24),

                  // Doc 2: Nigeria Card (front + back)
                  Text(
                    "Owner's Nigeria Card",
                    style: AppTextStyles.subtitleMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _UploadZone(
                          label: 'Upload front',
                          sublabel: null,
                          icon: LucideIcons.idCard,
                          uploaded: _NigeriaCardFront != null,
                          onTap: () => _simulateUpload('NigeriaCardFront'),
                          height: 128,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _UploadZone(
                          label: 'Upload back',
                          sublabel: null,
                          icon: LucideIcons.idCard,
                          uploaded: _NigeriaCardBack != null,
                          onTap: () => _simulateUpload('NigeriaCardBack'),
                          height: 128,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ── Additional Documents (Optional) ───────────────
                  Row(
                    children: [
                      Icon(LucideIcons.clipboardList, size: 20, color: AppColors.textTertiary),
                      const SizedBox(width: 8),
                      Text('Additional Documents (Optional)', style: AppTextStyles.heading3),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryTransparent),
                    ),
                    child: Column(
                      children: [
                        _OptionalDocRow(
                          icon: LucideIcons.fileText,
                          label: 'TIN Certificate',
                          value: _includeTIN,
                          onChanged: (v) => setState(() => _includeTIN = v),
                          showDivider: true,
                        ),
                        _OptionalDocRow(
                          icon: LucideIcons.images,
                          label: 'Business Photos',
                          value: _includeBusinessPhotos,
                          onChanged: (v) => setState(() => _includeBusinessPhotos = v),
                          showDivider: true,
                        ),
                        _OptionalDocRow(
                          icon: LucideIcons.receipt,
                          label: 'VAT Registration',
                          value: _includeVAT,
                          onChanged: (v) => setState(() => _includeVAT = v),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Footer
          Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  PrimaryButton(
                    label: 'Continue',
                    disabled: !_canContinue,
                    onPressed: _canContinue ? _onContinue : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'By continuing, you agree to our Vendor Terms & Conditions',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                    textAlign: TextAlign.center,
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

/// Dashed upload zone — matches the React OverlayBorder component
class _UploadZone extends StatelessWidget {
  final String label;
  final String? sublabel;
  final IconData icon;
  final bool uploaded;
  final String? filename;
  final VoidCallback onTap;
  final double height;

  const _UploadZone({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.uploaded,
    required this.onTap,
    this.filename,
    this.height = 110,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: uploaded
              ? AppColors.success.withOpacity(0.05)
              : AppColors.primaryTransparent5,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: uploaded
                ? AppColors.success.withOpacity(0.4)
                : AppColors.primaryTransparent20,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: uploaded ? AppColors.success.withOpacity(0.4) : AppColors.primaryTransparent20,
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    uploaded ? LucideIcons.circleCheck : icon,
                    size: 24,
                    color: uploaded ? AppColors.success : AppColors.primary,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    uploaded ? (filename ?? 'Uploaded') : label,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: uploaded ? AppColors.success : AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (sublabel != null && !uploaded) ...[
                    const SizedBox(height: 2),
                    Text(
                      sublabel!,
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final radius = const Radius.circular(14);
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      radius,
    );
    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Row with icon, label and a toggle switch
class _OptionalDocRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const _OptionalDocRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary.withOpacity(0.6)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label, style: AppTextStyles.label),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: AppColors.primaryTransparent,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
