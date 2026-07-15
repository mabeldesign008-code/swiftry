import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class LocationDeliveryScreen extends StatefulWidget {
  const LocationDeliveryScreen({super.key});

  @override
  State<LocationDeliveryScreen> createState() => _LocationDeliveryScreenState();
}

class _LocationDeliveryScreenState extends State<LocationDeliveryScreen> {
  bool _enableDelivery = true;
  bool _enablePickup = true;
  double _deliveryRadius = 10;
  final TextEditingController _minOrderController = TextEditingController(text: '30');

  @override
  void dispose() {
    _minOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        shadowColor: AppColors.border,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Location & Delivery', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Address Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Store Address', style: AppTextStyles.subtitleMedium),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(LucideIcons.map, size: 48, color: AppColors.textSecondary.withOpacity(0.5)),
                        ),
                        Positioned(
                          bottom: 12, left: 12, right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40, height: 40,
                                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(LucideIcons.mapPin, color: AppColors.primary),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('GA-123-4567', style: AppTextStyles.subtitleMedium),
                                      Text('Digital Address', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                  child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Container(height: 8, color: AppColors.primary.withOpacity(0.05)),
            
            // Delivery Settings Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery Settings', style: AppTextStyles.subtitleMedium),
                  const SizedBox(height: 16),
                  
                  // Toggles
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.truck, size: 20, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Text('Enable Delivery', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Switch(
                          value: _enableDelivery,
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            setState(() => _enableDelivery = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.shoppingBag, size: 20, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Text('Enable Pickup', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Switch(
                          value: _enablePickup,
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            setState(() => _enablePickup = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Delivery Radius Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('DELIVERY RADIUS', style: AppTextStyles.captionBold.copyWith(color: AppColors.textPrimary)),
                      Text('${_deliveryRadius.toInt()} km', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _deliveryRadius,
                    min: 1,
                    max: 50,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.primary.withOpacity(0.2),
                    onChanged: (val) {
                      setState(() => _deliveryRadius = val);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1 km', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      Text('50 km', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Minimum Order
                  Text('MINIMUM ORDER', style: AppTextStyles.captionBold.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Text('GHS', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _minOrderController,
                            keyboardType: TextInputType.number,
                            style: AppTextStyles.heading2.copyWith(fontSize: 18),
                            decoration: const InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Orders below this amount will not be accepted for delivery.',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.4),
            ),
            child: Text('Save Changes', style: AppTextStyles.subtitleMedium.copyWith(color: Colors.white, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
