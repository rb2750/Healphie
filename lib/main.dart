import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'charts.dart';
import 'emotioncolors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sophie Health',
      home: MyHomePage(title: 'Log Health'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String selected;
  Widget body;

  _MyHomePageState() {
    body = LogHealthFragment(this);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    scheduleNotifications();
  }

//  @override
//  initState() {
//    super.initState();
//    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//
//    scheduleNotifications();
//  }

  void scheduleNotifications() async {
    var initializationSettingsAndroid = new AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = new IOSInitializationSettings();
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('sophie', 'SophieChannel', 'Sophie');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.initialize(new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS) /*, onSelectNotification: onSelectNotification*/);
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'Healphie', 'How are you feeling?', RepeatInterval.Hourly, platformChannelSpecifics, payload: 'none');
  }

//  Future onSelectNotification(String payload) async {
//    showDialog(
//      context: context,
//      builder: (_) {
//        return new AlertDialog(
//          title: Text("PayLoad"),
//          content: Text("Payload : $payload"),
//        );
//      },
//    );
//  }

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
                    decoration: BoxDecoration(color: Colors.blue
                        /*image: DecorationImage(
                            fit: BoxFit.fill,
                            image:  AssetImage('assets/drawer_header_background.png'))*/
                        ),
                    child: Stack(children: <Widget>[
                      Positioned(bottom: 12.0, left: 16.0, child: Text("Sophie Health", style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w500))),
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
          title: Text("Sophie Health"),
        ),
        body: body);
  }

  void showCharts() {
    setState(() {
      body = Charts();
    });
  }
}

class LogHealthFragment extends StatelessWidget {
  final _MyHomePageState pageState;

  LogHealthFragment(this.pageState);

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            Align(child: Text("How are you feeling?", style: TextStyle(fontSize: 30))),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
                child: Wrap(
                  spacing: 60, runSpacing: 30,
//                crossAxisAlignment: WrapCrossAlignment.stretch,
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        new Container(
                            width: 110,
                            height: 110,
                            decoration: new BoxDecoration(
                              color: Color(EmotionColors.happyColor),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.white,
                              ),
                              iconSize: 90,
                              padding: EdgeInsets.only(top: 10),
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setInt(new DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now()), EmotionColors.happyColor);
                                pageState.showCharts();
                              },
                            )),
                        Text(
                          "Happy",
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        new Container(
                            width: 110,
                            height: 110,
                            decoration: new BoxDecoration(
                              color: Color(EmotionColors.relaxedColor),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.zero,
                              iconSize: 90,
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setInt(new DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now()), EmotionColors.relaxedColor);
                                pageState.showCharts();
                              },
                            )),
                        Text(
                          "Relaxed",
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        new Container(
                            width: 110,
                            height: 110,
                            decoration: new BoxDecoration(
                              color: Color(EmotionColors.boredColor),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.extension,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.only(left: 10, bottom: 10),
                              iconSize: 90,
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setInt(new DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now()), EmotionColors.boredColor);
                                pageState.showCharts();
                              },
                            )),
                        Text(
                          "Bored",
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        new Container(
                            width: 110,
                            height: 110,
                            decoration: new BoxDecoration(
                              color: Color(EmotionColors.veryBadColor),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.zero,
                              iconSize: 90,
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setInt(new DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now()), EmotionColors.veryBadColor);
                                pageState.showCharts();
                              },
                            )),
                        Text(
                          "Very Bad",
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        new Container(
                            width: 110,
                            height: 110,
                            decoration: new BoxDecoration(
                              color: Color(EmotionColors.anxiousColor),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.visibility,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.zero,
                              iconSize: 90,
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setInt(new DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now()), EmotionColors.anxiousColor);
                                pageState.showCharts();
                              },
                            )),
                        Text(
                          "Anxious",
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        new Container(
                            width: 110,
                            height: 110,
                            decoration: new BoxDecoration(
                              color: Color(EmotionColors.numbColor),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.face,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.zero,
                              iconSize: 90,
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setInt(new DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now()), EmotionColors.numbColor);
                                pageState.showCharts();
                              },
                            )),
                        Text(
                          "Numb",
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ],
                )),
          ],
        ));
  }
}

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}
