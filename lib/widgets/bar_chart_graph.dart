import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartGraph extends StatefulWidget {
  List<dynamic> list = [];

  BarChartGraph({super.key, required this.list});

  @override
  State<BarChartGraph> createState() => _BarChartGraphState();
}

class _BarChartGraphState extends State<BarChartGraph> {
  final List<ChartData> chartData = [
    ChartData("JAN", 78),
    ChartData("FEB", 155),
    ChartData("MAR", 221),
    ChartData("APR", 111),
    ChartData("JUN", 181),
    ChartData("AUG", 91),
    ChartData("SEP", 118),
    ChartData("OCT", 118),
    ChartData("NOV", 118),
    ChartData("DEC", 118),
  ];

  @override
  void initState() {
    super.initState();
    widget.list.forEach((element) {
      chartData.add(ChartData(element['month'], element['value']));
    });
  }



  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0.1),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
      ),
      plotAreaBorderWidth: 0,
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<ChartData, String>>[
        ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          width: 0.3,
          color: const Color(0xff9ce0f0),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final dynamic x;
  final dynamic y;
}
