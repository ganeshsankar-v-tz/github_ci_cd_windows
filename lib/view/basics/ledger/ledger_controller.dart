import 'dart:convert';

import 'package:abtxt/utils/app_utils.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/AccountTypeModel.dart';
import '../../../model/FirmModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/ledger_role_model.dart';

class LedgerController extends GetxController with StateMixin {
  List<AccountTypeModel> accountGroup = <AccountTypeModel>[].obs;
  List<FirmModel> firm_dropdown = <FirmModel>[].obs;
  List<LedgerRoleModel> ledgerRoles = <LedgerRoleModel>[].obs;
  List<NewColorModel> warpColor_dropdown = <NewColorModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  var filterData;

  var loading = false;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    change(accountGroup = await accountInfo());
    change(firm_dropdown = await firmInfo());
    change(ledgerRoles = await roleInfo());
    change(warpColor_dropdown = await warpColorInfo());
    loading = false;
    super.onInit();
  }

  //Warp Color
  Future<List<NewColorModel>> warpColorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //AccountGroup Dropdown
  Future<List<AccountTypeModel>> accountInfo() async {
    List<AccountTypeModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/account_type/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => AccountTypeModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //Dropdown  Firm API call

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
    return result;
  }

  Future<List<LedgerRoleModel>> roleInfo() async {
    List<LedgerRoleModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/ledger_role')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => LedgerRoleModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<dynamic>> ledgers({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/ledger?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data'];
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  void addLedger(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.upload, 'api/add_ledger',
            formDatas: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "Added successfully");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void updateLedger(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.upload, 'api/update_ledger',
            formDatas: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "Updated successfully");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/delete_ledger?id=$id&password=$password')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
