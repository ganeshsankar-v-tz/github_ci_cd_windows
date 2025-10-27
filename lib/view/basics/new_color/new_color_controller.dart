import 'dart:convert';

import 'package:abtxt/base/base_controller.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../utils/app_utils.dart';

class NewColorController extends BaseController {
  Map<String, dynamic> request = <String, dynamic>{};
  var filterData;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  Future<List<dynamic>> colors({var request = const {}}) async {
    var permission = box.read('color') ?? false;
    if (permission == false) {
      AppUtils.showErrorToast(message: 'Access Forbidden!');
      return [];
    }
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data'];
      } else {
        var error = jsonDecode(response.data);
      }
    });
    return list;
  }

  void addColor(var request) async {
    var permission = await box.read('color/post') ?? false;
    if (permission == false) {
      AppUtils.showErrorToast(message: 'Access Forbidden!');
      return;
    }
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/color',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
  }

  void edit(var request) async {
    var permission = box.read('updateColor') ?? false;
    if (permission == false) {
      AppUtils.showErrorToast(message: 'Access Forbidden!');
      return;
    }

    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/updateColor',
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
    var permission = box.read('color/delete') ?? false;
    if (permission == false) {
      AppUtils.showErrorToast(message: 'Access Forbidden!');
      return;
    }

    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/delete_color?id=$id&password=$password')
        .then((response) {
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
}
