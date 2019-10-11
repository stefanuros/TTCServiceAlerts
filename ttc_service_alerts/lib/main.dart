import 'package:flutter/material.dart';

import 'pages/FeedPage.dart';
import 'pages/SettingsPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TTC Service Alerts',
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text('TTC Service Alerts'),
            // bottom: TabBar(
            //   indicatorColor: Colors.white,
            //   tabs: [
            //     Tab(
            //       icon: Icon(Icons.directions_transit),
            //     ),
            //     Tab(
            //       icon: Icon(Icons.notifications_active),
            //     ),
            //   ],
            // ),
          ),
          body: FeedPage(), // TODO Remove this once the second tab is added
          // body: SafeArea(
          //   child: TabBarView(
          //     children: [
          //       FeedPage(),
          //       SettingsPage()
                // Icon(Icons.directions_transit),
                // Icon(Icons.notifications_active),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
