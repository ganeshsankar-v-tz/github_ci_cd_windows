import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';

class AppendLedgerController extends GetxController with StateMixin {
  List<LedgerModel> weaverList = <LedgerModel>[].obs;
  List<LedgerModel> allLedgerList = <LedgerModel>[].obs;
  List<LedgerModel> appendLedgerList = <LedgerModel>[].obs;

  var weaverId;

  @override
  void onInit() async {
    super.onInit();
    change(weaverList = await weavers());
    change(allLedgerList = await ledgers());
  }

  Future<List<LedgerModel>> ledgers() async {
    List<LedgerModel> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/append_role')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  Future<List<LedgerModel>> weavers() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=weaver')
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

  Future<List<LedgerModel>> appendLedgers(var id) async {
    weaverId = id;
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/append_ledger?weaver_id=$id')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(appendLedgerList = result);
    return result;
  }

  void add(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/ledger_add',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        appendLedgers(weaverId);
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
  }

  Future<dynamic> delete(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/append_delete/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        appendLedgers(weaverId);
        // Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
