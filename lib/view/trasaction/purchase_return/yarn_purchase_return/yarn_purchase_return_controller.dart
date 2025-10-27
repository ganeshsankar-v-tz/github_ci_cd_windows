import 'dart:convert';

import 'package:abtxt/model/AccountTypeModel.dart';
import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/model/debit_note/DebitNoteSlipNoDropdown.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../http/api_repository.dart';
import '../../../../model/TaxFixingModel.dart';

class YarnPurchaseReturnController extends GetxController with StateMixin {
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<AccountTypeModel> accountDropdown = <AccountTypeModel>[].obs;
  List<YarnModel> yarnDropdown = <YarnModel>[].obs;
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<TaxFixingModel> taxFix = <TaxFixingModel>[].obs;
  List<LedgerModel> ledgerByTax = <LedgerModel>[].obs;
  List<LedgerModel> purchaseAccountDropdown = <LedgerModel>[].obs;
  List<DebitNoteSlipNoDropdown> slipNoDropdown =
      <DebitNoteSlipNoDropdown>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};

  @override
  void onInit() async {
    change(ledgerDropdown = await ledgerInfo());
    change(firmDropdown = await firmInfo());
    change(accountDropdown = await accountInfo());
    change(yarnDropdown = await yarnnameInfo());
    change(colorDropdown = await colorInfo());
    change(ledgerByTax = await ledgerByTaxCalling());
    change(null, status: RxStatus.success());
    super.onInit();
  }

  Future<List<LedgerModel>> ledgerByTaxCalling() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/ledger_by_tax_Calculation_drop_down')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<DebitNoteSlipNoDropdown>> slipNoDetails(
      var type, var firmId, var ledgerId) async {
    List<DebitNoteSlipNoDropdown> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/purchased/slip/list?debit_note_type=$type&firm_id=$firmId&supplier_id=$ledgerId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((e) => DebitNoteSlipNoDropdown.fromJson(e))
            .toList();

        slipNoDropdown = result;
        update();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> selectedDebitNoteDetails(var id) async {
    change(null, status: RxStatus.loading());
    var list = {};
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/debit_note/slip/details/$id')
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

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/debit/note',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: true);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
      }
    });
  }

  void edit(var request,var id) async {
    await HttpRepository.apiRequest(HttpRequestType.put, 'api/debit/note/$id',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: true);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
        Get.back();
      }
    });
  }

  // Dropdown ledger api call
  Future<List<LedgerModel>> ledgerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=supplier')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  // Dropdown firm api call
  Future<List<FirmModel>> firmInfo() async {
    List<FirmModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/firm/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => FirmModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  // Dropdown account api call
  Future<List<AccountTypeModel>> accountInfo() async {
    List<AccountTypeModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/account_list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => AccountTypeModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  // Dropdown yarnName Api call
  Future<List<YarnModel>> yarnnameInfo() async {
    List<YarnModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/yarn/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => YarnModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  // Dropdown colorName Api call
  Future<List<NewColorModel>> colorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<TaxFixingModel>> taxFixing(String entryType) async {
    List<TaxFixingModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/tax_fixing?entry_type=$entryType')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => TaxFixingModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }
}
