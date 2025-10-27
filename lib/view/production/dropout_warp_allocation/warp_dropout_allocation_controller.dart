import 'dart:convert';

import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/warp_dropout_allocation/DropoutWarpDetailsModel.dart';
import 'package:abtxt/model/warp_dropout_allocation/WarpDropoutAllocationModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LoomModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../utils/app_utils.dart';

class WarpDropOutAllocationController extends GetxController with StateMixin {
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<LoomModel> loomList = <LoomModel>[].obs;
  List<DropoutWarpDetailsModel> dropoutWarpId = <DropoutWarpDetailsModel>[].obs;
  List<NewWarpModel> newWarpDropDown = <NewWarpModel>[].obs;

  var filterData;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    ledgerInfo();
    newWarpInfo();
    super.onInit();
  }

  Future<List<NewWarpModel>> newWarpInfo() async {
    List<NewWarpModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/newwrap/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => NewWarpModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(newWarpDropDown = result);
    return result;
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

  Future<List<DropoutWarpDetailsModel>> dropoutWarpIdDetails() async {
    dropoutWarpId = <DropoutWarpDetailsModel>[].obs;
    List<DropoutWarpDetailsModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_dropout_delivery_list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => DropoutWarpDetailsModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(dropoutWarpId = result);
    return result;
  }

  Future<List<WarpDropoutAllocationModel>> warpDropoutList(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<WarpDropoutAllocationModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_drop_out_list?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json["data"];
        list = (data as List)
            .map((i) => WarpDropoutAllocationModel.fromJson(i))
            .toList();
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
            HttpRequestType.post, 'api/dropout_warp_allocation',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
      }
    });
  }

  void edit(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/dropout_warp_allocation_update',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  /* Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/warp_dropout_delivery_list?id=$id&password=$password')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }*/

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
}
