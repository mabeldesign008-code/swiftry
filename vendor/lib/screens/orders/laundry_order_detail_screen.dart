import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class LaundryOrderDetailScreen extends StatelessWidget {
  const LaundryOrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #YDO-78430',
                            style: AppTextStyles.heading2.copyWith(fontSize: 24, letterSpacing: -0.36),
                          ),
                          Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1463FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Laundry',
                              style: AppTextStyles.captionBold.copyWith(color: const Color(0xFF1463FF)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Laundry Vendor Flow',
                        style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                  child: _buildStatusFlow(),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildPickupScheduleCard(),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Items', style: AppTextStyles.subtitle.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _buildLaundryItem(LucideIcons.shirt, 'Shirt', 'Wash & Iron', '3x'),
                      const SizedBox(height: 12),
                      _buildLaundryItem(LucideIcons.tag, 'Trouser', 'Dry Clean', '2x'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildSpecialInstructions(),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              bottom: false,
              child: Container(
                color: const Color(0xFFF8F6F6),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 8, 4, 9),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(LucideIcons.arrowLeft, size: 16, color: Color(0xFF1463FF)),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'Order Details',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), letterSpacing: -0.27),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(LucideIcons.moreVertical, size: 16, color: Color(0xFF0F172A)),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Container(height: 1, color: const Color(0xFF1463FF).withOpacity(0.1)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              color: const Color(0xFFF8F6F6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 1, color: const Color(0xFF1463FF).withOpacity(0.1)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(LucideIcons.checkCircle, size: 20),
                        label: const Text('Mark Ready for Return', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1463FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFlow() {
    final steps = [
      {'label': 'Accepted', 'done': true},
      {'label': 'Received', 'done': true},
      {'label': 'Processing', 'done': true},
      {'label': 'Ready', 'done': false},
      {'label': 'Returned', 'done': false},
    ];
    return Row(
      children: steps.asMap().entries.map((entry) {
        final i = entry.key;
        final step = entry.value;
        final isDone = step['done'] as bool;
        final isLast = i == steps.length - 1;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDone ? const Color(0xFF1463FF) : const Color(0xFFE2E8F0),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(LucideIcons.check, size: 12, color: isDone ? Colors.white : const Color(0xFF94A3B8)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step['label'] as String,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDone ? const Color(0xFF1463FF) : const Color(0xFF94A3B8), letterSpacing: 0.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 24),
                    color: isDone ? const Color(0xFF1463FF) : const Color(0xFFEC5B13).withOpacity(0.2),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPickupScheduleCard() {
    return Container(
      height: 78,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEC5B13).withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pickup Schedule', style: AppTextStyles.subtitle.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar, size: 11, color: Color(0xFF1463FF)),
                      const SizedBox(width: 4),
                      Text('Mar 3, 10AM-12PM', style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF1463FF), fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF1463FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.shirt, size: 20, color: Color(0xFF1463FF)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaundryItem(IconData icon, String name, String service, String qty) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEC5B13).withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: const Color(0xFF1463FF).withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                alignment: Alignment.center,
                child: Icon(icon, size: 18, color: const Color(0xFF1463FF)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.subtitle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(service, style: AppTextStyles.caption.copyWith(color: const Color(0xFF64748B))),
                ],
              ),
            ],
          ),
          Text(qty, style: AppTextStyles.subtitle.copyWith(color: const Color(0xFF1463FF), fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSpecialInstructions() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEC5B13).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: Color(0xFF1463FF), width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.alertCircle, size: 15, color: Color(0xFF1463FF)),
                const SizedBox(width: 8),
                Text('Special Instructions', style: AppTextStyles.subtitle.copyWith(color: const Color(0xFF1463FF), fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Text('"Separate whites, no bleach"', style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF334155))),
          ],
        ),
      ),
    );
  }
}
