import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ttc_service_alerts/config/style.dart';
import 'package:url_launcher/url_launcher.dart';

/// Creates a text link
// ignore: must_be_immutable
class LinkText extends StatelessWidget {
  /// The url for the linkText
  final url;

  /// The text that will be displayed
  final text;

  LinkText({this.url, this.text});

  @override
  Widget build(BuildContext context) {

    TextStyle style = linkStyle;

    // If the link is a hashtag or user, use a different style for it
    if(text[0] == "#" || text[0] == "@") {
      style = hashtagStyle;
    }

    return InkWell(
      child: Text(
        text,
        style: style,
      ),
      onTap: () => launch(url),
    );
  }
}
