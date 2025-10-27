import 'dart:convert';

import 'package:abtxt/model/vehicle_details/VehicleDetailsModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';

class VehicleDetailsController extends GetxController with StateMixin {
  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  Future<List<VehicleDetailsModel>> vehicleDetails(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<VehicleDetailsModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/transport_list?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        result =
            (data as List).map((i) => VehicleDetailsModel.fromJson(i)).toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/transport_post',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "Added successfully");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  void edit(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/transport_update',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "Updated successfully");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/transport_delete?id=$id&password=$password')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
