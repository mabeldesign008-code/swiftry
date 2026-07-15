import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';

const Color _primary = Color(0xFF0068FF);
const Color _dark = Color(0xFF0F172A);
const Color _mid = Color(0xFF64748B);
const Color _border = Color(0xFFE8EDF2);

const List<String> kCancelReasons = [
  'Changed my mind',
  'Order is taking too long',
  'Wrong items or address',
  'Found a better price elsewhere',
  'Ordered by mistake',
  'Other',
];

/// Asks *why* the user is cancelling before confirming — previously both
/// cancel flows (`order_detail_screen.dart`, `order_tracking_screen.dart`)
/// jumped straight to "Cancel this order? Yes/No" with no reason captured.
/// Returns the selected reason string, or `null` if dismissed.
class CancelReasonModal extends StatefulWidget {
  const CancelReasonModal({super.key});

  @override
  State<CancelReasonModal> createState() => _CancelReasonModalState();
}

class _CancelReasonModalState extends State<CancelReasonModal> {
  String? _selected;
  final TextEditingController _otherCtrl = TextEditingController();

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

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
          Text('Why are you cancelling?', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: _dark)),
          const SizedBox(height: 4),
          Text('This helps us improve swiftree for everyone.', style: AppFonts.inter(fontSize: 13, color: _mid)),
          const SizedBox(height: 16),
          ...kCancelReasons.map((reason) {
            final selected = _selected == reason;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selected = reason),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                    color: selected ? _primary.withOpacity(0.06) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: selected ? _primary : _border, width: selected ? 1.5 : 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                        color: selected ? _primary : _mid,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(reason, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _dark))),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (_selected == 'Other') ...[
            const SizedBox(height: 4),
            TextField(
              controller: _otherCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Tell us more (optional)',
                hintStyle: AppFonts.inter(fontSize: 14, color: _mid),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primary, width: 2)),
              ),
              style: AppFonts.inter(fontSize: 14),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _selected == null
                  ? null
                  : () {
                      final detail = _selected == 'Other' && _otherCtrl.text.trim().isNotEmpty
                          ? 'Other: ${_otherCtrl.text.trim()}'
                          : _selected!;
                      Navigator.pop(context, detail);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                disabledBackgroundColor: _border,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Continue to Cancel', style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Keep My Order', style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _mid)),
            ),
          ),
        ],
      ),
    );
  }
}
