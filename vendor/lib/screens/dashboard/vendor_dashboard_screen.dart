import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/modals/close_store_modal.dart';
import '../subscription/subscription_plans_screen.dart';
import '../subscription/subscription_checkout_screen.dart';
import 'vendor_notifications_screen.dart';
import '../orders/vendor_orders_main_view_screen.dart';
import '../wallet/vendor_wallet_screen.dart';
import 'report_order_issue_sheet.dart';
import '../ratings/ratings_reviews_screen.dart';
import '../support/help_center_screen.dart';
import '../analytics/stories_hub_screen.dart';
import '../analytics/create_promotion_screen.dart';
import '../analytics/product_analytics_screen.dart';
import '../../widgets/common/vendor_side_nav.dart';
import 'settlement_schedule_screen.dart';
import '../settings/store_settings_screen.dart';
import '../menu/menu_management_screen.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  bool _storeOpen = true;
  String _timeframe = 'month'; // week, month, year

  final Map<String, String> _revenueLabels = {
    'week': '₵2,149.50',
    'month': '₵1,691.54',
    'year': '₵18,430.00',
  };

  final Map<String, List<BarChartGroupData>> _chartData = {
    'week': [
      makeGroupData(0, 8.2), makeGroupData(1, 16.4), makeGroupData(2, 11.0),
      makeGroupData(3, 9.5), makeGroupData(4, 22.0, isMax: true), makeGroupData(5, 18.0), makeGroupData(6, 7.0),
    ],
    'month': [
      makeGroupData(0, 18.0), makeGroupData(1, 26.0), makeGroupData(2, 21.0),
      makeGroupData(3, 15.0), makeGroupData(4, 28.86, isMax: true), makeGroupData(5, 12.0),
    ],
    'year': [
      makeGroupData(0, 85.0), makeGroupData(1, 124.0), makeGroupData(2, 98.0), makeGroupData(3, 152.0, isMax: true),
    ],
  };

  static BarChartGroupData makeGroupData(int x, double y, {bool isMax = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isMax ? const Color(0xFF6C56F9) : const Color(0xFFE1DDFE),
          width: 22,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        ),
      ],
    );
  }

  void _handleStoreToggle() async {
    if (_storeOpen) {
      final close = await CloseStoreModal.show(context);
      if (close == true) {
        setState(() => _storeOpen = false);
      }
    } else {
      setState(() => _storeOpen = true);
    }
  }

  Widget _bottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.only(top: 12, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _navItem(LucideIcons.home, 'Home', isActive: true),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const VendorOrdersMainViewScreen(),
            )),
            child: _navItem(LucideIcons.package, 'Orders'),
          ),
          // Center floating button
          Container(
            width: 56,
            height: 56,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF0052FF), Color(0xFF003199)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(color: Color(0x330052FF), blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: const Icon(LucideIcons.plus, color: Colors.white, size: 24),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const VendorWalletScreen(),
            )),
            child: _navItem(LucideIcons.wallet, 'Balance'),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const MenuManagementScreen(),
            )),
            child: _navItem(LucideIcons.building2, 'Menu'),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: isActive ? AppColors.primary : const Color(0xFF9CA3AF)),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.captionBold.copyWith(
            color: isActive ? AppColors.primary : const Color(0xFF9CA3AF),
            fontSize: 10,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const VendorSideNav(currentRoute: 'dashboard'),
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.95),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(LucideIcons.shoppingCart, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _storeOpen ? AppColors.success : const Color(0xFF94A3B8),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _storeOpen ? 'Online' : 'Offline',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(LucideIcons.settings, size: 16, color: AppColors.textSecondary),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const StoreSettingsScreen(),
              ));
            },
          ),
          IconButton(
            icon: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(LucideIcons.bell, size: 16, color: AppColors.textSecondary),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444), // red-500
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VendorNotificationsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16).copyWith(bottom: 100),
        child: Column(
          children: [
            // Store Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.shoppingCart, size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Store Status', style: AppTextStyles.subtitle),
                        Text(
                          _storeOpen ? 'Accepting new orders' : 'Not accepting orders',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleStoreToggle,
                    child: Container(
                      width: 56,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _storeOpen ? AppColors.success : AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: _storeOpen ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Revenue Chart
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
                  Text('Revenue', style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFFA2A0A8))),
                  const SizedBox(height: 4),
                  Text(_revenueLabels[_timeframe]!, style: AppTextStyles.heading2.copyWith(fontSize: 30, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  Row(
                    children: ['week', 'month', 'year'].map((t) {
                      final isActive = _timeframe == t;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _timeframe = t),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            decoration: BoxDecoration(
                              color: isActive ? const Color(0xFF6C56F9) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isActive ? const Color(0xFF6C56F9) : const Color(0xFFE1DDFE)),
                            ),
                            child: Text(
                              t[0].toUpperCase() + t.substring(1),
                              style: AppTextStyles.subtitleMedium.copyWith(
                                color: isActive ? Colors.white : const Color(0xFF15141F),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 180,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: _timeframe == 'year' ? 160 : 30,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final labels = {
                                  'week': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                                  'month': ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'],
                                  'year': ['Q1', 'Q2', 'Q3', 'Q4'],
                                };
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    labels[_timeframe]![value.toInt()],
                                    style: const TextStyle(color: Color(0xFFA2A0A8), fontSize: 11),
                                  ),
                                );
                              },
                              reservedSize: 28,
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: _chartData[_timeframe],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Wallet Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0052CC), Color(0xFF003199)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.wallet, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text('Available Balance', style: AppTextStyles.subtitleMedium.copyWith(color: Colors.white.withOpacity(0.8))),
                        ],
                      ),
                      const Icon(LucideIcons.chevronRight, color: Colors.white70, size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('GHS 1,750', style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Container(height: 1, color: Colors.white.withOpacity(0.2)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('PENDING', style: AppTextStyles.captionBold.copyWith(color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text('GHS 1,450', style: AppTextStyles.subtitleMedium.copyWith(color: Colors.white)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TOTAL', style: AppTextStyles.captionBold.copyWith(color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text('GHS 3,200', style: AppTextStyles.subtitleMedium.copyWith(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Stat Cards (Net Income, Orders)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFF0EFFE), borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Net Income', style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFF52525C))),
                        const SizedBox(height: 8),
                        Text('₵4,500', style: AppTextStyles.heading2.copyWith(fontSize: 24, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFF0EFFE), borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Orders', style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFF52525C))),
                        const SizedBox(height: 8),
                        Text('55', style: AppTextStyles.heading2.copyWith(fontSize: 24, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Settlements & Ratings
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const SettlementScheduleScreen(),
                    )),
                    child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.wallet, size: 16, color: AppColors.success),
                            const SizedBox(width: 8),
                            Text('Settlements', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.success)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('GHS 3,200', style: AppTextStyles.heading2.copyWith(fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('Next payout', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const RatingsReviewsScreen(),
                    )),
                    child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.star, size: 16, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 8),
                            Text('Ratings', style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFFF59E0B))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('4.8', style: AppTextStyles.heading2.copyWith(fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('Run promotions to boost sales', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const ProductAnalyticsScreen(),
                    )),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(LucideIcons.barChart2, size: 16, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text('Analytics', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.textPrimary)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('View insights & trends', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Ongoing Orders
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF0EFFE), borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ongoing orders', style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFF52525C))),
                      Text('40%', style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDD9FB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('3 left to finish', style: AppTextStyles.caption.copyWith(color: const Color(0xFFA2A0A8))),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Upgrade Banner
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => SubscriptionPlansScreen(
                    onCheckout: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SubscriptionCheckoutScreen()),
                      );
                    },
                  )),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0052CC), Color(0xFF0031A0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Upgrade to Premium', style: AppTextStyles.subtitle.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text('Reduce commission to 12% & more', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(LucideIcons.arrowRight, size: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Stories / Promo
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StoriesHubScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)]),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(LucideIcons.messageSquare, size: 18, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text('Stories', style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFF1E40AF))),
                          Text('Engage customers', style: AppTextStyles.caption.copyWith(color: const Color(0xFF3B82F6))),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreatePromotionScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)]),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF97316).withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: const Color(0xFFF97316), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(LucideIcons.percent, size: 18, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text('Promo', style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFF9A3412))),
                          Text('Create offer', style: AppTextStyles.caption.copyWith(color: const Color(0xFFF97316))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Quick Access
            Row(
              children: [
                _quickAccessCard(LucideIcons.trendingUp, 'Performance', const Color(0xFF22C55E), () {}),
                const SizedBox(width: 8),
                _quickAccessCard(LucideIcons.helpCircle, 'Help', const Color(0xFF3B82F6), () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HelpCenterScreen()));
                }),
                const SizedBox(width: 8),
                _quickAccessCard(LucideIcons.package, 'Inventory', const Color(0xFFF59E0B), () {}),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _quickAccessCard(IconData icon, String label, Color iconColor, VoidCallback? onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(height: 8),
              Text(label, style: AppTextStyles.captionBold.copyWith(color: AppColors.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}
