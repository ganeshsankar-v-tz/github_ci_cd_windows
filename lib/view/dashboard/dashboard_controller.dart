import 'dart:convert';

import 'package:get/get.dart';

import '../../http/api_repository.dart';
import '../../model/WarpStockDashboard.dart';
import '../../model/YarnStockDashboard.dart';

class DashboardController extends GetxController with StateMixin {
  dynamic profitAmount = 0.0.obs;
  dynamic purchaseAmount = 0.0.obs;
  dynamic salesAmount = 0.0.obs;
  RxList<YarnStockDashboard> yarnStockList = RxList<YarnStockDashboard>();
  RxList<WarpStockDashboard> warpStockList = RxList<WarpStockDashboard>();
  RxList<dynamic> salesAnalysisList = RxList<dynamic>();
  dynamic productSales = 0.0.obs;
  var item = "".obs;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    super.onInit();
    //_amountAnalysis();
    //_yarnStock();
    //_warpStock();
  }

  void _amountAnalysis() async {
    change(['someOtherID'], status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/amount_Analysis?page=1&limit=5')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        profitAmount.value = data['Profit_Amount'];
        purchaseAmount.value = double.tryParse('${data['Purchase_Amount']}') ?? 0.0;
        salesAmount.value = data['Sales_Amount'];
        change(['someOtherID'], status: RxStatus.success());
      } else {
        print('error: ${json['message']}');
        change(['someOtherID'], status: RxStatus.error('${json['message']}'));
      }
    });
  }

  void _yarnStock() async {
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/yarn_stocks?page=1&limit=5')
        .then((response) async {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']['data'];
        yarnStockList.value =
            (data as List).map((i) => YarnStockDashboard.fromJson(i)).toList();
        change(null, status: RxStatus.success());
      } else {
        print('error: ${json['message']}');
      }
    });
  }

  void _warpStock() async {
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_stocks?page=1&limit=5')
        .then((response) async {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']['data'];
        warpStockList.value = (data as List).map((i) => WarpStockDashboard.fromJson(i)).toList();
        change(null, status: RxStatus.success());
      } else {
        print('error: ${json['message']}');
      }
    });
  }

  void saleAnalysis(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/sale_analysis',
            requestBodydata: request)
        .then((response) async {
      var json = jsonDecode(response.data);
      if (response.success) {
        var monthlyTotal = json['monthlyTotal'];
        productSales.value = json['Product Sales'];
        salesAnalysisList.addAll([
          {'month': 'JAN', 'value': monthlyTotal['JAN']},
          {'month': 'FEB', 'value': monthlyTotal['FEB']},
          {'month': 'MAR', 'value': monthlyTotal['MAR']},
          {'month': 'APR', 'value': monthlyTotal['APR']},
          {'month': 'MAY', 'value': monthlyTotal['MAY']},
          {'month': 'JUN', 'value': monthlyTotal['JUN']},
          {'month': 'JUL', 'value': monthlyTotal['JUL']},
          {'month': 'AUG', 'value': monthlyTotal['AUG']},
          {'month': 'SEP', 'value': monthlyTotal['SEP']},
          {'month': 'OCT', 'value': monthlyTotal['OCT']},
          {'month': 'NOV', 'value': monthlyTotal['NOV']},
          {'month': 'DEC', 'value': monthlyTotal['DEC']},
        ]);
        change(salesAnalysisList, status: RxStatus.success());
      } else {
        print('error: ${json['message']}');
      }
    });
  }
}
