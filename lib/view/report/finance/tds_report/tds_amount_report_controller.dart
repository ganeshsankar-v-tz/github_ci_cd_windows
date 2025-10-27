import 'dart:convert';

import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/tds_report/BankSubmittedTdsDetailsModel.dart';
import 'package:abtxt/model/tds_report/TdsAmountDetailsModel.dart';
import 'package:get/get.dart';

import '../../../../http/api_repository.dart';

class TdsAmountReportController extends GetxController with StateMixin {
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<LedgerModel> allLedgerNames = <LedgerModel>[].obs;
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  String payType = "";
  var filterData;
  var paymentDetailsFilterData;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    ledgerInfo("all");
    change(firmDropdown = await firmInfo());
    super.onInit();
  }

  Future<List<BankSubmittedTdsDetailsModel>> bankSubmittedDetails(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<BankSubmittedTdsDetailsModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/tds_banking_report?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        result = (data as List)
            .map((i) => BankSubmittedTdsDetailsModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  Future<List<TdsAmountDetailsModel>> tdsAmountDetails(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<TdsAmountDetailsModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/payment_tds_report_list?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        result = (data as List)
            .map((i) => TdsAmountDetailsModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  Future<List<FirmModel>> firmInfo() async {
    change(null, status: RxStatus.loading());
    List<FirmModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/firm/list')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => FirmModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<LedgerModel>> ledgerInfo(var roll) async {
    change(null, status: RxStatus.loading());
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=$roll')
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

  Future<List<LedgerModel>> allLedgerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=all')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(allLedgerNames = result);
    return result;
  }

  Future<dynamic?> tdsAmountPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var result;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/tds_banking_report_details?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        result = json['data'];
      }
    });
    return result;
  }

  Future<String?> selectedAmountSubmit(var request) async {
    change(null, status: RxStatus.loading());
    String? result;
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/payment_tds_store',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = "success";
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
    return result;
  }
}
