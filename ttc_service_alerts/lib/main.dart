import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart';

import 'pages/FeedPage.dart';
// import 'pages/SettingsPage.dart';

// void main() => runApp(MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // This loads the timezone information then starts the app
  var byteData =
      await rootBundle.load('packages/timezone/data/$tzDataDefaultFilename');
  initializeDatabase(byteData.buffer.asUint8List());
  runApp(MyApp());
}

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
          body: FeedPage(), // Remove this once the second tab is added
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
