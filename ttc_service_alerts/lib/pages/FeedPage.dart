import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ttc_service_alerts/classes/TweetUtil.dart';
import 'package:ttc_service_alerts/components/LoadingIndicator.dart';
import 'package:ttc_service_alerts/mockTwitterData.dart';
import '../components/TweetItem.dart';

import '../config/keys.dart';
import '../classes/TwitterOauth.dart';

class FeedPage extends StatelessWidget {
  // The twitter class that will be used for making requests
  final _twitterOauth = new TwitterOauth(
      consumerKey: consumerApiKey,
      consumerSecret: consumerApiSecret,
      token: accessToken,
      tokenSecret: accessTokenSecret);

  // var _sinceId;

  // List<TweetItem> _tweets = [];

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

/// The widget in charge of updating the list of tweets when the list is refreshed
class TweetCardList extends StatefulWidget { //ignore: must_be_immutable
  /// This is the list of tweets that will be displayed
  /// The initial list is gerated outside of this object and is passed in as an
  /// initial value
  /// Refreshing the page adds tweets to this list
  List<TweetItem> _tweets;
  /// This is the most recent tweet that was fetched. This is used for refreshing
  /// the page. Any new tweets that are fetched are tweets that occur after this
  /// tweet
  String _mostRecentTweet;
  /// The twitter request class
  final _twitterOauth;

  TweetCardList(this._tweets, this._twitterOauth) {
    // Set the most recent tweetID from the info that is passed in
    if(_tweets.length > 0) {
      _mostRecentTweet = _tweets[0].tweetId;
    }
    else {
      _mostRecentTweet = null;
    }
  }

  @override
  _TweetCardListState createState() => _TweetCardListState();
}

class _TweetCardListState extends State<TweetCardList> {

  Future<Null> _refreshHandler() async {

    // Setting the options for the request
    Map<String, String> opt = {
      "user_id": "19025957",
      "screen_name": "TTCnotices",
      "count": "20",
      "trim_user": "true",
      "exclude_replies": "true",
      "tweet_mode": "extended" // Used to prevent truncating tweets
    };

    // If a most recent tweet exists, add it as a parameter to the request
    if(widget._mostRecentTweet != null) {
      opt["since_id"] = widget._mostRecentTweet.toString();
    }

    // Make the request for the updated tweets
    Response res = await widget._twitterOauth.getTwitterRequest(
      "GET",
      "statuses/user_timeline.json",
      options: opt,
    );

    // Create the new tweet items
    List<TweetItem> newTweetItems = TweetUtil.createTweetList(res.body);

    // Add the new tweets to the front of the _tweets list
    setState(() {
      widget._tweets = [...newTweetItems, ...widget._tweets];

      if(newTweetItems.length > 0) {
        widget._mostRecentTweet = newTweetItems[0].tweetId;
      }
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshHandler,
      child: ListView(
        children: widget._tweets,
      ),
    );
  }
}
