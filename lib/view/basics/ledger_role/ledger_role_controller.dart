import 'dart:convert';

import 'package:abtxt/model/LedgerRole.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';

class LedgerRoleController extends GetxController with StateMixin {
  @override
  void onInit() async {
    super.onInit();
  }

  Future<dynamic> ledgerRoles({var page = "1", var limit = "10"}) async {
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/ledger_role?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List).map((i) => LedgerRole.fromJson(i)).toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <LedgerRole>[], "totalPage": 1};
      }
    });
    return result;
  }

  void add(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/ledger_role',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back();
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void edit(var request, var id) async {
    await HttpRepository.apiRequest(HttpRequestType.put, 'api/ledger_role/$id',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back();
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> delete(var id) async {
    print('delete');
    await HttpRepository.apiRequest(HttpRequestType.delete, 'api/ledger/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
