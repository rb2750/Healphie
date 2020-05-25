import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../emotioncolors.dart';
import '../home/homestate.dart';

class LogHealthFragment extends StatelessWidget {
  final MyHomePageState pageState;

  LogHealthFragment(this.pageState);

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            Align(
                child: Text("How are you feeling?",
                    style: TextStyle(fontSize: 30))),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
                child: Wrap(
                  spacing: 60, 
                  runSpacing: 30,
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
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt(
                                    new DateFormat("dd-MM-yyyy HH:mm:ss")
                                        .format(DateTime.now()),
                                    EmotionColors.happyColor);
                                pageState.showCharts();
                              },
                            )),
                        Text(
                          "Happy",
                          style: TextStyle(
                              fontSize: 20, fontStyle: FontStyle.italic),
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
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt(
                                    new DateFormat("dd-MM-yyyy HH:mm:ss")
                                        .format(DateTime.now()),
                                    EmotionColors.relaxedColor);
                                pageState.showCharts();
                              },
                            )),
                        Text(
                          "Relaxed",
                          style: TextStyle(
                              fontSize: 20, fontStyle: FontStyle.italic),
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
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt(
                                    new DateFormat("dd-MM-yyyy HH:mm:ss")
                                        .format(DateTime.now()),
                                    EmotionColors.boredColor);
                                pageState.showCharts();
                              },
                            )),
                        Text(
                          "Bored",
                          style: TextStyle(
                              fontSize: 20, fontStyle: FontStyle.italic),
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
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt(
                                    new DateFormat("dd-MM-yyyy HH:mm:ss")
                                        .format(DateTime.now()),
                                    EmotionColors.veryBadColor);
                                pageState.showCharts();
                              },
                            )),
                        Text(
                          "Very Bad",
                          style: TextStyle(
                              fontSize: 20, fontStyle: FontStyle.italic),
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
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt(
                                    new DateFormat("dd-MM-yyyy HH:mm:ss")
                                        .format(DateTime.now()),
                                    EmotionColors.anxiousColor);
                                pageState.showCharts();
                              },
                            )),
                        Text(
                          "Anxious",
                          style: TextStyle(
                              fontSize: 20, fontStyle: FontStyle.italic),
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
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt(
                                    new DateFormat("dd-MM-yyyy HH:mm:ss")
                                        .format(DateTime.now()),
                                    EmotionColors.numbColor);
                                pageState.showCharts();
                              },
                            )),
                        Text(
                          "Numb",
                          style: TextStyle(
                              fontSize: 20, fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ],
                )),
          ],
        ));
  }
}