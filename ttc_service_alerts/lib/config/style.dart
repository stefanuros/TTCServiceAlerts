import 'package:flutter/material.dart';

/// This class controls global values that might need to be changed in multiple
/// locations

/// This controls the loading icon size
const double loadingIconSize = 45.0;

/// This controls the regular tweet font size
const double tweetFontSize = 18.0;

/// This controls the font size of the chips
const double chipFontSize = 16.0;

/// This controls the font size for the time
const double timeFontSize = 14.0;

/// The style of the tweet text
const TextStyle tweetStyle = TextStyle(fontSize: tweetFontSize);

/// The style of links in the tweet
const TextStyle linkStyle = TextStyle(
  fontSize: tweetFontSize,
  color: Color(0xFF0000EE), // link blue
  decoration: TextDecoration.underline,
);

const TextStyle hashtagStyle = TextStyle(
  fontSize: tweetFontSize,
  color: Color(0xFF1A7AB6),
);

/// This controls how often the feed is updated
const int feedUpdateMinutes = 1;

/// This controls how long the error snackbar stays on the screen
const int errorSnackBarSeconds = 30; 
