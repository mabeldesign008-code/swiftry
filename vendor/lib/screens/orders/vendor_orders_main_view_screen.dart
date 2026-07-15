import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/vendor_config.dart';
import 'new_order_detail_screen.dart';
import 'completed_order_detail_screen.dart';
import 'laundry_order_detail_screen.dart';

class VendorOrdersMainViewScreen extends StatefulWidget {
  final String vendorType;

  const VendorOrdersMainViewScreen({super.key, this.vendorType = 'restaurant'});

  @override
  State<VendorOrdersMainViewScreen> createState() => _VendorOrdersMainViewScreenState();
}

class _VendorOrdersMainViewScreenState extends State<VendorOrdersMainViewScreen> {
  late VendorConfig _cfg;
  late String _activeTab;
  bool _accepted = false;
  bool _markedReady = false;

  // Countdown state: accept timer (150s) and prep timer (765s)
  int _acceptSecs = 150;
  int _prepSecs = 765;
  Timer? _acceptTimer;
  Timer? _prepTimer;

  @override
  void initState() {
    super.initState();
    _cfg = getVendorConfig(widget.vendorType);
    _activeTab = _cfg.orderStages.first.id;

    _acceptTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _acceptSecs > 0) setState(() => _acceptSecs--);
    });
    _prepTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _prepSecs > 0) setState(() => _prepSecs--);
    });
  }

  @override
  void dispose() {
    _acceptTimer?.cancel();
    _prepTimer?.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  List<Map<String, dynamic>> get _tabs {
    final stages = _cfg.orderStages;
    return stages.asMap().entries.map((e) {
      final i = e.key;
      final s = e.value;
      int? count;
      if (i == 0) count = _accepted ? 2 : 3;
      else if (i == 1) count = 2;
      else if (i == stages.length - 2) count = _markedReady ? 2 : 1;
      return {'id': s.id, 'label': s.label, 'count': count};
    }).toList();
  }

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _tabs.map((tab) {
          final isActive = _activeTab == tab['id'];
          final label = tab['count'] != null ? '${tab['label']} (${tab['count']})' : tab['label'];
          return GestureDetector(
            onTap: () => setState(() => _activeTab = tab['id']),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: isActive ? const Color(0xFF1463FF) : Colors.transparent, width: 2),
                ),
              ),
              child: Text(
                label,
                style: AppTextStyles.captionBold.copyWith(
                  color: isActive ? const Color(0xFF1463FF) : const Color(0xFF94A3B8),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFirstStageTab() {
    final stages = _cfg.orderStages;
    final mins = _acceptSecs ~/ 60;
    final secs = _acceptSecs % 60;

    return Column(
      children: [
        // Countdown
        Column(
          children: [
            Text(
              'ACCEPT BEFORE TIMEOUT',
              style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF1463FF), letterSpacing: 1.5),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimerBox(_pad(mins), 'MIN'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
                  child: Text(':', style: AppTextStyles.heading1.copyWith(color: const Color(0xFF94A3B8), fontSize: 30)),
                ),
                _buildTimerBox(_pad(secs), 'SEC'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Incoming Order Card
        if (!_accepted) ...[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8E4E4)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
            ),
            child: Column(
              children: [
                // Hero image placeholder
                Container(
                  height: 176,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    gradient: LinearGradient(
                      colors: [const Color(0xFF1463FF).withOpacity(0.3), const Color(0xFF0052CC)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF1463FF), borderRadius: BorderRadius.circular(6)),
                          child: Text('INCOMING ORDER', style: AppTextStyles.captionBold.copyWith(color: Colors.white, fontSize: 10)),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order #YDO-78430', style: AppTextStyles.subtitle.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text('Kofi M. • 3 items', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: const Color(0xFFF8F6F6), borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ORDER ITEMS', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8), fontSize: 10)),
                                  const SizedBox(height: 4),
                                  Text('2× Jollof Rice', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
                                  Text('1× Coca-Cola', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('GHS 85.00', style: AppTextStyles.heading2.copyWith(fontSize: 24, color: const Color(0xFF1463FF))),
                              Text('VAT inclusive', style: AppTextStyles.caption.copyWith(color: const Color(0xFF94A3B8))),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const NewOrderDetailScreen(),
                                ));
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFE2E8F0)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                minimumSize: const Size(0, 48),
                              ),
                              child: Text('View Details', style: AppTextStyles.subtitleMedium.copyWith(color: const Color(0xFF334155))),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _accepted = true;
                                  _activeTab = stages[1].id;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1463FF),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                minimumSize: const Size(0, 48),
                                elevation: 0,
                              ),
                              child: const Text('Accept Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF86EFAC)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.circleCheck, size: 20, color: Color(0xFF16A34A)),
                const SizedBox(width: 12),
                Expanded(child: Text('Order #YDO-78430 accepted — now preparing!', style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF15803D), fontWeight: FontWeight.w600))),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),

        // Other New Orders
        Align(
          alignment: Alignment.centerLeft,
          child: Text('OTHER NEW ORDERS', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF64748B), letterSpacing: 1)),
        ),
        const SizedBox(height: 12),
        ...[
          {'id': '#YDO-78431', 'customer': 'Ama R.', 'items': 2, 'amount': 'GHS 45.00'},
          {'id': '#YDO-78432', 'customer': 'Kwame O.', 'items': 1, 'amount': 'GHS 32.00'},
        ].map((order) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8E4E4)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
            ),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: const Icon(LucideIcons.shoppingCart, size: 18, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order ${order['id']}', style: AppTextStyles.subtitle),
                      Text('${order['customer']} · ${order['items']} ${(order['items'] as int) == 1 ? 'item' : 'items'}', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Text('${order['amount']}', style: AppTextStyles.subtitle),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildPreparingTab() {
    final totalSecs = 765;
    final elapsed = totalSecs - _prepSecs;
    final pct = (elapsed / totalSecs).clamp(0.0, 1.0);
    final mins = _prepSecs ~/ 60;
    final secs = _prepSecs % 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Order #YDO-78430', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
              Text('Customer: Kofi M.', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFF1463FF).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text('In Kitchen', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF1463FF))),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimerBox(_pad(mins), 'MINUTES'),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
              child: Text(':', style: AppTextStyles.heading1.copyWith(color: const Color(0xFF94A3B8), fontSize: 30)),
            ),
            _buildTimerBox(_pad(secs), 'SECONDS'),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 10,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation(Color(0xFF1463FF)),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text('${(pct * 100).round()}% complete', style: AppTextStyles.caption.copyWith(color: const Color(0xFF94A3B8))),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8E4E4)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ORDER ITEMS', style: AppTextStyles.captionBold.copyWith(color: AppColors.textSecondary)),
                    Text('3 items total', style: AppTextStyles.caption.copyWith(color: const Color(0xFF94A3B8))),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFF8F6F6)),
              ...[
                {'qty': '2×', 'name': 'Jollof Rice with Chicken', 'mod': 'Extra spicy · with plantain'},
                {'qty': '1×', 'name': 'Grilled Chicken', 'mod': 'Drumstick & Thigh'},
              ].map((item) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: const Color(0xFF1463FF).withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                          alignment: Alignment.center,
                          child: Text(item['qty']!, style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF1463FF))),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name']!, style: AppTextStyles.subtitle),
                            Text(item['mod']!, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF8F6F6)),
                ],
              )),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {},
            child: Text('Need more time?', style: AppTextStyles.subtitleMedium.copyWith(color: AppColors.textSecondary, decoration: TextDecoration.underline)),
          ),
        ),
      ],
    );
  }

  Widget _buildReadyTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1463FF).withOpacity(0.15)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
          ),
          child: Row(
            children: [
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(color: const Color(0xFF1463FF), borderRadius: BorderRadius.circular(4)),
                alignment: Alignment.center,
                child: const Icon(LucideIcons.check, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order #YDO-78430', style: AppTextStyles.subtitle),
                    Text('Kofi M. · 3 items · GHS 85.00', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF1463FF).withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    const Icon(LucideIcons.circleCheck, size: 11, color: Color(0xFF1463FF)),
                    const SizedBox(width: 4),
                    Text('Ready', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF1463FF))),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Delivery Status', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1463FF).withOpacity(0.12)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF1463FF).withOpacity(0.2), width: 2),
                          gradient: const LinearGradient(colors: [Color(0xFF6C56F9), Color(0xFF1463FF)]),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(LucideIcons.user, size: 22, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 16, height: 16,
                          decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kwame A.', style: AppTextStyles.subtitle),
                        Text('Honda CG 125', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.phone, size: 16),
                    label: const Text('Contact'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1463FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: AppTextStyles.captionBold,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1463FF).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1463FF).withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Arriving in 3 min', style: AppTextStyles.subtitle.copyWith(color: const Color(0xFF1463FF))),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              value: 0.8,
                              minHeight: 6,
                              backgroundColor: Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation(Color(0xFF1463FF)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(LucideIcons.navigation, size: 20, color: Color(0xFF1463FF)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedTab() {
    return Column(
      children: [
        ...[
          {'id': '#YDO-78430', 'customer': 'Kofi M.', 'amount': 'GHS 85.00', 'time': '3:25 PM', 'items': 3},
          {'id': '#YDO-78429', 'customer': 'Ama R.', 'amount': 'GHS 45.00', 'time': '1:10 PM', 'items': 2},
          {'id': '#YDO-78428', 'customer': 'Kwame O.', 'amount': 'GHS 32.00', 'time': '11:30 AM', 'items': 1},
        ].map((order) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const CompletedOrderDetailScreen(),
                ));
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8E4E4)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Icon(LucideIcons.circleCheck, size: 20, color: Color(0xFF16A34A)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order ${order['id']}', style: AppTextStyles.subtitle),
                          Text('${order['customer']} · ${order['items']} ${(order['items'] as int) == 1 ? 'item' : 'items'} · ${order['time']}', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${order['amount']}', style: AppTextStyles.subtitle),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text('Delivered', style: AppTextStyles.caption.copyWith(color: const Color(0xFF16A34A), fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildTimerBox(String value, String label) {
    return Column(
      children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF1463FF).withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1463FF).withOpacity(0.2)),
          ),
          alignment: Alignment.center,
          child: Text(value, style: AppTextStyles.heading1.copyWith(color: const Color(0xFF1463FF), fontSize: 28)),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF94A3B8), fontSize: 10)),
      ],
    );
  }

  Widget _buildCurrentTabContent() {
    final stages = _cfg.orderStages;
    if (_activeTab == stages.first.id) return _buildFirstStageTab();
    if (_activeTab == stages[1].id) return _buildPreparingTab();
    if (stages.length > 3 && _activeTab == stages[stages.length - 2].id) return _buildReadyTab();
    if (_activeTab == stages.last.id) return _buildCompletedTab();
    return _buildReadyTab();
  }

  bool get _showStickyButton {
    final stages = _cfg.orderStages;
    return _activeTab == stages[1].id;
  }

  @override
  Widget build(BuildContext context) {
    final stages = _cfg.orderStages;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F6F6).withOpacity(0.95),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Vendor Orders', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF1463FF)),
                const SizedBox(width: 4),
                Text('Scheduled', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF1463FF))),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(LucideIcons.bell, size: 18, color: Color(0xFF334155)),
                onPressed: () {},
              ),
              Positioned(
                top: 10, right: 10,
                child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF1463FF), shape: BoxShape.circle)),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: Column(
            children: [
              Container(color: const Color(0xFFE8E4E4), height: 1),
              _buildTabBar(),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: _showStickyButton ? 100 : 24),
            child: Column(
              children: [
                // Quick Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(LucideIcons.check, size: 14, color: Color(0xFF475569)),
                        label: Text('Batch Actions', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF475569))),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Colors.white,
                          minimumSize: const Size(0, 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(LucideIcons.fileText, size: 14, color: Color(0xFF475569)),
                        label: Text('Print Orders', style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF475569))),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Colors.white,
                          minimumSize: const Size(0, 40),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildCurrentTabContent(),
              ],
            ),
          ),
          if (_showStickyButton)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _markedReady = true;
                        _activeTab = stages[stages.length - 2].id;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1463FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Mark as ${stages[stages.length - 2].label}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
