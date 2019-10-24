import 'package:flutter/material.dart';
import 'package:ttc_service_alerts/config/config.dart';

//ignore: must_be_immutable
class TimeText extends StatefulWidget {
  /// The data and time of the tweet, used to calcualte how long ago it
  /// was
  final _dateTime;

  /// The text that will be displayed in the tweet saying how long
  /// ago the tweet occured
  String _howLongAgo;


  TimeText(this._dateTime) {
    // Setting the initial value for the time text
    _howLongAgo = _getTimeFrom(_dateTime);
  }

  /// This function updates the howLongAgo text for the tweet
  Null updateTime() {
    _howLongAgo = _getTimeFrom(_dateTime);
  }

  /// Function that sets how long ago the tweet was, in minutes, hours, days, weeks, and months
  String _getTimeFrom(DateTime tweetTime) {
    // Current DateTime
    DateTime now = DateTime.now();

    // Find the difference between the 2 times
    var diff = now.difference(tweetTime).inMinutes;

    // The unit for the time
    String unit = "m";

    // If the time was 0 minutes ago, change the text to "Now"
    if (diff == 0) {
      return "Now";
    }

    // Getting the number of hours
    if (diff >= 60 && unit == "m") {
      unit = "h";
      diff = (diff / 60).floor();
    }
    // Getting days
    if (diff >= 24 && unit == "h") {
      unit = "d";
      diff = (diff / 24).floor();
    }
    // Getting weeks
    if (diff >= 7 && unit == "w") {
      unit = "w";
      diff = (diff / 7).floor();
    }
    // Getting months
    if (diff >= 4 && unit == "Mo") {
      unit = "Mo";
      diff = (diff / 4).floor();
    }
    // Getting years
    if (diff >= 12 && unit == "y") {
      unit = "y";
      diff = (diff / 12).floor();
    }

    // Putting the ending on the unit and returning it
    return diff.toString() + unit + " ago";
  }

  @override
  _TimeTextState createState() => _TimeTextState();
}

class _TimeTextState extends State<TimeText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget._howLongAgo,
      style: TextStyle(fontSize: timeFontSize),
    );
  }
}
