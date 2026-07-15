import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import '../models/order.dart';
import '../models/service_type.dart';
import 'chat_screen.dart';

const Color _primary = Color(0xFF0068FF);
const Color _dark = Color(0xFF0F172A);
const Color _mid = Color(0xFF64748B);
const Color _border = Color(0xFFE8EDF2);

class _IssueCategory {
  final IconData icon;
  final String label;
  const _IssueCategory(this.icon, this.label);
}

const List<_IssueCategory> _kIssueCategories = [
  _IssueCategory(Icons.remove_shopping_cart_rounded, 'Item(s) missing'),
  _IssueCategory(Icons.swap_horiz_rounded, 'Wrong item(s) delivered'),
  _IssueCategory(Icons.broken_image_rounded, 'Item arrived damaged'),
  _IssueCategory(Icons.schedule_rounded, 'Order arrived late'),
  _IssueCategory(Icons.payments_rounded, 'Charged incorrectly'),
  _IssueCategory(Icons.person_off_rounded, 'Rider issue'),
  _IssueCategory(Icons.more_horiz_rounded, 'Something else'),
];

/// "Report an issue" scoped to a specific order — previously Help & Support
/// only offered a generic FAQ/chat/contact flow with no way to flag a
/// problem tied to a particular order.
class ReportIssueScreen extends StatefulWidget {
  final Order order;
  const ReportIssueScreen({super.key, required this.order});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  int? _selectedCategory;
  final TextEditingController _detailsCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _detailsCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_selectedCategory == null) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final category = _kIssueCategories[_selectedCategory!].label;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Report submitted', style: AppFonts.inter(fontWeight: FontWeight.w700, fontSize: 17)),
        content: Text(
          'Thanks — we\'ve logged "$category" for order ${widget.order.id}. Our support team will follow up shortly.',
          style: AppFonts.inter(fontSize: 14, color: _mid),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text('Done', style: AppFonts.inter(fontWeight: FontWeight.w600, color: _mid)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Text('Chat with support', style: AppFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Report an Issue', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: _border, height: 1)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
            child: Row(
              children: [
                Icon(widget.order.serviceType.icon, color: _primary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.order.vendorName, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: _dark)),
                      Text(widget.order.id, style: AppFonts.inter(fontSize: 12, color: _mid)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('WHAT WENT WRONG?', style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: _mid, letterSpacing: 0.8)),
          const SizedBox(height: 10),
          ...List.generate(_kIssueCategories.length, (i) {
            final cat = _kIssueCategories[i];
            final selected = _selectedCategory == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                    color: selected ? _primary.withOpacity(0.06) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: selected ? _primary : _border, width: selected ? 1.5 : 1),
                  ),
                  child: Row(
                    children: [
                      Icon(cat.icon, color: selected ? _primary : _mid, size: 20),
                      const SizedBox(width: 12),
                      Expanded(child: Text(cat.label, style: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _dark))),
                      Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, color: selected ? _primary : _mid, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          Text('DETAILS (OPTIONAL)', style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: _mid, letterSpacing: 0.8)),
          const SizedBox(height: 10),
          TextField(
            controller: _detailsCtrl,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tell us more about what happened...',
              hintStyle: AppFonts.inter(fontSize: 14, color: _mid),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _primary, width: 2)),
            ),
            style: AppFonts.inter(fontSize: 14),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _selectedCategory == null || _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _border,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: _isSubmitting
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : Text('Submit Report', style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
