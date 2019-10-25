import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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

  Widget body= LogHealthFragment();

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
                          body = LogHealthFragment();
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
                        setState(() {
                          body = TimeVsHappinessBarChart.withSampleData();
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
        appBar: AppBar(elevation: 2, iconTheme: new IconThemeData(color: Colors.white), title: Text("Sophie Health")),
        body: body);
  }
}

class LogHealthFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text("Hello!"),
    );
  }
}