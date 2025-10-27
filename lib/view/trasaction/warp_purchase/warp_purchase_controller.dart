import 'dart:convert';

import 'package:abtxt/model/warp_id_details/NewWarpIdDetailsModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/LoomModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../model/TaxFixingModel.dart';
import '../../../utils/app_utils.dart';

class WarpPurchaseController extends GetxController with StateMixin {
  List<FirmModel> Firm = <FirmModel>[].obs;
  List<LedgerModel> supplierName = <LedgerModel>[].obs;
  List<LedgerModel> accountDropDown = <LedgerModel>[].obs;
  List<LedgerModel> ledgerByTax = <LedgerModel>[].obs;

  // AddItem
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<NewWarpModel> warpDesignDropdown = <NewWarpModel>[].obs;
  List<LedgerModel> weaverDropdown = <LedgerModel>[].obs;
  List<LoomModel> loomList = <LoomModel>[].obs;

  // status check for anu changes, if changes reload the list page
  bool isChanged = false;

  var lastWarp;
  var itemList = <dynamic>[];
  String? warpID;
  Map<String, dynamic> request = <String, dynamic>{};
  var filterData;

  @override
  void onInit() async {
    ledgerInfo();
    accountInfo();
    change(weaverDropdown = await weaverInfo());
    change(Firm = await firmInfo());
    change(ledgerByTax = await ledgerByTaxCalling());
    // AddItem
    change(colorDropdown = await colorInfo());
    change(warpDesignDropdown = await warpInfo());
    super.onInit();
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

  /// pdf
  Future<String?> warpPurchasePdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_purchase_print?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  Future<List<dynamic>> warpPurchase({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_purchase_list?$query')
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

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/warp_purchase_store',
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

  void edit(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/warp_purchase_edit',
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

  Future<dynamic> delete(var id, var password) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/warp_purchase_delete?id=$id&password=$password')
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

  Future<dynamic> rowRemove(int rowId, warpPurchaseId) async {
    change(null, status: RxStatus.loading());
    var result = {};
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/warp_purchase_row_remove?warp_purchase_id=$warpPurchaseId&row_id=$rowId')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = {"status": "success"};
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
    return result;
  }

  Future<dynamic> selectedRowUpdate(var request) async {
    change(null, status: RxStatus.loading());
    var result = {};
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/warp_purchase_row_update',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = {"status": "success"};
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
    return result;
  }
}
