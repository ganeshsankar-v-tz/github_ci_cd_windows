import 'dart:convert';

import 'package:abtxt/model/YarnStockReportHistoryModel.dart';
import 'package:abtxt/model/YarnStockReportModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';

class YarnStockReportController extends GetxController with StateMixin {
  @override
  void onInit() async {
    super.onInit();
  }

  Future<dynamic> yarnStock({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/getYarnStockDetails?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['yarn'];
        var list = (data as List)
            .map((i) => YarnStockReportModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <YarnStockReportModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  Future<dynamic> yarnStockHistory({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/yarnpurchase?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => YarnStockReportHistoryModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <YarnStockReportModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }
}
