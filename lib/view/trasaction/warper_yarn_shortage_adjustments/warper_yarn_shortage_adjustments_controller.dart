import 'dart:convert';

import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../utils/app_utils.dart';

class WarperYarnShortageAdjustmentsController extends GetxController
    with StateMixin {
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<YarnModel> yarnDropdown = <YarnModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  var filterData;

  @override
  void onInit() async {
    ledgerInfo();
    change(colorDropdown = await colorInfo());
    change(yarnDropdown = await yarnnameInfo());
    super.onInit();
  }

  Future<List<dynamic>> warperYarnShortage({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/yarn_shortage_list?$query')
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
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/yarn_shortage_add',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        // print('addLedger: $json');
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/yarn_shortage_update',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
        Get.back();
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/warper_yarn_shortage_delete?id=$id&password=$password')
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

  Future<List<LedgerModel>> ledgerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=warper')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(ledgerDropdown = result);
    return result;
  }

  //Dropdown Color API call
  Future<List<NewColorModel>> colorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        // print(data);
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();

        //  print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // Dropdown yarnName Api call
  Future<List<YarnModel>> yarnnameInfo() async {
    List<YarnModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/yarn_list?yarn_type=Other')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        //  print(response.success);
        var data = json['data'];
        //  print(data);
        result = (data as List).map((i) => YarnModel.fromJson(i)).toList();
        //  print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
}
