import 'dart:collection';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'emotioncolors.dart';

class Charts extends StatefulWidget {
  @override
  ChartState createState() => ChartState();
}

class ChartState extends State<Charts> {
  final bool animate = true;
  TimeScale chartTimeScale = TimeScale.DAY;
  ChartType chartType = ChartType.BAR;

  Future<List<charts.Series<OrdinalHappinessBar, String>>> _barData;
  Future<List<charts.Series<OrdinalHappinessPie, String>>> _pieData;

  @override
  void initState() {
    super.initState();
    _barData = createBarData();
    _pieData = createPieData();
  }

  @override
  void setState(Function state) {
    super.setState(state);
    _barData = createBarData();
    _pieData = createPieData();
  }

  Widget makeButton(String text, Border border, TimeScale newTimeScale, ChartType newChartType, bool selected) {
    return InkWell(
//      focusColor: Colors.black,
//      highlightColor: Colors.black,
//      hoverColor: Colors.black,
      onTap: () {
        if (chartTimeScale != newTimeScale || newChartType != chartType) {
          setState(() {
            chartTimeScale = newTimeScale;
            chartType = newChartType;
          });
        }
      },
      child: new Container(
        //width: 100.0,
        height: 50.0, padding: EdgeInsets.all(10),
        decoration: new BoxDecoration(border: border, color: selected ? Colors.black12 : Colors.white),
        child: new Center(
            child: Text(
          text,
          style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w400),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget chartWidget;

    BorderSide border = BorderSide(color: Colors.black12, width: 1.0);
    if (chartType == ChartType.BAR) {
      chartWidget = FutureBuilder<List<charts.Series<OrdinalHappinessBar, String>>>(
          initialData: new List<charts.Series<OrdinalHappinessBar, String>>(),
          future: _barData,
          builder: (BuildContext context, AsyncSnapshot<List<charts.Series<OrdinalHappinessBar, String>>> snapshot) {
            Widget chart;
            chart = charts.BarChart(snapshot.data,
                animate: animate,
                vertical: false,
                primaryMeasureAxis: new charts.NumericAxisSpec(tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: 1), renderSpec: new charts.NoneRenderSpec()));
            return chart;
          });
    } else {
      chartWidget = FutureBuilder<List<charts.Series<OrdinalHappinessPie, String>>>(
          initialData: new List<charts.Series<OrdinalHappinessPie, String>>(),
          future: _pieData,
          builder: (BuildContext context, AsyncSnapshot<List<charts.Series<OrdinalHappinessPie, String>>> snapshot) {
            return charts.PieChart(snapshot.data,
                animate: animate, defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside)]));
          });
    }
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return Container(
          child: Column(children: <Widget>[
        Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
            child: Row(children: <Widget>[
              makeButton("Day", Border(right: border), TimeScale.DAY, chartType, chartTimeScale == TimeScale.DAY),
              makeButton("Month", Border(right: border), TimeScale.MONTH, chartType, chartTimeScale == TimeScale.MONTH),
              makeButton("Year", Border(right: border), TimeScale.YEAR, chartType, chartTimeScale == TimeScale.YEAR),
              Spacer(),
              makeButton("Pie", Border(left: border), chartTimeScale, ChartType.PIE, chartType == ChartType.PIE),
              makeButton("Bar", Border(left: border), chartTimeScale, ChartType.BAR, chartType == ChartType.BAR)
            ])),
        Container(height: viewportConstraints.maxHeight - 51, child: chartWidget, padding:EdgeInsets.all(10))
      ]));
    });
  }

  Future<List<charts.Series<OrdinalHappinessBar, String>>> createBarData() async {
    List<OrdinalHappinessBar> data = new List<OrdinalHappinessBar>();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var key in prefs.getKeys()) {
      DateTime datetime = new DateFormat("dd-MM-yyyy HH:mm:ss").parse(key);
      bool relevant = false;

      if (chartTimeScale == TimeScale.DAY) {
        relevant = !DateTime.now().isBefore(datetime.subtract(new Duration(hours: 12)));
      } else if (chartTimeScale == TimeScale.MONTH) {
        relevant = !DateTime.now().isBefore(datetime.subtract(new Duration(days: 30)));
      } else if (chartTimeScale == TimeScale.YEAR) {
        relevant = !DateTime.now().isBefore(datetime.subtract(new Duration(days: 365)));
      }

      if (relevant) {
        Color color = Color(prefs.getInt(key));
        charts.Color chartColor = charts.Color(r: color.red, g: color.green, b: color.blue);
        data.add(new OrdinalHappinessBar(datetime, chartColor));
      }
    }

    data.sort((a,b)=>a.date.compareTo(b.date));

