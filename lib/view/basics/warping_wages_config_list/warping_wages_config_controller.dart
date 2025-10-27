import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';

class WarpingWagesConfigController extends GetxController with StateMixin {
  List<YarnModel> yarnName = <YarnModel>[].obs;
  Map<String, dynamic> request = <String, dynamic>{};
  var filterData;

  var lastYarnName = "";

  @override
  void onInit() async {
    yarnNameInfo();
    super.onInit();
  }

  //fromYarn
  Future<List<YarnModel>> yarnNameInfo() async {
    List<YarnModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/yarn/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => YarnModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(yarnName = result);
    return result;
  }

  /// Yarn Id By Get Thw Last TO Ends
  Future<dynamic> lastToEnds(var yarnId) async {
    var result = {};
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warping_wages_to_ends?yarn_id=$yarnId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<dynamic>> warpWagesConfig_Get({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warpwageslist?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data'];
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/warpwagsadd',
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

  void updateWarpWages(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/warpwagesupdate',
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

  Future<dynamic> delete(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/warpwagesdelete/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
        //ledgers(page: '1');
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }
}
