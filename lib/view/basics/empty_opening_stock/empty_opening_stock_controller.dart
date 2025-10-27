import 'dart:convert';

import 'package:abtxt/model/empty_opening_stock_model.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../utils/app_utils.dart';

class EmptyOpeningStockController extends GetxController with StateMixin {
  @override
  void onInit() async {
    super.onInit();
  }

  Future<dynamic> empty({var page = "1",var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/emptyopening?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => EmptyOpeningStockModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <EmptyOpeningStockModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void addEmpty(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/addemptyopen',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('addEmptyBeam: $json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void updateEmpty(var request, var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/updateemptyopen/$id',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> deleteEmpty(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/deleteemptyopen/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print(json);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
