import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../utils/app_utils.dart';

class WarpGroupController extends GetxController with StateMixin {
  Map<String, dynamic> request = <String, dynamic>{};

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  Future<List<dynamic>> warp({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/warpgroup?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data']['data'];
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  void addNewWarp(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/warpgroup',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  void updateNewWarp(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.put, 'api/warpgroup/$id',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/delete_warpgroup?id=$id&password=$password')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error["message"]}');
      }
    });
  }
}
