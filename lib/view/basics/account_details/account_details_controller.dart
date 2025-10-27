import 'dart:convert';

import 'package:abtxt/model/account_details_model/LedgerAccountDetailsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';

class AccountDetailsController extends GetxController with StateMixin {
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;

  RxBool isVisible = RxBool(false);

  String? ledgerRole;

  var filterData;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  Future<List<LedgerAccountDetailsModel>> accountDetailsApiCall(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<LedgerAccountDetailsModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/ledger_account_info_list?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        list = (data as List)
            .map((i) => LedgerAccountDetailsModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
        debugPrint(error);
      }
    });
    return list;
  }

  Future<List<LedgerModel>> ledgerInfo(var role) async {
    change(null, status: RxStatus.loading());
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=$role')
        .then((response) {
      change(null, status: RxStatus.success());
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

  Future<bool?> loomAccountDetailsUpdate(var request) async {
    bool? result;
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/ledger_account_info',
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
