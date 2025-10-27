import 'dart:convert';

import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/warp_tracking/WarpCurrentPositionModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LoomModel.dart';

class WarpTrackingController extends GetxController with StateMixin {
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<LoomModel> loomList = <LoomModel>[].obs;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    ledgerInfo();
    super.onInit();
  }

  Future<List<LedgerModel>> ledgerInfo() async {
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
    change(ledgerDropdown = result);
    return result;
  }

  Future<List<LoomModel>> loomInfo(var id) async {
    List<LoomModel> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/active_looms_only?weaver_id=$id')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LoomModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(loomList = result);
    return result;
  }

  Future<List<WarpCurrentPositionModel>> currentPositionDetails(
      int weaverId, subWeaverNo) async {
    change(null, status: RxStatus.loading());
    List<WarpCurrentPositionModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/warp_tracking_use_weaver_date?weaver_id=$weaverId&sub_weaver_no=$subWeaverNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WarpCurrentPositionModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
}
