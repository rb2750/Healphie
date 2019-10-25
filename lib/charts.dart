import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TimeVsHappinessBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  TimeVsHappinessBarChart(this.seriesList, {this.animate});

  factory TimeVsHappinessBarChart.withSampleData() {
    return new TimeVsHappinessBarChart(
      createData(),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(seriesList,
        animate: animate,
        vertical: false,
        primaryMeasureAxis: new charts.NumericAxisSpec(tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: 1), renderSpec: new charts.NoneRenderSpec()));
  }

  static List<charts.Series<OrdinalHappiness, String>> createData() {
    final data = [
      new OrdinalHappiness('09:00', charts.Color.fromHex(code: "#ff0000")),
      new OrdinalHappiness('10:00', charts.Color.fromHex(code: "#ff0000")),
      new OrdinalHappiness('11:00', charts.Color.fromHex(code: "#ff0000")),
      new OrdinalHappiness('12:00', charts.Color.fromHex(code: "#ff0000")),
      new OrdinalHappiness('13:00', charts.Color.fromHex(code: "#00ff00")),
      new OrdinalHappiness('14:00', charts.Color.fromHex(code: "#ff00ff")),
      new OrdinalHappiness('15:00', charts.Color.fromHex(code: "#ff00ff")),
      new OrdinalHappiness('16:00', charts.Color.fromHex(code: "#ff00ff")),
      new OrdinalHappiness('17:00', charts.Color.fromHex(code: "#00ff00")),
      new OrdinalHappiness('18:00', charts.Color.fromHex(code: "#00ff00")),
      new OrdinalHappiness('19:00', charts.Color.fromHex(code: "#ff0000")),
      new OrdinalHappiness('20:00', charts.Color.fromHex(code: "#ff0000")),
    ];

    return [
      new charts.Series<OrdinalHappiness, String>(
        id: 'Happiness',
        domainFn: (OrdinalHappiness sales, _) => sales.year,
        measureFn: (OrdinalHappiness sales, _) => 1,
        fillColorFn: (OrdinalHappiness sales, _) => sales.color,
        data: data,
      )
    ];
  }
}

class OrdinalHappiness {
  final String year;
  final charts.Color color;

  OrdinalHappiness(this.year, this.color);
}
