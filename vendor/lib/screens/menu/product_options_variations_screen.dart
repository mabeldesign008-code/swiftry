import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ProductOptionsVariationsScreen extends StatefulWidget {
  const ProductOptionsVariationsScreen({super.key});

  @override
  State<ProductOptionsVariationsScreen> createState() => _ProductOptionsVariationsScreenState();
}

class _ProductOptionsVariationsScreenState extends State<ProductOptionsVariationsScreen> {
  final List<Map<String, dynamic>> _variations = [
    {'name': 'Regular', 'price': '12.50'},
    {'name': 'Large', 'price': '15.50'},
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
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Edit Product Details', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16).copyWith(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Variations', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
            const SizedBox(height: 4),
            Text('Add different sizes or base versions of your product.', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _variations.length,
              itemBuilder: (context, index) {
                return _buildVariationItem(index);
              },
            ),
            
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  _variations.add({'name': '', 'price': ''});
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.plus, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text('Add Variation', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariationItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SIZE/VARIATION', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: _variations[index]['name'],
                  onChanged: (val) => _variations[index]['name'] = val,
                  decoration: InputDecoration(
                    hintText: 'e.g. Regular',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PRICE (\$)', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: _variations[index]['price'],
                  onChanged: (val) => _variations[index]['price'] = val,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(LucideIcons.trash2, color: AppColors.textSecondary, size: 20),
            onPressed: () {
              setState(() {
                _variations.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }
}
