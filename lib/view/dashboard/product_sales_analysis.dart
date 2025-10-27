import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../http/api_repository.dart';
import '../../utils/constant.dart';
import '../../widgets/MyDropdownButtonFormField.dart';
import '../../widgets/bar_chart_graph.dart';

class ProductSalesAnalysis extends StatelessWidget {
  ProductSalesAnalysis({super.key});

  ProductSalesAnalysisController controller = Get.put(ProductSalesAnalysisController());
  TextEditingController yearController = TextEditingController(text: Constants.YEARS[0]);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductSalesAnalysisController>(
      builder: (controller) => Card(
        margin: EdgeInsets.all(16),
        child: Container(
          color: Colors.white,
          width: Get.width,
          padding: EdgeInsets.all(16),
          child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Sales Analysis',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₹${controller.productSales}',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                        MyDropdownButtonFormField(
                          onChanged: (value) {
                            controller.saleAnalysis({'year': '${value}'});
                          },
                          controller: yearController,
                          hintText: "",
                          items: Constants.YEARS,
                        ),
                      ],
                    ),
                  ),
                  SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      axisLine: const AxisLine(width: 0.1),
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      axisLine: const AxisLine(width: 0),
                      isVisible: false,
                    ),
                    plotAreaBorderWidth: 0,
                    series: <CartesianSeries>[
                      ColumnSeries<ChartData, String>(
                        dataSource: controller.chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        width: 0.35,
                        color: const Color(0xff9ce0f0),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class ProductSalesAnalysisController extends GetxController with StateMixin {
  RxList<ChartData> chartData = RxList([]);
  Rx<dynamic> productSales = Rx<dynamic>(0);

  @override
  void onInit() async {
    change(['ProductSalesAnalysisController'], status: RxStatus.success());
    saleAnalysis({'year': '2023'});
    super.onInit();
  }

  void saleAnalysis(var request) async {
    change(['ProductSalesAnalysisController'], status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/sale_analysis',
            requestBodydata: request)
        .then((response) async {
      var json = jsonDecode(response.data);
      if (response.success) {
        var monthlyTotal = json['monthlyTotal'];
        productSales.value = json['Product Sales'];
        chartData = RxList<ChartData>();
        chartData.addAll([
          ChartData("JAN", monthlyTotal['JAN']),
          ChartData("FEB", monthlyTotal['FEB']),
          ChartData("MAR", monthlyTotal['MAR']),
          ChartData("APR", monthlyTotal['APR']),
          ChartData("MAY", monthlyTotal['MAY']),
          ChartData("JUN", monthlyTotal['JUN']),
          ChartData("JUL", monthlyTotal['JUL']),
          ChartData("AUG", monthlyTotal['AUG']),
          ChartData("SEP", monthlyTotal['SEP']),
          ChartData("OCT", monthlyTotal['OCT']),
          ChartData("NOV", monthlyTotal['NOV']),
          ChartData("DEC", monthlyTotal['DEC']),
        ]);
        change(['ProductSalesAnalysisController'], status: RxStatus.success());
      } else {
        print('error: ${json['message']}');
        change(['ProductSalesAnalysisController'], status: RxStatus.error());
      }
    });
  }
}