//    final data = [
//      new OrdinalHappinessBar('09:00', charts.Color.fromHex(code: "#ff0000")),
//      new OrdinalHappinessBar('10:00', charts.Color.fromHex(code: "#ff0000")),
//      new OrdinalHappinessBar('11:00', charts.Color.fromHex(code: "#ff0000")),
//      new OrdinalHappinessBar('12:00', charts.Color.fromHex(code: "#ff0000")),
//      new OrdinalHappinessBar('13:00', charts.Color.fromHex(code: "#00ff00")),
//      new OrdinalHappinessBar('14:00', charts.Color.fromHex(code: "#ff00ff")),
//      new OrdinalHappinessBar('15:00', charts.Color.fromHex(code: "#ff00ff")),
//      new OrdinalHappinessBar('16:00', charts.Color.fromHex(code: "#ff00ff")),
//      new OrdinalHappinessBar('17:00', charts.Color.fromHex(code: "#00ff00")),
//      new OrdinalHappinessBar('18:00', charts.Color.fromHex(code: "#00ff00")),
//      new OrdinalHappinessBar('19:00', charts.Color.fromHex(code: "#ff0000")),
//      new OrdinalHappinessBar('20:00', charts.Color.fromHex(code: "#ff0000")),
//    ];

    return [
      new charts.Series<OrdinalHappinessBar, String>(
        id: 'Happiness',
        domainFn: (OrdinalHappinessBar sales, _) => new DateFormat("HH:mm").format(sales.date),
        measureFn: (OrdinalHappinessBar sales, _) => 1,
        fillColorFn: (OrdinalHappinessBar sales, _) => sales.color,
        data: data,
      )
    ];
  }

  Future<List<charts.Series<OrdinalHappinessPie, String>>> createPieData() async {
    List<OrdinalHappinessPie> data = new List<OrdinalHappinessPie>();
    HashMap<int, int> dataCount = new HashMap<int, int>();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var key in prefs.getKeys()) {
      DateTime datetime = new DateFormat("dd-MM-yyyy HH:mm:ss").parse(key);
      bool relevant = false;

      if (chartTimeScale == TimeScale.DAY) {
        relevant = !DateTime.now().isBefore(datetime.subtract(new Duration(days: 1)));
      } else if (chartTimeScale == TimeScale.MONTH) {
        relevant = !DateTime.now().isBefore(datetime.subtract(new Duration(days: 30)));
      } else if (chartTimeScale == TimeScale.YEAR) {
        relevant = !DateTime.now().isBefore(datetime.subtract(new Duration(days: 365)));
      }

      if (relevant) {
        dataCount.update(prefs.getInt(key), (value) => ++value, ifAbsent: () => 1);
      }
    }

    for (MapEntry<int, int> entry in dataCount.entries) {
      String emotion = "";
      if (entry.key == EmotionColors.happyColor) emotion = "Happy";
      if (entry.key == EmotionColors.relaxedColor) emotion = "Relaxed";
      if (entry.key == EmotionColors.boredColor) emotion = "Bored";
      if (entry.key == EmotionColors.veryBadColor) emotion = "Very Bad";
      if (entry.key == EmotionColors.anxiousColor) emotion = "Anxious";
      if (entry.key == EmotionColors.numbColor) emotion = "Numb";
      Color color = Color(entry.key);
      charts.Color chartColor = charts.Color(r: color.red, g: color.green, b: color.blue);
      data.add(new OrdinalHappinessPie(emotion, entry.value, chartColor));
    }
//    final data = [
//      new OrdinalHappinessPie('Happy', 5, charts.Color.fromHex(code: "#ff0000")),
//      new OrdinalHappinessPie('Sad', 5, charts.Color.fromHex(code: "#ff0000")),
//      new OrdinalHappinessPie('Anxious', 50, charts.Color.fromHex(code: "#ff0000")),
//    ];
    return [
      new charts.Series<OrdinalHappinessPie, String>(
        id: 'HappinessPie',
        data: data,
        domainFn: (OrdinalHappinessPie data, _) => data.emotion,
        measureFn: (OrdinalHappinessPie data, _) => data.size,
        colorFn: (OrdinalHappinessPie data, _) => data.color,
        labelAccessorFn: (OrdinalHappinessPie data, _) => data.emotion,
      )
    ];
  }
}

enum TimeScale { DAY, MONTH, YEAR }

enum ChartType { PIE, BAR }

class OrdinalHappinessBar {
  final DateTime date;
  final charts.Color color;

  OrdinalHappinessBar(this.date, this.color);
}

class OrdinalHappinessPie {
  final String emotion;
  final int size;
  final charts.Color color;

  OrdinalHappinessPie(this.emotion, this.size, this.color);
}
