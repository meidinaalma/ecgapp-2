import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:haloecg/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory SimpleLineChart.withSampleData() {
    return new SimpleLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      seriesList, animate: animate,
      // domainAxis: new charts.OrdinalAxisSpec(
      //   viewport: new charts.OrdinalViewport('4', 90),
      // ),
      // domainAxis: new charts.OrdinalAxisSpec(
      //     viewport: new charts.OrdinalViewport('2018', 4)),
      // // Optionally add a pan or pan and zoom behavior.
      // // If pan/zoom is not added, the viewport specified remains the viewport.
      behaviors: [new charts.PanAndZoomBehavior()],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
      new LinearSales(4, 5),
      new LinearSales(5, 25),
      new LinearSales(6, 100),
      new LinearSales(7, 75),
      new LinearSales(8, 5),
      new LinearSales(9, 25),
      new LinearSales(10, 100),
      new LinearSales(11, 75),
      new LinearSales(12, 5),
      new LinearSales(13, 25),
      new LinearSales(14, 100),
      new LinearSales(15, 75),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
