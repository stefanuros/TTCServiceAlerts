import 'dart:convert';

import 'package:flutter/material.dart';
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

  List<Widget> _tweets = [];
    // TweetItem(
    //     "Detour eastbound via Scarlett Rd, East Dr and Jane St due to a collision at Eglinton and Scarlett.",
    //     "32 Eglinton West",
    //     "8m",
    //     "1"),
    // TweetItem(
    //     "Turning back eastbound via Lansdowne Avenue while we fix a mechanical problem at Howard Park and Parkside.",
    //     "506 Carlton",
    //     "17m",
    //     "1"),
    // TweetItem(
    //     "This Monday through Thursday, subway service between Greenwood and St George will end nightly at 11 PM for scheduled track work. Shuttle buses will run.",
    //     "Line 2 Bloor-Danforth",
    //     "35m",
    //     "1"),
    // TweetItem("Detour via Birchmo unt Rd and Foxridge Dr due to a collision.",
    //     "68 Warden", "1h", "1"),
    // TweetItem("Detour via Birchmount Rd and Danforth Ave due to a collision",
    //     "9 Bellamy, 16 McCowan, 102 Markham Road", "1h", "1"),
    // TweetItem(
    //     "Detour eastbound via Scarlett Rd, East Dr and Jane St due to a collision at Eglinton and Scarlett.",
    //     "32 Eglinton West",
    //     "8m",
    //     "1"),
    // TweetItem(
    //     "Turning back eastbound via Lansdowne Avenue while we fix a mechanical problem at Howard Park and Parkside.",
    //     "506 Carlton",
    //     "17m",
    //     "1"),
    // TweetItem(
    //     "This Monday through Thursday, subway service between Greenwood and St George will end nightly at 11 PM for scheduled track work. Shuttle buses will run.",
    //     "Line 2 Bloor-Danforth",
    //     "35m",
    //     "1"),
    // TweetItem("Detour via Birchmount Rd and Foxridge Dr due to a collision.",
    //     "68 Warden", "1h", "1"),
    // TweetItem("Detour via Birchmount Rd and Danforth Ave due to a collision",
    //     "9 Bellamy, 16 McCowan, 102 Markham Road", "1h", "1"),
    // TweetItem(
    //     "Detour eastbound via Scarlett Rd, East Dr and Jane St due to a collision at Eglinton and Scarlett.",
    //     "32 Eglinton West",
    //     "8m",
    //     "1"),
    // TweetItem(
    //     "Turning back eastbound via Lansdowne Avenue while we fix a mechanical problem at Howard Park and Parkside.",
    //     "506 Carlton",
    //     "17m",
    //     "1"),
    // TweetItem(
    //     "This Monday through Thursday, subway service between Greenwood and St George will end nightly at 11 PM for scheduled track work. Shuttle buses will run.",
    //     "Line 2 Bloor-Danforth",
    //     "35m",
    //     "1"),
    // TweetItem("Detour via Birchmount Rd and Foxridge Dr due to a collision.",
    //     "68 Warden", "1h", "1"),
    // TweetItem("Detour via Birchmount Rd and Danforth Ave due to a collision",
    //     "9 Bellamy, 16 McCowan, 102 Markham Road", "1h", "1"),
  //   Icon(Icons.directions_transit),
  //   Icon(Icons.subway),
  //   Icon(Icons.directions_bus),
  //   Icon(Icons.directions_railway),
  //   Icon(Icons.info),
  //   Icon(Icons.info_outline),
  // ];

  // FeedPage() {
  //   // Making the request to twitter
  //   Future twitterRequest = _twitterOauth
  //       .getTwitterRequest("GET", "statuses/user_timeline.json", options: {
  //     "user_id": "19025957",
  //     "screen_name": "TTCnotices",
  //     "count": "20",
  //     "trim_user": "true",
  //     // "exclude_replies": "true",
  //     "tweet_mode": "extended" // Used to prevent truncating tweets
  //   });

  //   // Handle the future returned from the future builder
  //   Widget f = FutureBuilder(
  //     future: twitterRequest,
  //     builder: (context, snapshot) {
  //       // If the future is done
  //       print("Here");
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         print("Future Done");
  //         print(context);
  //         return Text("Done");
  //       }
  //       return Text("Not Done");
  //     },
  //   );
  // }

  /// This function takes a list of maps of tweets. It then inserts those tweets 
  /// into the list.
  insertTweets(String tweetsString) {
    // Decode the string into a map
    var tweets = json.decode(tweetsString);

    // The list of tweets that will be added into the list of tweets to display
    // List<TweetItem> tweetList = [];
    List<Widget> tweetList = [];

    // Loop through the list of incoming tweets
    for(var i = 0; i < tweets.length; i++) {
      // For each incoming tweet, create a tweetItem
      tweetList.add(TweetItem(tweets[i]));
    }

    // TODO Figure out if it would be better to just sort it
    // Create a new list with the new tweets at the front
    tweetList.addAll(_tweets);
    return tweetList;

    // Insert the tweet item into the list of tweets
    // setState(() {
    //   _tweets.insert(0, tweetItem);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: () {

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
          return Future.delayed(Duration(seconds: 3), () => 'Refresh');
        },
        child: FutureBuilder(
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
              return ListView(children: () {
                // Add the tweets to the list of tweets to display
                return insertTweets(json.encode(mockTwitterData));
                // return insertTweets(snapshot.data.body);
              }());
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
        ),
      ),
    );
  }
}
