import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/top_bar.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/forms/custom_text_field.dart';
import '../../widgets/forms/custom_dropdown.dart';
import 'document_upload_screen.dart';

class OwnerInformationScreen extends StatefulWidget {
  const OwnerInformationScreen({super.key});

  @override
  State<OwnerInformationScreen> createState() => _OwnerInformationScreenState();
}

class _OwnerInformationScreenState extends State<OwnerInformationScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _identityVerified = false;

  void _onVerifySmileId() {
    // Simulate Smile ID verification
    setState(() => _identityVerified = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Identity verified successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _onContinue() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const DocumentUploadScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: TopBar(
          title: 'Vendor Registration',
          step: 3,
          total: 5,
          onBack: () {
            if (context.canPop()) context.pop();
          },
        ),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading
                    Text('Owner Information', style: AppTextStyles.heading2),
                    const SizedBox(height: 8),
                    Text(
                      'Please provide the details of the primary business owner.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Full Name
                    const CustomTextField(
                      name: 'ownerName',
                      label: 'Full name',
                      hintText: 'e.g., Kofi Mensah',
                    ),
                    const SizedBox(height: 16),

                    // Role
                    CustomDropdownField<String>(
                      name: 'ownerRole',
                      label: 'Role',
                      hintText: 'Select role',
                      items: const [
                        DropdownMenuItem(value: 'Owner', child: Text('Owner')),
                        DropdownMenuItem(value: 'Manager', child: Text('Manager')),
                        DropdownMenuItem(value: 'Director', child: Text('Director')),
                        DropdownMenuItem(value: 'Partner', child: Text('Partner')),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Phone (read-only, pre-filled, shows "Verified" badge)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone number',
                          style: AppTextStyles.label.copyWith(
                            color: const Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Stack(
                          children: [
                            Container(
                              height: 48,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 13),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSecondary,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.primaryTransparent20),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '+233 24 123 4567',
                                style: AppTextStyles.inputText.copyWith(
                                  color: AppColors.textPrimary.withOpacity(0.6),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 13,
                              top: 0,
                              bottom: 0,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    LucideIcons.checkCircle2,
                                    size: 13,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'VERIFIED',
                                    style: AppTextStyles.captionBold.copyWith(
                                      color: AppColors.success,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Email
                    const CustomTextField(
                      name: 'ownerEmail',
                      label: 'Email address',
                      hintText: 'e.g., kofi.mensah@Nigeria-biz.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Nigeria Card Number
                    const CustomTextField(
                      name: 'NigeriaCardNumber',
                      label: 'Nigeria Card Number',
                      hintText: 'GHA-723145678-9',
                    ),
                    const SizedBox(height: 24),

                    // Identity Verification Card
                    _VerificationCard(
                      verified: _identityVerified,
                      onVerify: _onVerifySmileId,
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
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 17,
                bottom: 16,
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    PrimaryButton(
                      label: 'Continue to Step 4',
                      disabled: !_identityVerified,
                      onPressed: _identityVerified ? _onContinue : null,
                    ),
                    if (!_identityVerified) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Identity verification is required to proceed to the next step.',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationCard extends StatelessWidget {
  final bool verified;
  final VoidCallback onVerify;

  const _VerificationCard({
    required this.verified,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 50, 26, 26),
      decoration: BoxDecoration(
        color: AppColors.primaryTransparent5,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryTransparent20,
          width: 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        children: [
          // Icon circle
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.primaryTransparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              verified ? LucideIcons.shieldCheck : LucideIcons.scanFace,
              size: 30,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),

          // Title & subtitle
          Text(
            verified ? 'Identity Verified' : 'Identity Verification',
            style: AppTextStyles.subtitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            verified
                ? 'Your identity has been successfully verified.'
                : 'Verify your identity with a quick selfie',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          if (!verified)
            // Verify button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onVerify,
                icon: const Icon(LucideIcons.camera, size: 18),
                label: const Text('Verify with Smile ID'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  textStyle: AppTextStyles.buttonText.copyWith(fontSize: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
              ),
            )
          else
            // Verified badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.circleCheck, size: 16, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text(
                    'Verified',
                    style: AppTextStyles.buttonTextSmall.copyWith(
                      color: AppColors.success,
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
