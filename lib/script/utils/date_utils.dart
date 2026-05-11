mixin DateUtils {
  static bool isDateInRange(DateTime date, DateTime start, DateTime end) {
    // Ensure start is before or equal to end
    if (start.isAfter(end)) {
      final temp = start;
      start = end;
      end = temp;
    }

    // Inclusive range check
    return (date.isAtSameMomentAs(start) || date.isAfter(start)) &&
        (date.isAtSameMomentAs(end) || date.isBefore(end));
  }

  static int dateToInt(DateTime d) => d.millisecondsSinceEpoch;
}

extension DateExtension on DateTime {
  int toInt() => millisecondsSinceEpoch;
}
