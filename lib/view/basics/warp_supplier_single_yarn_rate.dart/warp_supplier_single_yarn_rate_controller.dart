import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';

class WarpSupplierSingleYarnRateController extends GetxController
    with StateMixin {
  List<LedgerModel> ledger_dropdown = <LedgerModel>[].obs;
  List<YarnModel> yarn_dropdown = <YarnModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};

  @override
  void onInit() async {
    change(ledger_dropdown = await ledgerInfo());
    change(yarn_dropdown = await yarnInfo());
    super.onInit();
  }

  //Dropdown  yarn API call
  Future<List<YarnModel>> yarnInfo() async {
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
    return result;
  }

  //Dropdown  Ledger API call
  Future<List<LedgerModel>> ledgerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=supplier')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<dynamic>> warping({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warpsupplier?$query')
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

  void addNewSingleWarp(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.upload, 'api/warpsupplier',
            formDatas: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void updateNewSingleWarp(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/warpsupplier/$id',
            formDatas: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> deleteNewSingleWarp(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/warpsupplier/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
