import 'dart:convert';

import 'package:flutter/material.dart';
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
      // future: _twitterOauth.getTwitterRequest(
      //   "GET",
      //   "statuses/user_timeline.json",
      //   options: {
      //     "user_id": "19025957",
      //     "screen_name": "TTCnotices",
      //     "count": "20",
      //     "trim_user": "true",
      //     // "exclude_replies": "true",
      //     "tweet_mode": "extended" // Used to prevent truncating tweets
      //   },
      // ),
      future: Future.delayed(Duration(seconds: 1), () => "mockTwitterData"),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // TODO Better error handling. Keep trying to refresh while error
          return Center(
            child: Text("Snapshot error: Please try again"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          // Add the tweets to the list of tweets to display
          var tweetList = TweetUtil.createTweetList(json.encode(mockTwitterData));
          // Create the tweetCardList with the tweets
          return TweetCardList(tweetList);
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
    // return Container(
    //   child: RefreshIndicator(
    //     onRefresh: _refreshHandler,
    //     child: _getInitialTweets(),
    //   ),
    // );
    return _createInitialTweetCardList();
  }
}

/// The widget in charge of updating the list of tweets when the list is refreshed
class TweetCardList extends StatefulWidget { //ignore: must_be_immutable
  List<TweetItem> _tweets;

  TweetCardList(this._tweets);

  @override
  _TweetCardListState createState() => _TweetCardListState();
}

class _TweetCardListState extends State<TweetCardList> {
  Future<Null> _refreshHandler() async {
    // // Making the request to twitter
    // _twitterOauth.getTwitterRequest(
    //   "GET",
    //   "statuses/user_timeline.json",
    //   options: {
    //     "user_id": "19025957",
    //     "screen_name": "TTCnotices",
    //     "count": "20",
    //     "trim_user": "true",
    //     "exclude_replies": "true",
    //     "tweet_mode": "extended" // Used to prevent truncating tweets
    //   }
    // );
    // // return fetchPost();
    await Future.delayed(Duration(seconds: 3), () => 'Refresh');
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
