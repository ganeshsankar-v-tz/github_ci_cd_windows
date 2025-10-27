import 'dart:convert';

import 'package:abtxt/model/weaving_models/weft_balance/OtherWarpBalanceModel.dart';
import 'package:abtxt/model/weaving_models/weft_balance/OverAllWeftBalanceModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/WeavingWeftBalanceModel.dart';
import '../../../model/weaving_models/weft_balance/WeaverByWeftBalanceModel.dart';

class WeavingWeftBalanceController extends GetxController with StateMixin {
  List<LoomNoModel> loomDropDown = <LoomNoModel>[].obs;

  Future<List<WeavingWeftBalanceModel>> weavingWftBalance(var weavingId) async {
    List<WeavingWeftBalanceModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/weft_balane?weaving_ac_id=$weavingId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WeavingWeftBalanceModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
    return result;
  }

  Future<List<OtherWarpBalanceModel>> otherWarpBalance(
      var weaverId, var loomNo) async {
    List<OtherWarpBalanceModel> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/other_warp_balance?weaver_id=$weaverId&loom=$loomNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => OtherWarpBalanceModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
    return result;
  }

  Future<WeaverByWeftBalanceModel?> weavingWftBalanceNew(var weavingId) async {
    WeaverByWeftBalanceModel? result;
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/single_ac_weft_balance_v2?weaving_ac_id=$weavingId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        change(null, status: RxStatus.success());
        var data = json['data'];
        result = WeaverByWeftBalanceModel.fromJson(data);
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
    return result;
  }

  Future<String?> weavingWftBalanceRefresh(var weavingId) async {
    String? result;
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/refresh_weft?weaving_ac_id=$weavingId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
    return result;
  }

  Future<OverAllWeftBalanceModel?> overAllWeftBalance(
      var weaverId, var loomNo) async {
    OverAllWeftBalanceModel? result;
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/all_weft_balance_v2?weaver_id=$weaverId&loom=$loomNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = OverAllWeftBalanceModel.fromJson(data);
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
    return result;
  }

  Future<List<LoomNoModel>> loonNoDetails(var weaverId) async {
    List<LoomNoModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/loom_list_for_weftbalance?weaver_id=$weaverId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LoomNoModel.fromJson(i)).toList();
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
    change(loomDropDown = result);
    return result;
  }
}

class LoomNoModel {
  String? subWeaverNo;

  LoomNoModel({this.subWeaverNo});

  LoomNoModel.fromJson(Map<String, dynamic> json) {
    subWeaverNo = json['sub_weaver_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_weaver_no'] = subWeaverNo;
    return data;
  }

  @override
  String toString() {
    return "$subWeaverNo";
  }
}
