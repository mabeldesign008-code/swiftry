import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';

const Color _primary = Color(0xFF0068FF);
const Color _dark = Color(0xFF0F172A);
const Color _mid = Color(0xFF64748B);
const Color _border = Color(0xFFE8EDF2);

enum VendorSortBy { recommended, ratingHighToLow, deliveryTimeFastest, priceLowToHigh }

extension VendorSortByX on VendorSortBy {
  String get label {
    switch (this) {
      case VendorSortBy.recommended:
        return 'Recommended';
      case VendorSortBy.ratingHighToLow:
        return 'Rating: High to Low';
      case VendorSortBy.deliveryTimeFastest:
        return 'Delivery Time: Fastest';
      case VendorSortBy.priceLowToHigh:
        return 'Delivery Fee: Low to High';
    }
  }
}

/// Result of the Filter & Sort sheet. Applied by the caller against its own
/// (mock) vendor list.
class FilterSortResult {
  final VendorSortBy sortBy;
  final double minRating;
  final bool openNowOnly;

  const FilterSortResult({
    this.sortBy = VendorSortBy.recommended,
    this.minRating = 0,
    this.openNowOnly = false,
  });

  bool get isDefault => sortBy == VendorSortBy.recommended && minRating == 0 && !openNowOnly;
}

/// Filter & Sort bottom sheet, shared by vendor listing / search screens.
/// Previously the "Sort" and "Filters" buttons on `vendor_list_screen.dart`
/// were both no-op snackbars ("coming soon").
class FilterSortModal extends StatefulWidget {
  final FilterSortResult initial;
  const FilterSortModal({super.key, this.initial = const FilterSortResult()});

  @override
  State<FilterSortModal> createState() => _FilterSortModalState();
}

class _FilterSortModalState extends State<FilterSortModal> {
  late VendorSortBy _sortBy = widget.initial.sortBy;
  late double _minRating = widget.initial.minRating;
  late bool _openNowOnly = widget.initial.openNowOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sort & Filter', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: _dark)),
              TextButton(
                onPressed: () => setState(() {
                  _sortBy = VendorSortBy.recommended;
                  _minRating = 0;
                  _openNowOnly = false;
                }),
                child: Text('Reset', style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: _mid)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('SORT BY', style: AppFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: _mid, letterSpacing: 0.8)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: VendorSortBy.values.map((s) {
              final selected = _sortBy == s;
              return GestureDetector(
                onTap: () => setState(() => _sortBy = s),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: selected ? _primary.withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: selected ? _primary : _border, width: selected ? 1.5 : 1),
                  ),
                  child: Text(
                    s.label,
                    style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? _primary : _dark),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text('MINIMUM RATING', style: AppFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: _mid, letterSpacing: 0.8)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [0.0, 4.0, 4.3, 4.5, 4.8].map((r) {
              final selected = _minRating == r;
              final label = r == 0 ? 'Any' : '$r★+';
              return GestureDetector(
                onTap: () => setState(() => _minRating = r),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: selected ? _primary.withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: selected ? _primary : _border, width: selected ? 1.5 : 1),
                  ),
                  child: Text(
                    label,
                    style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? _primary : _dark),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _openNowOnly,
            onChanged: (v) => setState(() => _openNowOnly = v),
            activeThumbColor: _primary,
            title: Text('Open now only', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(
                context,
                FilterSortResult(sortBy: _sortBy, minRating: _minRating, openNowOnly: _openNowOnly),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Apply', style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
