# ttc_service_alerts

TTC Service Alerts is an app that displays a feed of current TTC delay information.
TTC is the toronto transit commision. I am using the Twitter API to get tweets
from the @TTCnotices twitter account, and displaying the information on the 
screen so users can easily see which lines and stations are affected by the delay.

Below are screenshots of the current state.

## Future Plans

The current stage is finishing off the initial version of the app. This version
will display the information for the user. This stage was meant for getting the
visuals up and running and to teach me about flutter and about using the Twitter
API.

The second state will be to move the Twitter API Calls to a server. This server is
then what the app will query to get the twitter information. This solves the issue
that the Twitter API has a limit on the number of requests in 15 minutes. 

Finally, stage 3 is to use the new back end server to generate push notifications
for users using Firebase (subject to change) to send the notifications. The current
version would not be able to generate notifications when the app is closed. Having
the back end server solves this issue. The notifications will be customizable 
from the time when notifications should be allowed to occur, to the lines that a
user should be notified of.

## Next Steps

Current next steps are:
* Fixing any graphical bugs that are occuring
  * ~~Chips would overflow, rather than wrap, when there were too many~~
  * Moving Time of tweet to top right corner of the box
* Adding functionality for swipe down to update

## Screenshots

* V 0.4
* Added hyperlinks to links, as well as to hashtags and twitter handles

![Screenshot of Version 0.4](/assets/v_0_4.png)

* V 0.3
*  Non visual changes include
    * Timer to update feed
    * Timer to update time of tweet as time goes on
    * Feed is refreshed when app is reopened

![Screenshot of Version 0.3](/assets/v_0_3.png)

* V 0.2

![Gif of Version 0.2](/assets/v_0_2.gif)

* V 0.1

![Gif of Version 0.1](/assets/v_0_1.gif)
