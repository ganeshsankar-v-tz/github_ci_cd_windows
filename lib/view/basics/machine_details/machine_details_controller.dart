import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../utils/app_utils.dart';

class MachineDetailsController extends GetxController with StateMixin {
  @override
  void onInit() {
    super.onInit();
  }

  Future<List<dynamic>> machineDetails() async {
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/machine_payment_list')
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

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/machine_payment_store',
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
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/machine_payment_update',
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
            'api/machine_payment_delete?id=$id&password=$password')
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
