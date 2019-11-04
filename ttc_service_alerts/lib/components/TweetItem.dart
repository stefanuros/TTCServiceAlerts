import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart';
import 'package:ttc_service_alerts/config/ttcInfo.dart';
import 'package:ttc_service_alerts/config/style.dart';

import 'LinkText.dart';
import 'TimeText.dart';

/// This class is a tweet list item
//ignore: must_be_immutable
class TweetItem extends StatelessWidget {
  /// The id of the tweet
  String _tweetId;

  /// The tweet text
  String _tweetText;

  /// The richtext widget used for the text
  TextSpan _richTweetText;

  /// The time of the tweet
  TZDateTime _dateTime;

  /// The transit line in question
  List<Map> _chipText;

  // The time widget
  TimeText _timeTextWidget;

  /// This class is a tweet list item
  TweetItem(tweetMap) {
    _tweetId = tweetMap["id_str"];
    _tweetText = HtmlUnescape().convert(tweetMap["full_text"]);

    String tweetFullText = HtmlUnescape().convert(tweetMap["full_text"]);

    _richTweetText = _createRichTweet(tweetFullText);

    _setDateTime(tweetMap["created_at"]);

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
      if (b["icon"].codePoint - a["icon"].codePoint != 0) {
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

    // Create the widget that will be used for the time text
    _timeTextWidget = TimeText(_dateTime);
  }

  String get tweetId {
    return _tweetId;
  }

  /// This function calculates the EST time when given UTC and hopefully accounts
  /// for daylight savings time
  Future<void> _setDateTime(String dateTimeString) async {
    // init timezone data
    // await initializeTimeZone();

    // Create a formatter for this datetime
    // Wed Oct 02 23:28:13 +0000 2019
    var f = new DateFormat('EEE MMM dd HH:mm:ss yyyy');

    // Get the tweet time which is in UTC by default
    // * Removing the timezone with substring
    var dateTimeUtc = f.parse(
      dateTimeString.substring(0, 20) + dateTimeString.substring(26, 30),
    );

    // New York time zone is close enough to toronto since toronto isnt an option
    Location est = getLocation('America/New_York');

    // Convert dateTimeUtc to utc timezone with TZDateTime type
    var tzDateTimeUtc = TZDateTime.utc(
      dateTimeUtc.year,
      dateTimeUtc.month,
      dateTimeUtc.day,
      dateTimeUtc.hour,
      dateTimeUtc.minute,
      dateTimeUtc.second,
      dateTimeUtc.millisecond,
      dateTimeUtc.microsecond,
    );

    var dateTimeEst = TZDateTime.from(tzDateTimeUtc, est);

    // Set the tweet datetime to the converted EST time
    _dateTime = dateTimeEst;
  }

  /// Function that creates a tweet that has clickable hashtags and links
  TextSpan _createRichTweet(String text) {
    // This string is the regex needed to isolate usernames and hashtags from a string
    RegExp locateLinkRegex =
        RegExp(r'((@|#[a-zA-Z])(\w)*|https?:\/\/\w*.\w*(\/\w*)?)');

    // Everything that isnt a link
    List<String> content = text.split(locateLinkRegex);
    // Everything that is a link
    List<String> link =
        locateLinkRegex.allMatches(text).map((m) => m.group(0)).toList();

    // Make the lists of strings into lists of widgets
    List<InlineSpan> contentSpan = content.map((x) {
      return TextSpan(
        text: x,
      );
    }).toList();

    List<InlineSpan> linkSpan = link.map((x) {
      return _createLinkText(x, _createProperUrl(x));
    }).toList();

    // the above lists will alternate but we need to figure out which ones first
    // Check if the first match of the regex is the same as the first X characters of text
    RegExpMatch firstMatch = locateLinkRegex.firstMatch(text);

    bool isLinkFirst = false;

    if (firstMatch != null) {
      // Check if the first link is the first thing in the text
      isLinkFirst =
          text.substring(0, firstMatch.group(0).length) == firstMatch.group(0);
    }

    // Zip the lists together where the order depends on isLinkFirst
    List<InlineSpan> zippedList = (isLinkFirst
        ? zipLists(linkSpan, contentSpan)
        : zipLists(contentSpan, linkSpan));

    return TextSpan(
      style: tweetStyle,
      children: zippedList,
    );
  }

  /// This function zips 2 lists together
  List<K> zipLists<K>(List a, List b) {
    List<K> zipped = [];

    for (var i = 0; i < b.length; i++) {
      zipped.add(a[i]);
      zipped.add(b[i]);
    }

    zipped = [...zipped, ...a.sublist(b.length)];

    return zipped;
  }

  /// Function to return a widgetspan to be used by _createRichTweet
  WidgetSpan _createLinkText(String text, String url) {
    return WidgetSpan(
      child: LinkText(
        text: text,
        url: url,
      ),
    );
  }

  /// This function, when given something that should have a link, returns the
  /// correct link for the input
  /// E.g. hastags return hashtag links, usernames return username links, regular
  /// links are returned as is
  String _createProperUrl(String text) {
    if (text[0] == "#") {
      // input of #test returns link of https://twitter.com/hashtag/test
      return "https://twitter.com/hashtag/" + text.substring(1);
    } else if (text[0] == "@") {
      // input of @test returns link of https://twitter.com/test
      return "https://twitter.com/" + text.substring(1);
    }

    // Returns regular links
    return text;
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

    for (Match m in matches) {
      // Add a map with text to the list of lines
      lines.add(m.group(0).toString());
    }

    // Remove any duplicates
    lines = lines.toSet().toList();

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

  _createChips() {
    List<Padding> chipWidgets = [];

    // Loop through the chips
    for (var i = 0; i < _chipText.length; i++) {
      chipWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 4.0,
                color: _chipText[i]["colour"],
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            // backgroundColor: _chipText[i]["colour"],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                _chipText[i]["text"],
                style: TextStyle(
                  fontSize: chipFontSize,
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

  /// This function updates the time text for this tweet
  updateTime() {
    _timeTextWidget.updateTime();
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Wrap(
                        // runSpacing: -12.0,
                        runSpacing: 4.0,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: _createChipRows(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: _timeTextWidget,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                child: Text.rich(_richTweetText),
                padding: EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  bottom: 15.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
