import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class RatingsReviewsScreen extends StatefulWidget {
  const RatingsReviewsScreen({super.key});

  @override
  State<RatingsReviewsScreen> createState() => _RatingsReviewsScreenState();
}

class _RatingsReviewsScreenState extends State<RatingsReviewsScreen> {
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Kwame A.',
      'rating': 5,
      'date': '2 days ago',
      'comment': 'Excellent food! Arrived hot and fresh. The jollof rice was perfectly seasoned.',
      'replied': false,
    },
    {
      'name': 'Ama O.',
      'rating': 4,
      'date': '1 week ago',
      'comment': 'Good portions and tasty food. Delivery was a bit late but food quality made up for it.',
      'replied': true,
      'reply': 'Thank you Ama! We apologize for the delay and are working to improve our delivery times.',
    },
    {
      'name': 'Kofi M.',
      'rating': 5,
      'date': '2 weeks ago',
      'comment': 'One of the best restaurants on swiftree. Always consistent quality.',
      'replied': false,
    },
    {
      'name': 'Abena S.',
      'rating': 3,
      'date': '3 weeks ago',
      'comment': 'Food was okay but packaging could be better. Soup was spilled during delivery.',
      'replied': true,
      'reply': 'We\'re sorry for this experience. We\'ve upgraded our packaging. Please try us again!',
    },
  ];

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
        title: Text('Ratings & Reviews', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Rating Overview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 25),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    '4.8',
                    style: AppTextStyles.heading2.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2.4,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) => Icon(
                      i < 4 ? LucideIcons.star : LucideIcons.starHalf,
                      color: const Color(0xFF0052CC),
                      size: 20,
                    )),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1,240 reviews',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Rating bars — matching Container14 grid layout exactly
                  ...[
                    {'star': '5', 'pct': 0.70, 'label': '70%'},
                    {'star': '4', 'pct': 0.20, 'label': '20%'},
                    {'star': '3', 'pct': 0.05, 'label': '5%'},
                    {'star': '2', 'pct': 0.03, 'label': '3%'},
                    {'star': '1', 'pct': 0.02, 'label': '2%'},
                  ].map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text(
                            e['star'] as String,
                            style: const TextStyle(
                              color: Color(0xFF475569),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9999),
                            child: Stack(
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: e['pct'] as double,
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0052CC),
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 40,
                          child: Text(
                            e['label'] as String,
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Performance Badges
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.award, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('Performance Badges', style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _badge(LucideIcons.star, 'Tasty', 'x142'),
                      _badge(LucideIcons.zap, 'Fast Prep', 'x89'),
                      _badge(LucideIcons.utensils, 'Good Portions', 'x64'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Recent Reviews
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Reviews', style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                      TextButton(
                        onPressed: () {},
                        child: Text('View all', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._reviews.map((review) => _reviewCard(review)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(IconData icon, String label, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 16),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.subtitleMedium.copyWith(fontSize: 14)),
          const SizedBox(width: 4),
          Text(count, style: AppTextStyles.captionBold.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _reviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review['name'].toString().substring(0, 1),
                    style: AppTextStyles.heading2.copyWith(fontSize: 16, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review['name'], style: AppTextStyles.subtitleMedium),
                    Row(
                      children: [
                        ...List.generate(5, (i) => Icon(
                          i < (review['rating'] as int) ? LucideIcons.star : LucideIcons.star,
                          color: i < (review['rating'] as int) ? const Color(0xFFF59E0B) : AppColors.border,
                          size: 12,
                        )),
                        const SizedBox(width: 6),
                        Text(review['date'], style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              if (!(review['replied'] as bool))
                TextButton(
                  onPressed: () {},
                  child: Text('Reply', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review['comment'], style: AppTextStyles.bodyMedium),
          if (review['replied'] as bool) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.15)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.messageSquare, size: 14, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You: ${review['reply']}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
