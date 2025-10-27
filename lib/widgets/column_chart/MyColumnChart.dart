import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyColumnChart extends StatefulWidget {
  final List<CartesianSeries> cartesianSeries;

  const MyColumnChart({
    super.key,
    required this.cartesianSeries,
  });

  @override
  State<MyColumnChart> createState() => _MyColumnChartState();
}

class _MyColumnChartState extends State<MyColumnChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: "",
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        tooltipBehavior: _tooltipBehavior,
        primaryXAxis:
            const CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
        primaryYAxis:
            const NumericAxis(majorGridLines: MajorGridLines(width: 0)),
        plotAreaBorderWidth: 0,
        series: widget.cartesianSeries,
        palette: const <Color>[Color(0xff2196F3)],
      ),
    );
  }
}
