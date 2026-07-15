import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'create_story_screen.dart';
import 'story_insights_screen.dart';

class StoriesHubScreen extends StatefulWidget {
  const StoriesHubScreen({super.key});

  @override
  State<StoriesHubScreen> createState() => _StoriesHubScreenState();
}

class _StoriesHubScreenState extends State<StoriesHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _activeStories = [
    {
      'title': 'Jollof Special',
      'views': 245,
      'timeLeft': '18h left',
      'isActive': true,
      'color': const Color(0xFF0052CC),
    },
    {
      'title': 'Weekend Deal',
      'views': 102,
      'timeLeft': '4h left',
      'isActive': true,
      'color': const Color(0xFF7C3AED),
    },
  ];

  final List<Map<String, dynamic>> _pastStories = [
    {
      'title': 'Friday Feast',
      'views': 1234,
      'date': '3 days ago',
      'color': const Color(0xFF0F172A),
    },
    {
      'title': 'Lunch Special',
      'views': 867,
      'date': '1 week ago',
      'color': const Color(0xFF0F172A),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        title: Text('Stories', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTextStyles.captionBold,
          indicatorColor: AppColors.primary,
          indicatorWeight: 2.5,
          tabs: const [
            Tab(text: 'Manage'),
            Tab(text: 'Subscription'),
            Tab(text: 'Drafts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildManageTab(),
          _buildSubscriptionTab(),
          _buildDraftsTab(),
        ],
      ),
    );
  }

  Widget _buildManageTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Stories Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Stories', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CreateStoryScreen()),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.plus, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text('New Story', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 260,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ..._activeStories.map((s) => _storyCard(s, isActive: true)),
                _createNewCard(),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Past Stories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Past Stories', style: AppTextStyles.heading2.copyWith(fontSize: 16)),
          ),
          const SizedBox(height: 12),
          ..._pastStories.map((s) => _pastStoryRow(s)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _storyCard(Map<String, dynamic> story, {required bool isActive}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const StoryInsightsScreen(),
        ));
      },
      child: Container(
        width: 148,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Background gradient (story thumbnail placeholder)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  (story['color'] as Color).withOpacity(0.3),
                  (story['color'] as Color).withOpacity(0.8),
                ],
              ),
            ),
          ),
          // Active badge
          Positioned(
            top: 10, left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
              child: const Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
          // Bottom info
          Positioned(
            bottom: 8, left: 8, right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.eye, size: 11, color: Colors.white),
                    const SizedBox(width: 4),
                    Text('${story['views']} views', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                  ],
                ),
                Text(story['timeLeft'], style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10)),
                const SizedBox(height: 4),
                Text(story['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _createNewCard() {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CreateStoryScreen()),
      ),
      child: Container(
        width: 148,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 2, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.plus, size: 28, color: Color(0xFF94A3B8)),
            const SizedBox(height: 8),
            Text('Create New', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _pastStoryRow(Map<String, dynamic> story) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const StoryInsightsScreen(),
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.image, color: AppColors.textSecondary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story['title'], style: AppTextStyles.subtitleMedium),
                  Row(
                    children: [
                      const Icon(LucideIcons.eye, size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('${story['views']} views • ${story['date']}',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Insights', style: AppTextStyles.captionBold.copyWith(color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary.withOpacity(0.2), AppColors.primary.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(LucideIcons.crown, size: 48, color: AppColors.primary.withOpacity(0.5)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Upgrade to Premium', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Unlock the full power of vendor stories to grow your business reaching more customers daily.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ...[
              'Showcase products directly',
              'Top placement in user feeds',
              'Tag products in story frames',
            ].map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(LucideIcons.checkCircle2, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(item, style: AppTextStyles.bodyMedium),
                ],
              ),
            )).toList(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Upgrade Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.fileEdit, size: 48, color: AppColors.textSecondary.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text('No Drafts Yet', style: AppTextStyles.heading2.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text('Stories you save as drafts will appear here.', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
