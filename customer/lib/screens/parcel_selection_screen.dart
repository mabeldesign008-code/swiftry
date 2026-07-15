import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:swiftree/core/theme/app_theme.dart';
import 'parcel_details_screen.dart';
import 'help_support_screen.dart';

class ParcelSelectionScreen extends StatefulWidget {
  const ParcelSelectionScreen({super.key});

  @override
  State<ParcelSelectionScreen> createState() => _ParcelSelectionScreenState();
}

class _ParcelSelectionScreenState extends State<ParcelSelectionScreen> {
  int _selectedCategoryIndex = -1;

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Documents',
      'subtitle': 'Papers, envelopes, and thin files',
      'icon': Icons.description_outlined,
      'color': const Color(0xFF0068FF),
    },
    {
      'title': 'Small Package',
      'subtitle': 'Fits in a shoebox (up to 2kg)',
      'icon': Icons.inventory_2_outlined,
      'color': const Color(0xFF0068FF),
    },
    {
      'title': 'Medium Package',
      'subtitle': 'Larger boxes (up to 10kg)',
      'icon': Icons.inventory_2,
      'color': const Color(0xFF0068FF),
    },
    {
      'title': 'Large Package',
      'subtitle': 'Bulkier items or heavy boxes',
      'icon': Icons.inventory,
      'color': AppTheme.secondary,
    },
    {
      'title': 'Fragile Item',
      'subtitle': 'Extra care & special handling',
      'icon': Icons.wine_bar,
      'color': AppTheme.secondary,
      'tag': 'Handle with Care',
    },
    {
      'title': 'Confidential',
      'subtitle': 'High-security delivery service',
      'icon': Icons.lock_outline,
      'color': const Color(0xFF475569),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Color(0xFF334155)),
        ),
        title: Text(
          'Send a Parcel',
          style: AppFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen())),
            icon: const Icon(Icons.help_outline, color: Color(0xFF334155)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STEP 1 OF 5',
                      style: AppFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0068FF),
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      'Parcel Type',
                      style: AppFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.2, // 1 of 5
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0068FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
            children: [
              Text(
                'What are you sending?',
                style: AppFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Select the category that best fits your item.',
                style: AppFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 32),
              ...List.generate(_categories.length, (index) {
                final cat = _categories[index];
                final isSelected = _selectedCategoryIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategoryIndex = index),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF0068FF) : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: (cat['color'] as Color).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(cat['icon'], color: cat['color']),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      cat['title'],
                                      style: AppFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    if (cat['tag'] != null) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0x33FBBF24),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          cat['tag'].toUpperCase(),
                                          style: AppFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFA16207),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cat['subtitle'],
                                  style: AppFonts.inter(
                                    fontSize: 14,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: Color(0xFF0068FF)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0x1A0052CC)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF0068FF), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Pricing is calculated based on category and delivery speed. You\'ll enter weight details in the next step.',
                        style: AppFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedCategoryIndex == -1
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParcelDetailsScreen(
                                  category: _categories[_selectedCategoryIndex]['title'],
                                ),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0068FF),
                      disabledBackgroundColor: const Color(0xFF94A3B8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Continue',
                      style: AppFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
