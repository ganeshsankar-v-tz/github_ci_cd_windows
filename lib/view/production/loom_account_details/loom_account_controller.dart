import 'dart:convert';

import 'package:abtxt/model/loom_account_model/LoomAccountDetailsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';

class LoomAccountController extends GetxController with StateMixin {
  List<LedgerModel> weaverDetails = <LedgerModel>[].obs;

  RxBool apiCall = RxBool(false);

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    weaverInfo();
    super.onInit();
  }

  Future<List<LoomAccountDetailsModel>> accountDetailsApiCall(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<LoomAccountDetailsModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/loom_account_filter?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        list = (data as List)
            .map((i) => LoomAccountDetailsModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
        debugPrint(error);
      }
    });
    return list;
  }

  Future<List<LedgerModel>> weaverInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=weaver')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        var error = jsonDecode(response.data);
        debugPrint(error);
      }
    });
    change(weaverDetails = result);
    return result;
  }

  Future<bool?> loomAccountDetailsUpdate(var request) async {
    bool? result;
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/loom_account_details_update',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        result = true;
      } else {
        result = false;
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
    return result;
  }
}
