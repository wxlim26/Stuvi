import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:STUVI_app/Screens/daily_planner_page.dart';

class CalendarWidget extends StatefulWidget {
  final Function(TextEditingController) onShowEmojiKeyboard;

  CalendarWidget({Key? key, required this.onShowEmojiKeyboard})
      : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          // readTodosByDateAndStatus(String uid, int date)
        });
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );

    final selectButton = Padding(
      padding: EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: ((context) => DailyPlannerPage(
                    onShowEmojiKeyboard: (TextEditingController) {},
                    selectedDateTableCalendar: _selectedDay,
                  )),
            ),
          );
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
