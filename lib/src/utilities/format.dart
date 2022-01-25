
import 'package:intl/intl.dart';

class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    try {
      DateTime notificationDate = DateFormat("yyyy-MM-dd'T'hh:mm:ss.SSS'Z'")
          .parse(dateString, true)
          .toUtc()
          .toLocal();
      final date2 = DateTime.now();
      final difference = date2.difference(notificationDate);
      if (difference.inDays > 8) {
        return '${notificationDate.year}/${notificationDate.month}/${notificationDate.day}';
      } else if ((difference.inDays / 7).floor() >= 1) {
        return (numericDates) ? '1 week ago' : 'Last week';
      } else if (difference.inDays >= 2) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays >= 1) {
        return (numericDates) ? '1 day ago' : 'Yesterday';
      } else if (difference.inHours >= 2) {
        return '${difference.inHours} hours ago';
      } else if (difference.inHours >= 1) {
        return (numericDates) ? '1 hour ago' : 'An hour ago';
      } else if (difference.inMinutes >= 2) {
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inMinutes >= 1) {
        return (numericDates) ? '1 minute ago' : 'A minute ago';
      } else if (difference.inSeconds >= 3) {
        return '${difference.inSeconds} seconds ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  static String jobNewStatusDate(
      String dateString,
      String statusJob,
      ) {
    try {
      DateTime notificationDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(dateString, true)
          .toUtc()
          .toLocal();
      final date2 = DateTime.now();
      final difference = date2.difference(notificationDate);
      if (difference.inDays <= 1) {
        return statusJob;
      } else {
        return statusJob;
      }
    } catch (e) {
      return '';
    }
  }
}