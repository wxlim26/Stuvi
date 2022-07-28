import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final Function(TextEditingController) onShowEmojiKeyboard;
  final Function onDateChange;
  final DateTime dateTime;

  CalendarWidget(
      {Key? key,
      required this.onShowEmojiKeyboard,
      required this.onDateChange,
      required this.dateTime})
      : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final calendar = TableCalendar(
      rowHeight: 45,
      firstDay: DateTime.utc(1950, 1, 1),
      lastDay: DateTime.utc(3000, 1, 1),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        selectedDecoration:
            BoxDecoration(color: Color(0xFF31AFE1), shape: BoxShape.circle),
        selectedTextStyle: TextStyle(color: Colors.white),
        todayDecoration:
            BoxDecoration(color: Color(0xFF89CFF0), shape: BoxShape.circle),
      ),
      headerStyle: HeaderStyle(formatButtonShowsNext: false),
      currentDay: widget.dateTime,
      focusedDay: widget.dateTime,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
        });
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
    );

    final selectButton = Padding(
      padding: EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () {
          widget.onDateChange(_selectedDay);
        },
        child: Text(
          'SELECT',
          style: TextStyle(
              color: Color(0xFF31AFE1), fontFamily: 'OxygenBold', fontSize: 15),
        ),
      ),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              calendar,
              SizedBox(height: 15),
              selectButton,
            ],
          ),
        ),
      ),
    );
  }
}
