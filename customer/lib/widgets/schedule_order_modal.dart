import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';

const Color _primary = Color(0xFF0068FF);
const Color _dark = Color(0xFF0F172A);
const Color _mid = Color(0xFF64748B);
const Color _border = Color(0xFFE8EDF2);
const Color _light = Color(0xFFF8FAFC);

const List<String> _kShortDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const List<String> _kShortMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

/// "Deliver Now" vs "Schedule for Later" sheet. Returns `null` for "now", or
/// the chosen [DateTime] otherwise. Previously only the laundry pickup flow
/// (`schedule_pickup_screen.dart`) had any scheduling — food/market/shop/etc.
/// checkout had no way to schedule an order ahead of time.
class ScheduleOrderModal extends StatefulWidget {
  final DateTime? initial;
  const ScheduleOrderModal({super.key, this.initial});

  @override
  State<ScheduleOrderModal> createState() => _ScheduleOrderModalState();
}

class _ScheduleOrderModalState extends State<ScheduleOrderModal> {
  late bool _scheduleLater = widget.initial != null;
  int _dayIndex = 0;
  int _timeIndex = 0;

  late final List<DateTime> _days = List.generate(5, (i) => DateTime.now().add(Duration(days: i)));
  final List<String> _timeSlots = const [
    '9:00 - 10:00 AM',
    '11:00 - 12:00 PM',
    '1:00 - 2:00 PM',
    '3:00 - 4:00 PM',
    '5:00 - 6:00 PM',
    '7:00 - 8:00 PM',
  ];

  DateTime get _selectedDateTime {
    final day = _days[_dayIndex];
    // Parse the start hour out of the slot label, e.g. "9:00 - 10:00 AM" -> 9, pm-aware via the slot's own am/pm marker.
    final slot = _timeSlots[_timeIndex];
    final isPm = slot.trim().endsWith('PM');
    final startHourStr = slot.split(':').first;
    int hour = int.tryParse(startHourStr) ?? 9;
    if (isPm && hour != 12) hour += 12;
    return DateTime(day.year, day.month, day.day, hour);
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
          Text('When should we deliver?', style: AppFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: _dark)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _modeCard('Deliver Now', Icons.bolt_rounded, !_scheduleLater, () => setState(() => _scheduleLater = false))),
              const SizedBox(width: 10),
              Expanded(child: _modeCard('Schedule for Later', Icons.calendar_month_rounded, _scheduleLater, () => setState(() => _scheduleLater = true))),
            ],
          ),
          if (_scheduleLater) ...[
            const SizedBox(height: 20),
            Text('DATE', style: AppFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: _mid, letterSpacing: 0.8)),
            const SizedBox(height: 10),
            SizedBox(
              height: 66,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final d = _days[i];
                  final selected = i == _dayIndex;
                  final label = i == 0 ? 'Today' : (i == 1 ? 'Tomorrow' : _kShortDays[d.weekday - 1]);
                  return GestureDetector(
                    onTap: () => setState(() => _dayIndex = i),
                    child: Container(
                      width: 72,
                      decoration: BoxDecoration(
                        color: selected ? _primary : _light,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: selected ? _primary : _border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(label, style: AppFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: selected ? Colors.white : _dark)),
                          const SizedBox(height: 2),
                          Text('${d.day} ${_kShortMonths[d.month - 1]}', style: AppFonts.inter(fontSize: 11, color: selected ? Colors.white70 : _mid)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('TIME SLOT', style: AppFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: _mid, letterSpacing: 0.8)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_timeSlots.length, (i) {
                final selected = i == _timeIndex;
                return GestureDetector(
                  onTap: () => setState(() => _timeIndex = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? _primary.withOpacity(0.08) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? _primary : _border, width: selected ? 1.5 : 1),
                    ),
                    child: Text(
                      _timeSlots[i],
                      style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? _primary : _dark),
                    ),
                  ),
                );
              }),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _scheduleLater ? _selectedDateTime : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Confirm', style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeCard(String label, IconData icon, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? _primary.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? _primary : _border, width: selected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? _primary : _mid, size: 22),
            const SizedBox(height: 8),
            Text(label, style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: selected ? _primary : _dark)),
          ],
        ),
      ),
    );
  }
}
