import 'dart:convert';

import 'package:ttc_service_alerts/components/TweetItem.dart';

/// This class has utility functions that are used in multiple places

class TweetUtil {
  /// This function takes a list of maps of tweets. It then inserts those tweets
  /// into the list.
  static List<TweetItem> createTweetList(String tweetsString) {
    // Decode the string into a map
    var tweets = json.decode(tweetsString);

    // If the rate limit has been exceeded, throw an error
    if(tweets is Map && tweets.containsKey("errors")) {
      throw(tweetsString);
    }

    // The list of tweets that will be added into the list of tweets to display
    // List<TweetItem> tweetList = [];
    List<TweetItem> tweetList = [];

    // Loop through the list of incoming tweets
    for (var i = 0; i < tweets.length; i++) {
      // For each incoming tweet, create a tweetItem
      try {
        TweetItem newTweetItem = TweetItem(tweets[i]);
        tweetList.add(newTweetItem);
      } catch (e) {
        print(e);
      }
    }

    // Create a new list with the new tweets at the front
    return tweetList;
  }
}
