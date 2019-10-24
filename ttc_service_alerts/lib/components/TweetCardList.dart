import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ttc_service_alerts/classes/TweetUtil.dart';

import 'TweetItem.dart';

/// The widget in charge of updating the list of tweets when the list is refreshed
//ignore: must_be_immutable
class TweetCardList extends StatefulWidget {
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

  // This is the timer for the tweet time being updated
  Timer _timer;

  TweetCardList(this._tweets, this._twitterOauth) {
    // Set the most recent tweetID from the info that is passed in
    if (_tweets.length > 0) {
      _mostRecentTweet = _tweets[0].tweetId;
    } else {
      _mostRecentTweet = null;
    }
  }

  @override
  _TweetCardListState createState() => _TweetCardListState();
}

class _TweetCardListState extends State<TweetCardList>
    with WidgetsBindingObserver {

  /// This function handles any lifecycle events, including leaving the app, and
  /// then coming back to it.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the state is resumed which happens when the app is reopened
    if (state == AppLifecycleState.resumed) {
      // Refresh the data
      _refreshHandler();
    }
  }

  @override
  initState() {
    super.initState();
    // Used to add observer to watch app state (resumed, paused, etc)
    WidgetsBinding.instance.addObserver(this);

    // Initialize the timer that will refresh the feed occasionally
    // const duration = const Duration(minutes: 1);
    // widget._timer = Timer.periodic(duration, (Timer t) {
    //   _refreshHandler();
    //   // Update the value to get a time update
    //   print("In");
    // });
  }

  @override
  void dispose() {
    widget._timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// This function is called when the scroll is pulled down to refresh
  /// It fetches fresh tweets and updates the time of the tweets
  Future<Null> _refreshHandler() async {
    // Update the times for the current tweets
    for (var i = 0; i < widget._tweets.length; i++) {
      widget._tweets[i].updateTime();
    }
    // Setting the options for the request
    Map<String, String> opt = {
      "user_id": "19025957",
      "screen_name": "TTCnotices",
      "count": "20",
      "trim_user": "true",
      // "exclude_replies": "true",
      "tweet_mode": "extended" // Used to prevent truncating tweets
    };

    // If a most recent tweet exists, add it as a parameter to the request
    if (widget._mostRecentTweet != null) {
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

      if (newTweetItems.length > 0) {
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
