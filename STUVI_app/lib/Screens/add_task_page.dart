import 'package:flutter/material.dart';
import 'package:STUVI_app/Screens/home_screen.dart';
import '../utils/date_time.dart';

class AddTaskPage extends StatefulWidget {
  final String title;
  final String description;
  final int date;
  final String emoji;
  final int hour;
  final int minute;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final ValueChanged<int> onChangedDate;
  final VoidCallback onSavedToDo;
  final Function onShowEmojiKeyboard;
  final Function onHideEmojiKeyboard;
  final ValueChanged<int> onChangedHour;
  final ValueChanged<int> onChangedMinute;

  const AddTaskPage(
      {Key? key,
      this.title = '',
      this.description = '',
      this.date = 0,
      this.emoji = '',
      this.hour = 0,
      this.minute = 0,
      required this.onChangedTitle,
      required this.onChangedDescription,
      required this.onChangedDate,
      required this.onSavedToDo,
      required this.onShowEmojiKeyboard,
      required this.onHideEmojiKeyboard,
      required this.onChangedHour,
      required this.onChangedMinute})
      : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TimeOfDay timeOfDay = TimeOfDay(hour: 00, minute: 00);
  DateTime selectedDate = DateTime.now();
  TextEditingController _controller = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _emojiController = TextEditingController();
  bool emojiShowing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = TextEditingController(
        text: DateTimeUtil.getFormattedStartTime(widget.hour, widget.minute));
    if (widget.date != 0) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(widget.date);
      String formattedDate = date.day.toString() +
          "/" +
          date.month.toString() +
          "/" +
          date.year.toString();

      _dateController = TextEditingController(text: formattedDate);
    }

    _emojiController = TextEditingController(text: widget.emoji);
  }

  void timePicker() async {
    widget.onHideEmojiKeyboard();
    showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          child: child!,
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
                primary: Color(0xFF31AFE1), // <-- SEE HERE// <-- SEE HERE
                onSurface: Colors.black),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary // <-- SEE HERE
                ),
          ),
        );
      },
      initialTime: TimeOfDay.now(),
    ).then((value) {
      int? hour = value?.hourOfPeriod;
      int? minute = value?.minute;
      String? period = value?.period.name;
      if (hour != null && minute != null && period != null) {
        _controller.text = DateTimeUtil.getFormattedStartTime(hour, minute);
        widget.onChangedHour(hour);
        widget.onChangedMinute(minute);
      }
    });
  }

  Widget buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontFamily: 'Oxygen', color: Colors.black, fontSize: 15),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: ((context) => HomeScreen()),
            ),
          );
        }, //Add pages
        iconSize: 25,
      ),
      elevation: 5,
      backgroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontSize: 20, color: Colors.black, fontFamily: 'OxygenBold'),
      title: Text(
        'Task Page',
      ),
    );

    Widget buildTitle() => Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            autofocus: false,
            onTap: () => widget.onHideEmojiKeyboard(),
            maxLines: 1,
            textInputAction: TextInputAction.next,
            initialValue: widget.title,
            onChanged: widget.onChangedTitle,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFEBEBEB),
              prefixIcon: Icon(Icons.title_rounded),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Enter Title",
              hintStyle: TextStyle(color: Color(0xFF808080)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 0, style: BorderStyle.none),
              ),
            ),
          ),
        );

    Widget buildTime() => Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            readOnly: true,
            autofocus: false,
            onTap: timePicker,
            controller: _controller,
            maxLines: 1,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFEBEBEB),
              prefixIcon: Icon(Icons.access_time_filled),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Enter Start Time",
              hintStyle: TextStyle(color: Color(0xFF808080)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            ),
          ),
        );

    Future<void> _selectDate(BuildContext context) async {
      widget.onHideEmojiKeyboard();
      final DateTime? picked = await showDatePicker(
          context: context,
          builder: (context, child) {
            return Theme(
              child: child!,
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                    primary: Color(0xFF31AFE1), // <-- SEE HERE
                    onPrimary: Colors.white, // <-- SEE HERE
                    onSurface: Colors.black),
                buttonTheme: ButtonThemeData(
                    textTheme: ButtonTextTheme.primary // <-- SEE HERE
                    ),
              ),
            );
          },
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate) {
        String formattedDate = picked.day.toString() +
            "/" +
            picked.month.toString() +
            "/" +
            picked.year.toString();
        widget.onChangedDate(picked.toUtc().millisecondsSinceEpoch);
        _dateController.text = formattedDate;
      }
      ;
    }

    Widget buildDate() => Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            readOnly: true,
            autofocus: false,
            onTap: () => _selectDate(context),
            maxLines: 1,
            controller: _dateController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFEBEBEB),
              prefixIcon: Icon(Icons.calendar_month_rounded),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Enter Date",
              hintStyle: TextStyle(color: Color(0xFF808080)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            ),
          ),
        );

    Widget buildEmoji() => Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            readOnly: true,
            autofocus: false,
            onTap: () => ({widget.onShowEmojiKeyboard(_emojiController)}),
            controller: _emojiController,
            maxLines: 1,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFEBEBEB),
              prefixIcon: Icon(Icons.emoji_symbols_rounded),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Enter Emoji",
              hintStyle: TextStyle(color: Color(0xFF808080)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            ),
          ),
        );

    Widget buildDescription() => Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            autofocus: false,
            onTap: () => widget.onHideEmojiKeyboard(),
            maxLines: 5,
            textInputAction: TextInputAction.next,
            initialValue: widget.description,
            onChanged: widget.onChangedDescription,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFEBEBEB),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Enter Description",
              hintStyle: TextStyle(color: Color(0xFF808080)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            ),
          ),
        );

    final buildButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      color: Color(0xFF31AFE1),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        minWidth: MediaQuery.of(context).size.width * 0.5,
        onPressed: () {
          widget.onSavedToDo();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }, // Replace with the save to database
        child: Text(
          'Save',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontFamily: 'OxygenBold'),
        ),
      ),
    );

    return Expanded(
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              buildLabel("Title"),
              buildTitle(),
              SizedBox(height: 8),
              buildLabel("Date"),
              SizedBox(height: 8),
              buildDate(),
              SizedBox(height: 8),
              buildLabel("Start Time"),
              SizedBox(height: 8),
              buildTime(),
              SizedBox(height: 8),
              buildLabel("Emoji"),
              SizedBox(height: 8),
              buildEmoji(),
              SizedBox(height: 8),
              buildLabel("Description"),
              SizedBox(height: 8),
              buildDescription(),
              SizedBox(height: 15),
              buildButton,
            ],
          ),
        ),
      ),
    );
  }
}
