import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../charts.dart';
import '../loghealth/loghealthfragment.dart';

class MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String selected;
  Widget body;

  MyHomePageState() {
    body = LogHealthFragment(this);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    scheduleNotifications();
  }

  void scheduleNotifications() async {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = new IOSInitializationSettings();
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'healphie', 'HealphieChannel', 'Healphie');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.initialize(new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS));
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'Healphie',
        'How are you feeling?', RepeatInterval.Hourly, platformChannelSpecifics,
        payload: 'none');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            child: Column(
          children: <Widget>[
            Container(
                height: 80,
                padding: EdgeInsets.zero,
                child: DrawerHeader(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Stack(children: <Widget>[
                      Positioned(
                          bottom: 12.0,
                          left: 16.0,
                          child: Text("Healphie",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w500))),
                    ]))),
            Expanded(
                child: ListView(
              padding: EdgeInsets.only(top: 10),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          Icon(Icons.add_circle),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text("Log Emotion"),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          body = LogHealthFragment(this);
                        });
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          Icon(Icons.assessment),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text("View Statistics"),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
//                        showCharts();
                        setState(() {
                          body = Charts();
                        });
                      },
                    )
                  ],
                )
              ],
            )),
            Container(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                        child: Column(
                      children: <Widget>[],
                    ))))
          ],
        )),
        appBar: AppBar(
          elevation: 2,
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Healphie"),
        ),
        body: body);
  }

  void showCharts() {
    setState(() {
      body = Charts();
    });
  }
}