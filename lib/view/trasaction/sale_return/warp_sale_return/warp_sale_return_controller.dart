import 'dart:convert';

import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/model/WarpSaleModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../http/api_repository.dart';
import '../../../../model/credit_note/WarpSaleReturnSlipNoModel.dart';
import '../../../../utils/app_utils.dart';

class WarpSaleReturnController extends GetxController with StateMixin {
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<LedgerModel> accountDropdown = <LedgerModel>[].obs;
  List<WarpDesignModel> designSheetDropdown = <WarpDesignModel>[].obs;
  List<WarpSaleReturnSlipNoModel> slipNoDropdown =
      <WarpSaleReturnSlipNoModel>[].obs;

  @override
  void onInit() async {
    ledgerInfo();
    firmInfo();
    accountInfo();
    designInfo();
    change(null, status: RxStatus.success());
    super.onInit();
  }

  Future<List<WarpSaleReturnSlipNoModel>> slipNoDetails(
      var type, var firmId, var ledgerId) async {
    List<WarpSaleReturnSlipNoModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/credit_note/sale/slip/list?credit_note_type=$type&firm_id=$firmId&customer_id=$ledgerId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((e) => WarpSaleReturnSlipNoModel.fromJson(e))
            .toList();

        slipNoDropdown = result;
        update();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<WarpSaleModel>> warpSaleListApi({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<WarpSaleModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_sale_list?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        list = (data as List).map((i) => WarpSaleModel.fromJson(i)).toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/credit/note',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: true);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
      }
    });
  }

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.put, 'api/credit/note/$id',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: true);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  Future<dynamic> selectedDebitNoteDetails(var id) async {
    change(null, status: RxStatus.loading());
    var list = {};
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/credit_note/slip/details/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data'];
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: ${error['message']}');
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  Future<List<LedgerModel>> ledgerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=customer')
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

  // Dropdown Firm api call
  Future<List<FirmModel>> firmInfo() async {
    List<FirmModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/firm/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => FirmModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(firmDropdown = result);

    return result;
  }

  Future<List<LedgerModel>> accountInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/ledger_by?account_type=Sales Accounts')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(accountDropdown = result);
    return result;
  }

  // Dropdown DesignSheet api call
  Future<List<WarpDesignModel>> designInfo() async {
    List<WarpDesignModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_design_list_in_roller')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => WarpDesignModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(designSheetDropdown = result);
    return result;
  }
}
