class DateTimeUtil {
  static String getFormattedStartTime(int hour, int minute) {
    try {
      if (hour == 0 && minute == 0) {
        return "";
      }
      bool isPM = hour > 12;
      String period = isPM ? "PM" : "AM";
      if (hour == 12) {
        hour = hour - 1;
      }
      int newHour = isPM ? hour - 12 : hour;
      String strHour = newHour.toString();
      String strMinute = minute.toString();
      if (hour < 10) {
        strHour = "0" + strHour;
      }
      if (minute < 10) {
        strMinute = "0" + strMinute;
      }
      String formattedTime =
          strHour + ":" + strMinute + " " + period.toUpperCase();

      return formattedTime;
    } catch (e) {
      return "";
    }
  }

  static DateTime getTodayDate() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime getDate(date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime getYesterday(date) {
    return DateTime(date.year, date.month, date.day - 1);
  }

  static DateTime getEndDate(date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
}
