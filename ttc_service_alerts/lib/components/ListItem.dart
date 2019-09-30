import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  // The line in question
  final String chipText;
  // The tweet text
  final String tweetText;
  // The time of the tweet
  final dateTime;
  // The id of the tweet
  final String tweetId;

  // The icon that will be shown
  final icon = Icons.info;
  // The colour of the chip
  final colour = Colors.red;

  ListItem(this.tweetText, this.chipText, this.dateTime, this.tweetId);

  // @override
  String toStr() {
    return "chipText: " + chipText +
      "tweetText: " + tweetText +
      "dateTime: " + dateTime + 
      "tweetId: " + tweetId; 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Icon(Icons.notifications_active),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.directions_transit),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Chip(
                        backgroundColor: Colors.amber,
                        label: Padding(
                          padding: EdgeInsets.all(1),
                          child: Text(
                            chipText,
                            style: TextStyle(
                              fontSize: 12
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container()
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        dateTime + " ago",
                        style: TextStyle(
                          fontSize: 10
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                child: Text(tweetText),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
