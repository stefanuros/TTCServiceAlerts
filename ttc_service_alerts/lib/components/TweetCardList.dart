import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ttc_service_alerts/classes/TweetUtil.dart';
import 'package:ttc_service_alerts/config/style.dart';
import 'package:ttc_service_alerts/config/tweetRequestConfig.dart';

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

  /// This is the timer for the tweet time being updated
  Timer _timer;

  /// This is the error message that occurs at any given moment
  String errorText;

  TweetCardList(this._tweets, this._twitterOauth, {this.errorText}) {
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
    const duration = const Duration(minutes: feedUpdateMinutes);
    widget._timer = Timer.periodic(duration, (Timer t) {
      _refreshHandler();
    });
  }

  @override
  void dispose() {
    widget._timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// This function is called when the scroll is pulled down to refresh
  /// It fetches fresh tweets and updates the time of the tweets
  Future<Null> _refreshHandler() async {
    widget.errorText = null;

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

    List<TweetItem> newTweetItems = [];

    try {
      Response res;

      try {
        // Figure out if sinceId needs to be added
        String sinceId = widget._mostRecentTweet != null ?
          "/" + widget._mostRecentTweet.toString() :
          "";

        // Make the request to the backend server to get the tweets
        res = await get(Uri.http(
          // "104.196.135.76", 
          tweetServerBaseUrl,
          tweetsSincePath + sinceId
        ));
      } catch (e) {
        // Make the fallback request for the updated tweets
        res = await widget._twitterOauth.getTwitterRequest(
          "GET",
          "statuses/user_timeline.json",
          options: opt,
        );
      }

      // Create the new tweet items
      newTweetItems = TweetUtil.createTweetList(res.body);
    } catch (e) {
      print(e);
      _launchSnackBar("There was an issue updating the feed.");
    }

    // Only sets the state if the widget is mounted (i.e. still exists in widget tree)
    if (this.mounted) {
      // Add the new tweets to the front of the _tweets list
      setState(() {
        widget._tweets = [...newTweetItems, ...widget._tweets];

        // If there is a new tweet, update the most recent tweet to be used by
        // the next fetch
        if (newTweetItems.length > 0) {
          widget._mostRecentTweet = newTweetItems[0].tweetId;
        }
      });
    }

    return null;
  }

  void _launchSnackBar(String text) {
    final snackBar = SnackBar(
      duration: Duration(seconds: errorSnackBarSeconds),
      content: Text(text),
      action: SnackBarAction(
        label: 'Retry',
        onPressed: () {
          _refreshHandler();
        },
      ),
    );

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _problemWidget() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.report_problem,
                size: loadingIconSize,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.errorText,
                  style: tweetStyle,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget = ListView(
      children: widget._tweets,
    );

    if (widget.errorText != null) {
      currentWidget = _problemWidget();
      widget.errorText = null;
    }

    return RefreshIndicator(
      onRefresh: _refreshHandler,
      child: currentWidget,
    );
  }
}
