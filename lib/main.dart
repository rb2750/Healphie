import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'charts.dart';

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
  String selected;

  Widget body;

  _MyHomePageState() {
    body = LogHealthFragment(this);
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
  int happyColor = 0xFFFAB6F8;
  int relaxedColor = 0xFFAEDFE8;
  int boredColor = 0xFFAEE8C4;
  int veryBadColor = 0xFFE80909;
  int anxiousColor = 0xFF9F92F0;
  int numbColor = 0xFFED72F0;
  final _MyHomePageState pageState;

  LogHealthFragment(this.pageState);

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: Column(
          children: <Widget>[
            Align(child: Text("How are you feeling?", style: TextStyle(fontSize: 30))),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
                child: Wrap(
                  spacing: 60, runSpacing: 30,
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        new Container(
                            width: 130,
                            height: 130,
                            decoration: new BoxDecoration(
                              color: Color(happyColor),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.white,
                              ),
                              iconSize: 110,
                              padding: EdgeInsets.only(top: 10),
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setInt(new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()), happyColor);
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
                            width: 130,
                            height: 130,
                            decoration: new BoxDecoration(
                              color: Color(relaxedColor),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.zero,
                              iconSize: 110,
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setInt(new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()), relaxedColor);
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
                            width: 130,
                            height: 130,
                            decoration: new BoxDecoration(
                              color: Color(boredColor),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.extension,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.only(left: 10, bottom: 10),
                              iconSize: 110,
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setInt(new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()), boredColor);
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
                            width: 130,
                            height: 130,
                            decoration: new BoxDecoration(
                              color: Color(veryBadColor),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.zero,
                              iconSize: 110,
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setInt(new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()), veryBadColor);
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
                            width: 130,
                            height: 130,
                            decoration: new BoxDecoration(
                              color: Color(anxiousColor),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.visibility,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.zero,
                              iconSize: 110,
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setInt(new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()), anxiousColor);
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
                            width: 130,
                            height: 130,
                            decoration: new BoxDecoration(
                              color: Color(numbColor),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.face,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.zero,
                              iconSize: 110,
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setInt(new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()), numbColor);
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
