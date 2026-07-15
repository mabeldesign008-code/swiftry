import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../support/support_chat_screen.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'icon': LucideIcons.shoppingBag, 'title': 'Order Issues', 'subtitle': 'Cancellations, delays, disputes'},
    {'icon': LucideIcons.creditCard, 'title': 'Payments & Wallet', 'subtitle': 'Settlements, refunds, payouts'},
    {'icon': LucideIcons.utensils, 'title': 'Menu Management', 'subtitle': 'Adding items, pricing, photos'},
    {'icon': LucideIcons.settings, 'title': 'Account & Settings', 'subtitle': 'Profile, documents, security'},
    {'icon': LucideIcons.barChart2, 'title': 'Analytics & Reports', 'subtitle': 'Sales data, performance metrics'},
    {'icon': LucideIcons.truck, 'title': 'Delivery & Zones', 'subtitle': 'Coverage area, delivery fees'},
  ];

  final List<Map<String, dynamic>> _faqs = [
    {'question': 'How do I update my menu prices?', 'category': 'Menu'},
    {'question': 'When do I receive my weekly settlement?', 'category': 'Payments'},
    {'question': 'How do I dispute an order cancellation?', 'category': 'Orders'},
    {'question': 'How can I expand my delivery zone?', 'category': 'Delivery'},
    {'question': 'Why was my account temporarily suspended?', 'category': 'Account'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: AppColors.border,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Help Center', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Search
            Container(
              width: double.infinity,
              color: AppColors.primary.withOpacity(0.05),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How can we help?', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text('Search our knowledge base or browse categories.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.search, color: AppColors.textSecondary, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: AppTextStyles.bodyMedium,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Search for articles, guides...',
                              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quick Support CTA
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('QUICK SUPPORT', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.7)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.0,
                    children: _categories.map((cat) => _categoryCard(cat)).toList(),
                  ),
                ],
              ),
            ),

            // Divider
            Container(height: 1, color: AppColors.border),

            // FAQs
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FREQUENTLY ASKED', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 0.7)),
                  const SizedBox(height: 12),
                  ..._faqs.map((faq) => _faqItem(faq)).toList(),
                ],
              ),
            ),

            // Live chat button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportChatScreen()));
                  },
                  icon: const Icon(LucideIcons.messageSquare, size: 20),
                  label: const Text('Chat with Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(Map<String, dynamic> cat) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportChatScreen()));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(cat['icon'] as IconData, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(cat['title'], style: AppTextStyles.subtitleMedium.copyWith(fontSize: 13)),
                  Text(cat['subtitle'], style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, size: 14, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }

  Widget _faqItem(Map<String, dynamic> faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.helpCircle, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(faq['question'], style: AppTextStyles.subtitleMedium.copyWith(fontSize: 14))),
          const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFFCBD5E1)),
        ],
      ),
    );
  }
}
