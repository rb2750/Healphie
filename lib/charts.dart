import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  Widget makeButton(String text, Border border, TimeScale newTimeScale, ChartType newChartType, bool selected) {
    return InkWell(
//      focusColor: Colors.black,
//      highlightColor: Colors.black,
//      hoverColor: Colors.black,
      onTap: () {
        setState(() {
          chartTimeScale = newTimeScale;
          chartType = newChartType;
        });
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
            chart = charts.BarChart(snapshot.data, animate: animate, vertical: false, primaryMeasureAxis: new charts.NumericAxisSpec(tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: 1), renderSpec: new charts.NoneRenderSpec()));
            return chart;
          });
    } else {
      chartWidget = FutureBuilder<List<charts.Series<OrdinalHappinessPie, String>>>(
          initialData: new List<charts.Series<OrdinalHappinessPie, String>>(),
          future: _pieData,
          builder: (BuildContext context, AsyncSnapshot<List<charts.Series<OrdinalHappinessPie, String>>> snapshot) {
            return charts.PieChart(snapshot.data, animate: animate, defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.outside)]));
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
        Container(height: viewportConstraints.maxHeight - 51, child: chartWidget)
      ]));
    });
  }

  Future<List<charts.Series<OrdinalHappinessBar, String>>> createBarData() async {
    List<String> relevantData = new List<String>();

    final data = [
      new OrdinalHappinessBar('09:00', charts.Color.fromHex(code: "#ff0000")),
      new OrdinalHappinessBar('10:00', charts.Color.fromHex(code: "#ff0000")),
      new OrdinalHappinessBar('11:00', charts.Color.fromHex(code: "#ff0000")),
      new OrdinalHappinessBar('12:00', charts.Color.fromHex(code: "#ff0000")),
      new OrdinalHappinessBar('13:00', charts.Color.fromHex(code: "#00ff00")),
      new OrdinalHappinessBar('14:00', charts.Color.fromHex(code: "#ff00ff")),
      new OrdinalHappinessBar('15:00', charts.Color.fromHex(code: "#ff00ff")),
      new OrdinalHappinessBar('16:00', charts.Color.fromHex(code: "#ff00ff")),
      new OrdinalHappinessBar('17:00', charts.Color.fromHex(code: "#00ff00")),
      new OrdinalHappinessBar('18:00', charts.Color.fromHex(code: "#00ff00")),
      new OrdinalHappinessBar('19:00', charts.Color.fromHex(code: "#ff0000")),
      new OrdinalHappinessBar('20:00', charts.Color.fromHex(code: "#ff0000")),
    ];

    return [
      new charts.Series<OrdinalHappinessBar, String>(
        id: 'Happiness',
        domainFn: (OrdinalHappinessBar sales, _) => sales.year,
        measureFn: (OrdinalHappinessBar sales, _) => 1,
        fillColorFn: (OrdinalHappinessBar sales, _) => sales.color,
        data: data,
      )
    ];
  }

  Future<List<charts.Series<OrdinalHappinessPie, String>>> createPieData() async {
    final data = [
      new OrdinalHappinessPie('Happy', 5, charts.Color.fromHex(code: "#ff0000")),
      new OrdinalHappinessPie('Sad', 50, charts.Color.fromHex(code: "#ff0000")),
      new OrdinalHappinessPie('Anxious', 50, charts.Color.fromHex(code: "#ff0000")),
    ];
    return [
      new charts.Series<OrdinalHappinessPie, String>(
        id: 'HappinessPie',
        data: data,
        domainFn: (OrdinalHappinessPie data, _) => data.emotion,
        measureFn: (OrdinalHappinessPie data, _) => data.size,
        fillColorFn: (OrdinalHappinessPie data, _) => data.color,
        labelAccessorFn: (OrdinalHappinessPie data, _) => data.emotion,
      )
    ];
  }
}

enum TimeScale { DAY, MONTH, YEAR }

enum ChartType { PIE, BAR }

class OrdinalHappinessBar {
  final String year;
  final charts.Color color;

  OrdinalHappinessBar(this.year, this.color);
}

class OrdinalHappinessPie {
  final String emotion;
  final int size;
  final charts.Color color;

  OrdinalHappinessPie(this.emotion, this.size, this.color);
}
