import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CreatePromotionScreen extends StatefulWidget {
  const CreatePromotionScreen({super.key});

  @override
  State<CreatePromotionScreen> createState() => _CreatePromotionScreenState();
}

class _CreatePromotionScreenState extends State<CreatePromotionScreen> {
  int _currentStep = 1;
  String? _selectedType = 'Percentage Discount';

  final List<Map<String, dynamic>> _promoTypes = [
    {'type': 'Percentage Discount', 'icon': LucideIcons.percent, 'color': AppColors.primary},
    {'type': 'Fixed Amount Off', 'icon': LucideIcons.minusSquare, 'color': AppColors.textSecondary},
    {'type': 'Free Delivery', 'icon': LucideIcons.truck, 'color': AppColors.textSecondary},
    {'type': 'BOGO (Buy 1 Get 1)', 'icon': LucideIcons.shoppingBag, 'color': AppColors.textSecondary},
    {'type': 'Free Item with Purchase', 'icon': LucideIcons.gift, 'color': AppColors.textSecondary},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 1,
        shadowColor: AppColors.border,
        leading: IconButton(
          icon: const Icon(LucideIcons.x, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Create Promotion', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: List.generate(5, (index) {
                final isCompleted = index < _currentStep;
                return Expanded(
                  child: Container(
                    height: 6,
                    margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.primary : AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16).copyWith(bottom: 100),
        child: Column(
          children: [
            _buildStep1(),
            const SizedBox(height: 24),
            _buildStep2(),
            const SizedBox(height: 24),
            _buildStep3(),
            const SizedBox(height: 24),
            _buildStep4(),
            const SizedBox(height: 24),
            _buildStep5(),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.check, size: 18),
              label: const Text('Launch Promotion', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepHeader(int step, String title) {
    return Row(
      children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
            color: step == _currentStep ? AppColors.primary : AppColors.primary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: step == _currentStep ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(1, 'Select Promotion Type'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12, runSpacing: 12,
          children: _promoTypes.map((pt) {
            final isSelected = _selectedType == pt['type'];
            return GestureDetector(
              onTap: () => setState(() => _selectedType = pt['type']),
              child: Container(
                width: (MediaQuery.of(context).size.width - 44) / 2,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(pt['icon'] as IconData, size: 20, color: isSelected ? AppColors.primary : AppColors.textSecondary),
                    const SizedBox(height: 8),
                    Text(
                      pt['type'] as String,
                      style: AppTextStyles.subtitleMedium.copyWith(color: isSelected ? AppColors.textPrimary : AppColors.textSecondary),
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

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(2, 'Discount Details'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('DISCOUNT PERCENTAGE', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.7)),
                  Text('15%', style: AppTextStyles.heading2.copyWith(color: AppColors.primary, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.primary.withOpacity(0.2),
                  thumbColor: Colors.white,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                ),
                child: Slider(value: 15, min: 0, max: 100, onChanged: (v) {}),
              ),
              const SizedBox(height: 24),
              Text('MAX DISCOUNT (OPTIONAL)', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.7)),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF5F7F8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  prefixText: 'GHS ',
                  hintText: '0.00',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(3, 'Conditions'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MINIMUM ORDER VALUE', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.7)),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF5F7F8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  prefixText: 'GHS ',
                  hintText: '50.00',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              Text('APPLIES TO', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.7)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(color: const Color(0xFFF5F7F8), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('All Menu Items', style: AppTextStyles.bodyMedium),
                    const Icon(LucideIcons.chevronDown, size: 20, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(4, 'Usage Limits'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('New customers only', style: AppTextStyles.subtitleMedium),
                  Switch(value: false, onChanged: (v) {}, activeColor: AppColors.primary),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MAX PER USER', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            filled: true, fillColor: const Color(0xFFF5F7F8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            hintText: '1',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOTAL LIMIT', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            filled: true, fillColor: const Color(0xFFF5F7F8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            hintText: '100',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(5, 'Valid Period'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('START DATE', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(color: const Color(0xFFF5F7F8), borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('mm/dd/yyyy', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                          const Icon(LucideIcons.calendar, size: 16, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('END DATE', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(color: const Color(0xFFF5F7F8), borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('mm/dd/yyyy', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                          const Icon(LucideIcons.calendar, size: 16, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
