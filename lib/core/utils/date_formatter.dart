import 'package:intl/intl.dart';

class DateFormatter {
  static final _full = DateFormat('dd MMM yyyy, hh:mm a');
  static final _date = DateFormat('dd MMM yyyy');
  static final _time = DateFormat('hh:mm a');

  static String formatFull(DateTime dt) => _full.format(dt);
  static String formatDate(DateTime dt) => _date.format(dt);
  static String formatTime(DateTime dt) => _time.format(dt);

  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formatDate(dt);
  }
}
