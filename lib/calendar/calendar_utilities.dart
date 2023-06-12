import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../model/Subject.dart';

class CalendarUtils {
  final List<Subject> subjects;
  CalendarFormat format = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  CalendarUtils(this.subjects);

  void onFormatChanged(CalendarFormat newFormat) {
    format = newFormat;
  }

  void onPageChanged(DateTime newFocusedDay) {
    focusedDay = newFocusedDay;
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay = selectedDay;
    this.focusedDay = focusedDay;
  }

  bool hasSubject(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(date);
    final List<String> datesWithoutTime = subjects.map((subject) {
      final DateTime dateTime = DateFormat("MMM d, y h:mm a").parse(subject.date);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }).toList();
    return datesWithoutTime.any((subjectDate) => subjectDate == formattedDate);
  }
}