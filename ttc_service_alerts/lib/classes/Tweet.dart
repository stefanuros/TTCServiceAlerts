// Class that holds a tweet and all info for it

class Tweet {
  // The line that is closed
  String line;
  // The text of the tweet
  String text;
  // The time of the tweet
  var time;
  // The id of the tweet
  String tweetId;

  Tweet(text, this.time, this.tweetId) {
    // TODO Algo for getting line number and text
      // ? Deal with cases like these
      // ? https://twitter.com/TTCnotices/status/1177622943708393472
      
    this.line = "Line 1";
    this.text = text;
  }

  createListItem() {

  }
}
