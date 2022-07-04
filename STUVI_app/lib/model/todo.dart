import 'package:STUVI_app/utils.dart';

class TodoField {
  static const createdTime = 'createdTime';
}

class Todo {
  DateTime createdTime;
  String title;
  String uid;
  String id;
  String description;
  bool isDone;
  int date;
  int hour;
  int minute;
  List<String> emojis;

  Todo(
      {required this.createdTime,
      required this.title,
      this.description = '',
      required this.uid,
      required this.id,
      this.isDone = false,
      this.date = 0,
      this.hour = 0,
      this.minute = 0,
      this.emojis = const []});

  static Todo fromJson(Map<String, dynamic> json) => Todo(
        createdTime: Utils.toDateTime(json['createdTime']),
        title: json['title'],
        description: json['description'],
        uid: json['uid'],
        id: json['id'],
        isDone: json['isDone'],
        date: json['date'],
        hour: json['hour'],
        minute: json['minute'],
        emojis:
            (json['emojis'] as List<dynamic>).map((e) => e as String).toList(),
      );

  Map<String, dynamic> toJson() => {
        'createdTime': Utils.fromDateTimeToJson(createdTime),
        'title': title,
        'description': description,
        'uid': uid,
        'id': id,
        'isDone': isDone,
        'date': date,
        'hour': hour,
        'minute': minute,
        'emojis': emojis,
      };
}
