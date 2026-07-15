import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'errand_form_screen.dart';
import 'parcel_selection_screen.dart';
import 'buy_deliver_screen.dart';
import '../models/errand_type.dart';
class ErrandSelectionScreen extends StatelessWidget {
  const ErrandSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
                        ),
                        const Spacer(),
                        Text(
                          'Errand',
                          style: AppFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                  ),
                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      'What do you need help with?',
                      style: AppFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Service list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParcelSelectionScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                      boxShadow: const [
                        BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 1)),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0x1A0052CC),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(Icons.local_shipping_outlined, color: Color(0xFF0068FF), size: 26),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Send a Parcel',
                                  style: AppFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Documents, packages, and fragile items',
                                  style: AppFonts.inter(
                                    fontSize: 14,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildServiceTile(
                  context: context,
                  icon: Icons.swap_horiz_rounded,
                  title: 'Pickup & Drop-off',
                  subtitle: 'Pick up an item and deliver it somewhere',
                  type: ErrandType.pickupDropOff,
                ),
                _buildServiceTile(
                  context: context,
                  icon: Icons.shopping_bag_outlined,
                  title: 'Buy & Deliver',
                  subtitle: 'Purchase items and deliver to you',
                  type: ErrandType.buyDeliver,
                ),
                _buildServiceTile(
                  context: context,
                  icon: Icons.autorenew_rounded,
                  title: 'Return / Exchange',
                  subtitle: 'Return items to a vendor or shop',
                  type: ErrandType.returnExchange,
                ),
                _buildServiceTile(
                  context: context,
                  icon: Icons.school_outlined,
                  title: 'School & Hostel',
                  subtitle: 'Provisions, books, student deliveries',
                  type: ErrandType.schoolHostel,
                ),
                // Other Errand — dashed border, different style
                _buildOtherErrandTile(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required ErrandType type,
  }) {
    return GestureDetector(
      onTap: () {
        if (type == ErrandType.buyDeliver) {
           Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BuyDeliverScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ErrandFormScreen(errandType: type, title: title),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const [
            BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 1)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0x1A0052CC),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(icon, color: const Color(0xFF0068FF), size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherErrandTile(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ErrandFormScreen(
              errandType: ErrandType.other,
              title: 'Custom Errand',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0x660052CC),
            width: 1.5,
            // Dashed via CustomPainter is complex, styled border gives the "special" feel
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.more_horiz, color: Color(0xFF475569), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Other Errand',
                      style: AppFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Something else? Describe your task',
                      style: AppFonts.inter(fontSize: 14, color: const Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 20),
            ],
          ),
        ),
      ),
    );
  }

}
