import 'package:intl/intl.dart';

extension DateTimeFormattingExtensions on DateTime? {
  String toFormattedDateOnly({String fallback = 'N/A'}) {
    if (this == null) return fallback;
    return DateFormat.yMMMd().format(this!);
  }

  String toFormattedDateWithShortMonth({String fallback = 'N/A'}) {
    if (this == null) return fallback;
    return DateFormat('d MMM, yyyy').format(this!);
  }

  String toFormattedTimeOnly({String fallback = 'N/A'}) {
    if (this == null) return fallback;
    return DateFormat.jm().format(this!);
  }

  String toFormattedDateTime({String fallback = 'N/A'}) {
    if (this == null) return fallback;
    return DateFormat.yMMMd().add_jm().format(this!);
  }

  String toIsoDateString({String fallback = 'N/A'}) {
    if (this == null) return fallback;
    return DateFormat('yyyy-MM-dd').format(this!);
  }

  String toFormattedDayMonth({String fallback = 'N/A'}) {
    if (this == null) return fallback;
    return DateFormat('d MMM').format(this!);
  }

  String toFormattedWeekdayDate({String fallback = 'N/A'}) {
    if (this == null) return fallback;
    return DateFormat('EEE, d MMM').format(this!);
  }
}

// We can also add extensions on non-nullable DateTime if you are sure it won't be null
// extension NonNullableDateTimeFormattingExtensions on DateTime {
//   String get yMMMd => DateFormat.yMMMd().format(this);
// }
