import 'package:STUVI_app/Screens/add_task_page.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:STUVI_app/model/todo.dart';
import 'package:STUVI_app/provider/todos.dart';

class EditTodoPage extends StatefulWidget {
  final Todo todo;
  final Function onShowEmojiKeyboard;
  const EditTodoPage(
      {Key? key, required this.todo, required this.onShowEmojiKeyboard})
      : super(key: key);

  @override
  _EditTodoPageState createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  int date = 0;
  String emoji = '';
  int hour = 0;
  int minute = 0;
  bool _showWidgetKeyboard = false;
  List<String> emojis = [];
  TextEditingController _emojiController = TextEditingController();

  void showEmojiKeyboard(TextEditingController contoller) {
    setState(() {
      _showWidgetKeyboard = true;
      _emojiController = contoller;
    });
  }

  void hideEmojiKeyboard() {
    setState(() {
      _showWidgetKeyboard = false;
    });
  }

  void onEmojiRemoved() {
    if (!emojis.isEmpty) {
      emojis.removeLast();
    }
    if (emojis.isEmpty) {
      setState(() {
        _showWidgetKeyboard = false;
      });
    }
    _emojiController.text = stringEmoji();
  }

  void _onEmojiSelected(Emoji emoji) {
    emojis.add(emoji.emoji);
    _emojiController.text = stringEmoji();
  }

  String stringEmoji() {
    return emojis.join("");
  }

  @override
  //get initial value of title and description
  void initState() {
    super.initState();

    title = widget.todo.title;
    description = widget.todo.description;
    date = widget.todo.date;
    hour = widget.todo.hour;
    minute = widget.todo.minute;
    emojis = widget.todo.emojis;
  }

  @override
  Widget build(BuildContext context) {
    void saveTodo() {
      final isValid = _formKey.currentState!.validate();

      if (!isValid) {
        return;
      } else {
        final provider = Provider.of<TodosProvider>(context, listen: false);
        provider.updateTodo(
            widget.todo, title, description, date, hour, minute, emojis);
        Navigator.of(context).pop();
      }
    }

    final appBar = AppBar(
      elevation: 5,
      backgroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontSize: 20, color: Colors.black, fontFamily: 'OxygenBold'),
      title: Text(
        'Edit Task',
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: AddTaskPage(
              title: title,
              date: date,
              emoji: stringEmoji(),
              description: description,
              hour: hour,
              minute: minute,
              onChangedTitle: (title) => setState(() => this.title = title),
              onChangedDate: (date) => setState(() => this.date = date),
              onChangedHour: (hour) => setState(() => this.hour = hour),
              onChangedMinute: (minute) => setState(() => this.minute = minute),
              onChangedDescription: (description) =>
                  setState(() => this.description = description),
              onShowEmojiKeyboard: (TextEditingController controller) =>
                  {showEmojiKeyboard(controller)},
              onHideEmojiKeyboard: () => {hideEmojiKeyboard()},
              onSavedToDo: saveTodo,
            ),
          ),
          Offstage(
            offstage: !_showWidgetKeyboard,
            child: SizedBox(
              height: 250,
              child: EmojiPicker(
                  onEmojiSelected: (Category category, Emoji emoji) {
                    _onEmojiSelected(emoji);
                  },
                  onBackspacePressed: onEmojiRemoved,
                  config: Config(
                      columns: 7,
                      // Issue: https://github.com/flutter/flutter/issues/28894
                      emojiSizeMax: 32,
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: const Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      progressIndicatorColor: Colors.blue,
                      backspaceColor: Colors.blue,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      showRecentsTab: true,
                      recentsLimit: 28,
                      replaceEmojiOnLimitExceed: false,
                      noRecents: const Text(
                        'No Recents',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,
                      ),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL)),
            ),
          ),
        ],
      ),
    );
  }
}
