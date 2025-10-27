import 'dart:convert';

import 'package:abtxt/model/warp_id_details/NewWarpIdDetailsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../http/api_repository.dart';
import '../../../../model/FirmModel.dart';
import '../../../../model/LedgerModel.dart';
import '../../../../model/LoomModel.dart';
import '../../../../model/NewColorModel.dart';
import '../../../../model/NewWarpModel.dart';
import '../../../../model/TaxFixingModel.dart';
import '../../../../model/debit_note/WarpPurchaseReturnSlipNoDropdown.dart';
import '../../../../utils/app_utils.dart';

class WarpPurchaseReturnController extends GetxController with StateMixin {
  List<FirmModel> firmNameDropdown = <FirmModel>[].obs;
  List<LedgerModel> supplierName = <LedgerModel>[].obs;
  List<LedgerModel> accountDropDown = <LedgerModel>[].obs;
  List<LedgerModel> ledgerByTax = <LedgerModel>[].obs;
  List<WarpPurchaseReturnSlipNoDropdown> slipNoDropdown =
      <WarpPurchaseReturnSlipNoDropdown>[].obs;

  // AddItem
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<NewWarpModel> warpDesignDropdown = <NewWarpModel>[].obs;
  List<LedgerModel> weaverDropdown = <LedgerModel>[].obs;
  List<LoomModel> loomList = <LoomModel>[].obs;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    ledgerInfo();
    accountInfo();
    change(weaverDropdown = await weaverInfo());
    change(firmNameDropdown = await firmInfo());
    change(ledgerByTax = await ledgerByTaxCalling());
    // AddItem
    change(colorDropdown = await colorInfo());
    change(warpDesignDropdown = await warpInfo());
    super.onInit();
  }

  Future<List<WarpPurchaseReturnSlipNoDropdown>> slipNoDetails(
      var type, var firmId, var ledgerId) async {
    List<WarpPurchaseReturnSlipNoDropdown> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/purchased/slip/list?debit_note_type=$type&firm_id=$firmId&supplier_id=$ledgerId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((e) => WarpPurchaseReturnSlipNoDropdown.fromJson(e))
            .toList();
        slipNoDropdown = result;
        update();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<LedgerModel>> weaverInfo() async {
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
        print('error: ${json['message']}');
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
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // ColorDropDown
  Future<List<NewColorModel>> colorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color/list')
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

  // Firm
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

  // Customer Name
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
        print('error: ${json['message']}');
      }
    });
    change(supplierName = result);
    return result;
  }

  // Account Type

  Future<List<LedgerModel>> accountInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/ledger_by?account_type=Purchase Accounts')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(accountDropDown = result);
    return result;
  }

  // Warp Design Sheet
  Future<List<NewWarpModel>> warpInfo() async {
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
    return result;
  }

  /// Last Warp Id Details
  Future<NewWarpIdDetailsModel?> warpIdInfo(var supplierId, var eDate) async {
    NewWarpIdDetailsModel? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/last_warp_id_warp_purchase_using_supplier_id_v2?supplier_id=$supplierId&e_date=$eDate')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = NewWarpIdDetailsModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
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

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.put, 'api/debit/note/$id',
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
}
