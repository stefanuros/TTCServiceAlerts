import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// This class is a tweet list item
// TODO Add error checking if something goes wrong
class TweetItem extends StatelessWidget {
  /// The id of the tweet
  String _tweetId;

  /// The tweet text
  String _tweetText;

  /// The time of the tweet
  //  TODO Figure out how datetime will work
  DateTime _dateTime;

  /// How long ago the tweet was
  String _howLongAgo;

  /// The transit line in question
  // TODO Implement list of chipTexts
  List<String> _chipText;

  /// The icon that will be shown
  final _icon = Icons.info;

  /// The colour of the chip
  // TODO check if this needs to be a list as well
  final _colour = Colors.amber;

  /// This class is a tweet list item
  // TweetItem(this._tweetText, this._chipText, this._dateTime, this._tweetId);

  /// This class is a tweet list item
  TweetItem(tweetMap) {
    _tweetId = tweetMap["id_str"];
    _tweetText = tweetMap["full_text"];

    // Create a formatter for this datetime
    // Wed Oct 02 23:28:13 +0000 2019
    // * Removing the timezone with substring
    // var f = new DateFormat('EEE MMM dd HH:mm:ss ZZZZ yyyy');
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

    // TODO Algo for getting chip text
    _chipText = ["Chip 1"];
  }

  /// Function that sets how long ago the tweet was, in minutes, hours, days, weeks, and months
  String _getTimeFrom(DateTime tweetTime) {
    // Current DateTime
    DateTime now = DateTime.now();

    // Find the difference between the 2 times
    var diff = now.difference(tweetTime).inMinutes;
    print("===");
    print(now.toString());
    print(tweetTime.toString());

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
    return diff.toString() + " " + unit;
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
    List<Chip> chipWidgets = [];

    // Loop through the chips
    for (var i = 0; i < _chipText.length; i++) {
      chipWidgets.add(
        Chip(
          backgroundColor: _colour,
          label: Padding(
            padding: EdgeInsets.all(1),
            child: Text(
              _chipText[i],
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      );
    }

    return chipWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Icon(Icons.notifications_active),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Icon(_icon),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: _createChips(),
                      ),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        _howLongAgo + " ago",
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                child: Text(_tweetText),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
