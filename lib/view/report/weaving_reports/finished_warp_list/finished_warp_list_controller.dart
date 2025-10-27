import 'dart:convert';

import 'package:abtxt/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../http/api_repository.dart';
import '../../../../model/LedgerModel.dart';
import '../../../../model/LoomGroup.dart';
import '../../../../model/LoomModel.dart';
import '../../../../model/ProductInfoModel.dart';

class FinishedWarpListReportController extends GetxController with StateMixin {
  List<LedgerModel> weaverNameList = <LedgerModel>[].obs;
  List<ProductInfoModel> productNameList = <ProductInfoModel>[].obs;
  List<LoomGroup> loomList = <LoomGroup>[].obs;

  var filterData;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    ledger();
    productInfo();

    super.onInit();
  }

  /// Product Name
  Future<List<ProductInfoModel>> productInfo() async {
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productinfolist/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => ProductInfoModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(productNameList = result);
    return result;
  }

  // Weaver Name
  Future<List<LedgerModel>> ledger() async {
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
    change(weaverNameList = result);
    return result;
  }

  Future<List<dynamic>> finishedWarp({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/finised_warp_list_and_pdf?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json["data"];
      } else {
        var error = jsonDecode(response.data);
      }
    });
    return list;
  }

  /// Selected Id Full Detailed Report Pdf
  Future<String?> detailedReport(var weavingAcId) async {
    change(null, status: RxStatus.loading());
    var url;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/finised_warp_account_details?weaving_ac_id=$weavingAcId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Selected weavNo To UnFinish
  Future<String?> unFinishApiCall(
      var weavingAcId, var weaverId, var loomNo, var password) async {
    String? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/account_unfinished?weaving_ac_id=$weavingAcId&weaver_id=$weaverId&loom_no=$loomNo&password=$password')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        result = "success";
      } else {
        debugPrint('error: $json');
      }
    });
    return result;
  }

  Future<List<LoomGroup>> loomInfo(var id) async {
    List<LoomGroup> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/weavingloom?weaver_id=$id')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        final gMap = (data as List).groupBy((m) => m['sub_weaver_no']);
        result = gMap.entries.map((entry) {
          var looms = (entry.value).map((i) => LoomModel.fromJson(i)).toList();
          return LoomGroup(loomNo: entry.key, looms: looms);
        }).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(loomList = result);
    return result;
  }
}
