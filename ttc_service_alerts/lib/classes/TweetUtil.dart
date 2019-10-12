import 'dart:convert';

import 'package:ttc_service_alerts/components/TweetItem.dart';

/// This class has utility functions that are used in multiple places

class TweetUtil {
  /// This function takes a list of maps of tweets. It then inserts those tweets
  /// into the list.
  static createTweetList(String tweetsString) {
    // Decode the string into a map
    var tweets = json.decode(tweetsString);

    // The list of tweets that will be added into the list of tweets to display
    // List<TweetItem> tweetList = [];
    List<TweetItem> tweetList = [];

    // Loop through the list of incoming tweets
    for (var i = 0; i < tweets.length; i++) {
      // For each incoming tweet, create a tweetItem
      tweetList.add(TweetItem(tweets[i]));
    }

    // Create a new list with the new tweets at the front
    return tweetList;
  }
}
