import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/EmptyBeamModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';

class EmptyBeamController extends GetxController with StateMixin {
  List<LedgerModel> ledger_dropdown = <LedgerModel>[].obs;
  @override
  void onInit() async {
    change(ledger_dropdown = await ledgerInfo());
    super.onInit();
  }

//Dropdown  Ledger API call
  Future<List<LedgerModel>> ledgerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/ledger')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        print('----------------------------------------------------');
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> empty({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/emptybeamopening?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        print(json);
        var list =
            (data as List).map((i) => EmptyBeamModel.fromJson(i)).toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <EmptyBeamModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }


  void addEmpty(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/emptybeamopening',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('addEmptyBeam: $json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void updateEmpty(var request, var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.put, 'api/emptybeamopening/$id',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('UpdateEmpty: $json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> deleteEmpty(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/emptybeamopening/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print(json);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
