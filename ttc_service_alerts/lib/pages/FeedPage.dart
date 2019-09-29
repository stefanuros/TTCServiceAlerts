import 'package:flutter/material.dart';
import '../components/ListItem.dart';

import '../config/keys.dart';
import '../classes/TwitterOauth.dart';

class FeedPage extends StatelessWidget {
  // The twitter class that will be used for making requests
  final _twitterOauth = new TwitterOauth(
    consumerKey: consumerApiKey, 
    consumerSecret: consumerApiSecret, 
    token: accessToken, 
    tokenSecret: accessTokenSecret
  );

  final tweets = [
    ListItem("Detour eastbound via Scarlett Rd, East Dr and Jane St due to a collision at Eglinton and Scarlett.", "32 Eglinton West", "8m", "1"),
    ListItem("Turning back eastbound via Lansdowne Avenue while we fix a mechanical problem at Howard Park and Parkside.", "506 Carlton", "17m", "1"),
    ListItem("This Monday through Thursday, subway service between Greenwood and St George will end nightly at 11 PM for scheduled track work. Shuttle buses will run.", "Line 2 Bloor-Danforth", "35m", "1"),
    ListItem("Detour via Birchmount Rd and Foxridge Dr due to a collision.", "68 Warden", "1h", "1"),
    ListItem("Detour via Birchmount Rd and Danforth Ave due to a collision", "9 Bellamy, 16 McCowan, 102 Markham Road", "1h", "1"),
    ListItem("Detour eastbound via Scarlett Rd, East Dr and Jane St due to a collision at Eglinton and Scarlett.", "32 Eglinton West", "8m", "1"),
    ListItem("Turning back eastbound via Lansdowne Avenue while we fix a mechanical problem at Howard Park and Parkside.", "506 Carlton", "17m", "1"),
    ListItem("This Monday through Thursday, subway service between Greenwood and St George will end nightly at 11 PM for scheduled track work. Shuttle buses will run.", "Line 2 Bloor-Danforth", "35m", "1"),
    ListItem("Detour via Birchmount Rd and Foxridge Dr due to a collision.", "68 Warden", "1h", "1"),
    ListItem("Detour via Birchmount Rd and Danforth Ave due to a collision", "9 Bellamy, 16 McCowan, 102 Markham Road", "1h", "1"),
    ListItem("Detour eastbound via Scarlett Rd, East Dr and Jane St due to a collision at Eglinton and Scarlett.", "32 Eglinton West", "8m", "1"),
    ListItem("Turning back eastbound via Lansdowne Avenue while we fix a mechanical problem at Howard Park and Parkside.", "506 Carlton", "17m", "1"),
    ListItem("This Monday through Thursday, subway service between Greenwood and St George will end nightly at 11 PM for scheduled track work. Shuttle buses will run.", "Line 2 Bloor-Danforth", "35m", "1"),
    ListItem("Detour via Birchmount Rd and Foxridge Dr due to a collision.", "68 Warden", "1h", "1"),
    ListItem("Detour via Birchmount Rd and Danforth Ave due to a collision", "9 Bellamy, 16 McCowan, 102 Markham Road", "1h", "1"),
    Icon(Icons.directions_transit),
    Icon(Icons.subway),
    Icon(Icons.directions_bus),
    Icon(Icons.directions_railway),
    Icon(Icons.info),
    Icon(Icons.info_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: (){
          print("refreshed");

          // Making the request to twitter
          _twitterOauth.getTwitterRequest(
            "GET",
            "statuses/user_timeline.json",
            // "/1.1/statuses/user_timeline.json",
            // "/1.1/search/tweets.json",
            // "/1.1/users/show.json",
            options: {
              // "user_id": "19025957",
              "screen_name": "TTCnotices",
              // "count": "20",
              // "trim_user": "true",
              // "exclude_replies": "true"
            }
          );
          // return fetchPost();
          return Future.delayed(Duration(seconds: 0), () => 'Large Latte'); 
        },
        child: ListView(
          children: () {
            return this.tweets;
          }()
        ),
      )
    );
  }
}
