import 'dart:convert';

import 'package:abtxt/model/administrator/AdministratorModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../http/api_repository.dart';

class AdministratorController extends GetxController with StateMixin {
  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  Future<List<AdministratorModel>> userDetailsList(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<AdministratorModel> list = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/user_list?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        list =
            (data as List).map((i) => AdministratorModel.fromJson(i)).toList();
      } else {
        var error = jsonDecode(response.data);
        debugPrint(error);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  Future<bool?> adminLoginCheck(var name, var password) async {
    bool? result;
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/check_admin_authentication?admin_user_name=$name&password=$password')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<bool?> newUserAdd(var request) async {
    change(null, status: RxStatus.loading());
    bool? result;
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/register',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = json["data"];
      } else {
        var error = jsonDecode(response.data);
      }
    });
    return result;
  }

  void userActiveStatusChange(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/active_status_update',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        AppUtils.showSuccessToast(message: json["message"]);
      } else {
        var error = jsonDecode(response.data);
      }
    });
  }
}
