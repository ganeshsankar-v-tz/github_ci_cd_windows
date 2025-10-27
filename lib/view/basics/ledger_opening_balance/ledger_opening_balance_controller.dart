import 'dart:convert';

import 'package:abtxt/model/ledger_opening_balance_model.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/AccountTypeModel.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/LedgerRole.dart';
import '../../../utils/app_utils.dart';

class LedgerOpeningBalanceController extends GetxController with StateMixin {
  List<FirmModel> firm_dropdown = <FirmModel>[].obs;
  List<LedgerRole> role_dropdown = <LedgerRole>[].obs;
  List<LedgerModel> ledger_dropdown = <LedgerModel>[].obs;
  List<AccountTypeModel> account_dropdown = <AccountTypeModel>[].obs;

  @override
  void onInit() async {
    change(firm_dropdown = await firmInfo());
    change(role_dropdown = await roleInfo());
    change(ledger_dropdown = await ledgerInfo());
    change(account_dropdown = await accountInfo());
    super.onInit();
  }
  //Dropdown  Firm API call

  Future<List<FirmModel>> firmInfo() async {
    List<FirmModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/firm/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        print(data);
        result = (data as List).map((i) => FirmModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //Dropdown  Role API call
  Future<List<LedgerRole>> roleInfo() async {
    List<LedgerRole> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/ledger_role')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        result = (data as List).map((i) => LedgerRole.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
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
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //Dropdown  Account API call
  Future<List<AccountTypeModel>> accountInfo() async {
    List<AccountTypeModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/account_list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        print(data);
        result =
            (data as List).map((i) => AccountTypeModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
  //-----------------------------------

  Future<dynamic> ledgerOpeningBalance(
      {var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/ledgeropening?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => LedgerOpeningBalanceModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <LedgerOpeningBalanceModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void addledgerOpeningBalance(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/ledgeropening',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('addLedger: $json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void updateledgerOpening(var request, var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.put, 'api/ledgeropening/$id',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> deleteLedgerOpening(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/ledgeropening/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
