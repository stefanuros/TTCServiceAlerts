import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ttc_service_alerts/config/ttcInfo.dart';

/// This class is a tweet list item
// TODO Add error checking if something goes wrong
class TweetItem extends StatelessWidget { //ignore: must_be_immutable
  /// The id of the tweet
  String _tweetId;

  /// The tweet text
  String _tweetText;

  /// The time of the tweet
  DateTime _dateTime;

  /// How long ago the tweet was
  String _howLongAgo;

  /// The transit line in question
  List<Map> _chipText;

  /// This class is a tweet list item
  TweetItem(tweetMap) {
    _tweetId = tweetMap["id_str"];
    _tweetText = tweetMap["full_text"];

    // Create a formatter for this datetime
    // Wed Oct 02 23:28:13 +0000 2019
    // * Removing the timezone with substring
    var f = new DateFormat('EEE MMM dd HH:mm:ss yyyy');

    // Use the formatter to parse the datetime
    _dateTime = f
        .parse(
          tweetMap["created_at"].substring(0, 20) +
              tweetMap["created_at"].substring(26, 30),
        )
        // Subtract 4 hours because tweets come in with UTC time so this converts
        // it back to toronto time
        .subtract(
          Duration(
            hours: 4,
          ),
        );

    // Get how long ago the tweet was, in minutes, hours, days, weeks, and months
    _howLongAgo = _getTimeFrom(_dateTime);

    // Use Regex to find the affected lines in the tweet
    _chipText = _createChipText(_tweetText);

    // Sort the chips in order of icon type. This groups the chips based on the
    // type of transit
    _chipText.sort((a, b) {
      return b["icon"].codePoint - a["icon"].codePoint;
    });

    // Sort the line numbers
    _chipText.sort((a, b) {
      // If they are not the same icon, return a 0 to not sort them
      if(b["icon"].codePoint - a["icon"].codePoint != 0) {
        return 0;
      }

      // Strip all non numeric characters for comparing
      // This deals with situations where line 504A appears, while this is a subline
      // of line 504
      final intRegex = RegExp(r'\d{1,3}');
      int strippedA = int.parse(intRegex.stringMatch(a["text"]));
      int strippedB = int.parse(intRegex.stringMatch(b["text"]));

      // Sort based on the line number
      return strippedA - strippedB;
    });
  }

  String get tweetId {
    return _tweetId;
  }

  /// Function that sets how long ago the tweet was, in minutes, hours, days, weeks, and months
  String _getTimeFrom(DateTime tweetTime) {
    // Current DateTime
    DateTime now = DateTime.now();

    // Find the difference between the 2 times
    var diff = now.difference(tweetTime).inMinutes;

    // The unit for the time
    String unit = "m";

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
    return diff.toString() + unit;
  }

  /// This function takes the tweet text and
  List<Map> _createChipText(s) {
    // Loop through the list of regular expressions, and remove all matches
    // This removes stuff like dates, times, links, anything that can get in the
    // way of properly matching the line numbers

    // Loop through the regular expressions
    for (var i = 0; i < regLis.length; i++) {
      // Remove any matches to the regexs
      s = s.replaceAllMapped(regLis[i], (match) {
        return '';
      });
    }

    // The string is now clean for checking which lines are affected
    // Use another regex to find the lines
    List<String> lines = [];
    Iterable<Match> matches = RegExp(r'\d{1,3}[A-Z]?').allMatches(s).toList();

    // TODO Remove duplicate lines
    // Match the regex lines to the proper line names
    for (Match m in matches) {
      // Add a map with text to the list of lines
      lines.add(m.group(0).toString());
    }

    List<Map> chipInfo = [];

    // Get the chip info (colour, icon, etc)
    for (var i = 0; i < lines.length; i++) {
      chipInfo.add(_getChipInfo(lines[i]));
    }

    return chipInfo;
  }

  /// Takes a String [s] which is a line number and gives data for that line
  Map _getChipInfo(s) {
    // Strip all non numbers (for cases where the line is 504A which is a subset
    // of line 504)
    final intRegex = RegExp(r'\d{1,3}');
    String strippedS = intRegex.stringMatch(s);

    // Convert the line to a number for easier comparison
    int line = int.parse(strippedS);

    Map info = {"text": s};

    // Checking for the subway lines
    if (line == 1) {
      info["colour"] = Colors.amber;
      info["icon"] = Icons.subway;
    } else if (line == 2) {
      info["colour"] = Colors.green;
      info["icon"] = Icons.subway;
    } else if (line == 3) {
      info["colour"] = Colors.blueAccent;
      info["icon"] = Icons.subway;
    } else if (line == 4) {
      info["colour"] = Colors.purple[300];
      info["icon"] = Icons.subway;
    }
    // Checking Downtown Express Routes
    else if (line >= 141 && line <= 145) {
      info["colour"] = Colors.green;
      info["icon"] = Icons.directions_bus;
    }
    // Checking regular bus routes
    else if (line >= 5 && line <= 176) {
      info["colour"] = Colors.red;
      info["icon"] = Icons.directions_bus;
    }
    // Checking Express Routes
    else if (line >= 900 && line <= 996) {
      info["colour"] = Colors.green;
      info["icon"] = Icons.directions_bus;
    }
    // Checking All Night Streetcar Routes
    else if (line == 301 || line == 304 || line == 306 || line == 310) {
      info["colour"] = Colors.blueAccent;
      info["icon"] = Icons.directions_railway;
    }
    // Checking Blue Night Routes
    else if (line >= 300 && line <= 396) {
      info["colour"] = Colors.blueAccent;
      info["icon"] = Icons.directions_bus;
    }
    // Checking Community Routes
    else if (line >= 400 && line <= 407) {
      info["colour"] = Colors.grey;
      info["icon"] = Icons.directions_bus;
    }
    // Checking Streetcar Routes
    else if (line >= 501 && line <= 512) {
      info["colour"] = Colors.red;
      info["icon"] = Icons.directions_railway;
    } else {
      info["colour"] = Colors.red;
      info["icon"] = Icons.directions_bus;
    }

    return info;
  }

  // @override
  String toStr() {
    return "chipText: " +
        _chipText.toString() +
        "tweetText: " +
        _tweetText +
        "dateTime: " +
        _dateTime.toString() +
        "tweetId: " +
        _tweetId;
  }

  _createChips() {
    List<Padding> chipWidgets = [];

    // Loop through the chips
    for (var i = 0; i < _chipText.length; i++) {
      chipWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Chip( 
            backgroundColor: _chipText[i]["colour"],
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1),
              child: Text(
                _chipText[i]["text"],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return chipWidgets;
  }

  List<Widget> _createChipRows() {
    List<Widget> chipRow = [];
    List<Padding> chipWidgets = _createChips();

    // If no lines are mentioned, just add an info icon
    if (_chipText.length <= 0) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Icon(Icons.info),
        ),
      ];
    }

    IconData curIcon;

    for (var i = 0; i < _chipText.length; i++) {
      // If the icon has switched, update the current icon and add it to the row
      if (curIcon != _chipText[i]["icon"]) {
        curIcon = _chipText[i]["icon"];

        chipRow.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(curIcon),
          ),
        );
      }

      // Add the current chip
      chipRow.add(chipWidgets[i]);
    }

    return chipRow;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Wrap(
                        runSpacing: -12.0,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: _createChipRows(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          _howLongAgo + " ago",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                child: Text(_tweetText),
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
