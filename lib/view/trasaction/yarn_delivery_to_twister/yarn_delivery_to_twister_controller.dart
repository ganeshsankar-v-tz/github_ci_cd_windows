import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/JariTwistingModel.dart';
import '../../../model/MachineDetailsModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/YarnModel.dart';
import '../../../model/YarnStockBalanceModel.dart';
import '../../../utils/app_utils.dart';

class YarnDeliveryToTwisterController extends GetxController with StateMixin {
  Map<String, dynamic> request = <String, dynamic>{};
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<MachineDetailsModel> machineDetails = <MachineDetailsModel>[].obs;
  List<JariTwistingModel> inwardYarnDetails = <JariTwistingModel>[].obs;
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<YarnModel> deliveryYarnDetails = <YarnModel>[].obs;

  var itemList = <dynamic>[];
  var filterData;

  @override
  void onInit() {
    super.onInit();
    firmInfo();
    deliverYarnInfo();
    inwardYarnInfo();
    machineInfo();
    colorInfo();
  }

  /// Check The Yarn Balance In Stocks
  Future<YarnStockBalanceModel?> yarnStockBalance(
      var yarnId, var colorId, var stockIn) async {
    change(null, status: RxStatus.loading());
    YarnStockBalanceModel? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/overall_balance_yarn_stock?yarn_id=$yarnId&color_id=$colorId&stock_in=$stockIn')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = YarnStockBalanceModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<NewColorModel>> colorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(colorDropdown = result);
    return result;
  }

  Future<List<MachineDetailsModel>> machineInfo() async {
    change(null, status: RxStatus.loading());
    List<MachineDetailsModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/machine_payment_list')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        result =
            (data as List).map((i) => MachineDetailsModel.fromJson(i)).toList();
      } else {
        var error = jsonDecode(response.data);
        debugPrint(error);
      }
    });
    change(machineDetails = result);
    return result;
  }

  Future<List<YarnModel>> deliverYarnInfo() async {
    List<YarnModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/yarn_list?yarn_type=Other')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => YarnModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(deliveryYarnDetails = result);
    return result;
  }

  Future<List<JariTwistingModel>> inwardYarnInfo() async {
    List<JariTwistingModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/get_yarns_from_jaritwisting')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => JariTwistingModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    change(inwardYarnDetails = result);
    return result;
  }

  Future<List<FirmModel>> firmInfo() async {
    List<FirmModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/firm/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => FirmModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(firmDropdown = result);
    return result;
  }

  Future<List<dynamic>> yarnDeliveryToTwister({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/twisting_yarn_delivery_list?$query')
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
            HttpRequestType.post, 'api/twisting_yarn_delivery_post',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/twisting_yarn_delivery_update',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('$error');
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/twisting_yarn_delivery_delete?id=$id&password=$password')
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
