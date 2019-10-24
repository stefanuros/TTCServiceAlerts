import 'package:flutter/material.dart';
import 'package:ttc_service_alerts/classes/TweetUtil.dart';
import 'package:ttc_service_alerts/components/LoadingIndicator.dart';
import 'package:ttc_service_alerts/components/TweetCardList.dart';

import '../config/keys.dart';
import '../classes/TwitterOauth.dart';

class FeedPage extends StatelessWidget {
  // The twitter class that will be used for making requests
  final _twitterOauth = new TwitterOauth(
      consumerKey: consumerApiKey,
      consumerSecret: consumerApiSecret,
      token: accessToken,
      tokenSecret: accessTokenSecret);

  FutureBuilder _createInitialTweetCardList() {
    return FutureBuilder(
      future: _twitterOauth.getTwitterRequest(
        "GET",
        "statuses/user_timeline.json",
        options: {
          "user_id": "19025957",
          "screen_name": "TTCnotices",
          "count": "20",
          "trim_user": "true",
          // "exclude_replies": "true",
          "tweet_mode": "extended" // Used to prevent truncating tweets
        },
      ),
      // future: Future.delayed(Duration(seconds: 1), () => "mockTwitterData"),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // TODO Better error handling. Keep trying to refresh while error
          return Center(
            child: Text("Snapshot error: Please try again"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          // Add the tweets to the list of tweets to display
          // var tweetList = TweetUtil.createTweetList(json.encode(mockTwitterData));
          var tweetList = TweetUtil.createTweetList(snapshot.data.body);
          // Create the tweetCardList with the tweets
          return TweetCardList(tweetList, _twitterOauth);
        } else if (snapshot.connectionState == ConnectionState.active) {
          return LoadingIndicator();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        } else {
          // TODO Better error handling. Keep trying to refresh while error
          return Center(
            child: Text("No result error: Please try again"),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _createInitialTweetCardList();
  }
}
