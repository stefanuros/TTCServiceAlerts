# TTC Service Alerts

TTC Service Alerts is an app that displays a feed of current TTC delay information.
TTC is the toronto transit commision. I am using the Twitter API to get tweets
from the @TTCnotices twitter account, and displaying the information on the 
screen so users can easily see which lines and stations are affected by the delay.

As of mid-May, I have added an extra step to how the app gets twitter data. Normally
there is a limit on the number of requests that I can make to the Twitter Api. This
limit is 150 in 15 minutes. This poses an issue if enough instances of the app are
running at the same time. The solution was to add my own server that makes a request to
the Twitter Api every minute and store the tweet data. Then the app will make a request
to my server to get the tweets. That way, every app will make requests to my server
and the server will constantly query the Twitter Api at a maximum of 15 times in 
15 minutes (once per minute). That way I eliminate the bottleneck that the Twitter
Api has caused.
[Here is the repo for the backend server (made in Deno)](https://github.com/stefanuros/ttc_service_alerts_server_deno)


Below are screenshots of the current state.

[Here is the link to the google play page for it](https://play.google.com/store/apps/details?id=com.StefanU.ttc_service_alerts&hl=en)

## Future Plans

~~The first stage is finishing off the initial version of the app. This version
will display the information for the user. This stage was meant for getting the
visuals up and running and to teach me about flutter and about using the Twitter
API.~~

~~The second state will be to move the Twitter API Calls to a server. This server is
then what the app will query to get the twitter information. This solves the issue
that the Twitter API has a limit on the number of requests in 15 minutes.~~

State three is the add filtering to the app feed. The filtering would allow you to 
select only the lines that interest you, and only the relevant cards would be displayed
to you.

Stage four is to use the new back end server to generate push notifications
for users using Firebase (subject to change) to send the notifications. The current
version would not be able to generate notifications when the app is closed. Having
the back end server solves this issue. The notifications will be customizable 
from the time when notifications should be allowed to occur, to the lines that a
user should be notified of.

## Next Steps

Current next steps are:
* ~~Get app into app store~~
* ~~Add back end to handle all twitter requests~~
* Add filtering functionality to feed
* Add notification functionality

## Screenshots

* V 0.5
* Added an icon to the app. Multiple versions were created by the final choice 
  was a square icon (image 1), and an adaptive icon (image 2) for phones that 
  support that

<img src="/assets/v_0_5_image1.png" alt="Screenshot of Version 0.5" width="345"/>

![Screenshot of Version 0.5](/assets/v_0_5_image2.png)

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

## Building New Version

When building new version, follow the steps below.
This link is useful: https://flutter.dev/docs/deployment/android

* In `pubspec.yaml` change version number
* In `android/app/src/main/AndroidManifest.xml` change version number
* Cd to app root and run `flutter build appbundle`
** .aab file will be generated in `build/app/outputs/bundle/release/app.aab`
** Upload this file to Google Play Console
