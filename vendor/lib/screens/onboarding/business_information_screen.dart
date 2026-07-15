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
import '../../widgets/onboarding/location_preview.dart';
import 'owner_information_screen.dart';

class BusinessInformationScreen extends StatefulWidget {
  const BusinessInformationScreen({super.key});

  @override
  State<BusinessInformationScreen> createState() => _BusinessInformationScreenState();
}

class _BusinessInformationScreenState extends State<BusinessInformationScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onContinue() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const OwnerInformationScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // #f5f7f8
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: TopBar(
          title: 'Vendor Registration',
          step: 2,
          total: 5,
          onBack: () {
            if (context.canPop()) {
              context.pop();
            }
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
                  top: 24,
                  bottom: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Business Information',
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: 16),
                    
                    // Basic Info Fields
                    const CustomTextField(
                      name: 'businessName',
                      label: 'Business Name',
                      hintText: 'e.g., Papaye Fast Food',
                    ),
                    const SizedBox(height: 16),
                    
                    const CustomTextField(
                      name: 'businessDescription',
                      label: 'Business Description',
                      hintText: 'Tell us about your services...',
                      maxLines: 4,
                      maxLength: 200,
                    ),
                    const SizedBox(height: 16),
                    
                    const CustomTextField(
                      name: 'businessPhone',
                      label: 'Business Phone',
                      hintText: '20 123 4567',
                      prefixText: '+233',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    
                    const CustomTextField(
                      name: 'businessEmail',
                      label: 'Business Email',
                      hintText: 'contact@business.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Address Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Business Address',
                          style: AppTextStyles.heading3,
                        ),
                        InkWell(
                          onTap: () {
                            // Use current location logic
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.mapPin, size: 16, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  'Use current location',
                                  style: AppTextStyles.buttonTextSmall.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdownField<String>(
                            name: 'region',
                            label: 'Region',
                            hintText: 'Greater Accra',
                            items: const [
                              DropdownMenuItem(value: 'Greater Accra', child: Text('Greater Accra')),
                              DropdownMenuItem(value: 'Ashanti', child: Text('Ashanti')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomDropdownField<String>(
                            name: 'city',
                            label: 'City / Town',
                            hintText: 'Accra',
                            items: const [
                              DropdownMenuItem(value: 'Accra', child: Text('Accra')),
                              DropdownMenuItem(value: 'Kumasi', child: Text('Kumasi')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    const CustomTextField(
                      name: 'streetAddress',
                      label: 'Street Address',
                      hintText: 'House number or street name',
                    ),
                    const SizedBox(height: 16),
                    
                    const CustomTextField(
                      name: 'landmark',
                      label: 'Landmark',
                      hintText: 'Near major building',
                    ),
                    const SizedBox(height: 16),
                    
                    const CustomTextField(
                      name: 'digitalAddress',
                      label: 'Digital Address (NigeriaPost GPS)',
                      hintText: 'GA-183-1234',
                    ),
                    const SizedBox(height: 16),
                    
                    const LocationPreview(),
                  ],
                ),
              ),
            ),
            
            // Sticky Footer
            Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 17,
                bottom: 16,
              ),
              child: SafeArea(
                top: false,
                child: PrimaryButton(
                  label: 'Continue to Step 3',
                  onPressed: _onContinue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
