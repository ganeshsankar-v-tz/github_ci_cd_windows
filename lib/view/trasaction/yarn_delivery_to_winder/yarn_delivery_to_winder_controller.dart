import 'dart:convert';

import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WindingYarnConversationModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/YarnStockBalanceModel.dart';
import '../../../utils/app_utils.dart';

class YarnDeliveryToWinderController extends GetxController with StateMixin {
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<LedgerModel> purchaseAccountDropdown = <LedgerModel>[].obs;
  List<WindingYarnConversationModel> yarnDropdown =
      <WindingYarnConversationModel>[].obs;
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  Map<String, dynamic> request = <String, dynamic>{};

  var itemList = <dynamic>[];
  var filterData;

  var yarnName = "";

  @override
  void onInit() async {
    ledgerInfo();
    firmInfo();
    purchaseAccount();
    yarnnameInfo();
    colorInfo();
    //change(ledgerDropdown = await ledgerInfo());
    //change(firmDropdown = await firmInfo());
    //change(purchaseAccountDropdown = await purchaseAccount());
    //change(yarnDropdown = await yarnnameInfo());
    //change(colorDropdown = await colorInfo());
    super.onInit();
  }

  /// pdf
  Future<String?> yarnDelierytoWinderPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/yarns_delivery_winder_pdf?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  Future<List<dynamic>> yarnDelivery({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/winder_list_pagination?$query')
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
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/add_winder',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}", seconds: 1000);
        AppUtils.infoAlert(message: "DC No:  ${json["data"]["dc_no"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  void edit(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/update_winder',
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
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/winding_yarn_delivery_delete?id=$id&password=$password')
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
  }

  // Dropdown ledger api call
  Future<List<LedgerModel>> ledgerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=winder')
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
        print('error: ${json['message']}');
      }
    });
    change(firmDropdown = result);
    return result;
  }

  // Dropdown Account api call
  Future<List<LedgerModel>> purchaseAccount() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/ledger_by?account_type=Direct Expenses')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(purchaseAccountDropdown = result);
    return result;
  }

  // Dropdown yarnName Api call
  Future<List<WindingYarnConversationModel>> yarnnameInfo() async {
    List<WindingYarnConversationModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/winding_yarn_conversation/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WindingYarnConversationModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(yarnDropdown = result);
    return result;
  }

  //Dropdown Color API call
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
    change(colorDropdown = result);
    return result;
  }

  /// Check The Yarn Balance In Stocks
  Future<YarnStockBalanceModel?> yarnStockBalance(
      var yarnId, var colorId, var stockIn) async {
    change(null, status: RxStatus.loading());
    YarnStockBalanceModel? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/overall_balance_yarn_stock?yarn_id=$yarnId&color_id=$colorId&stock_in=$stockIn')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = YarnStockBalanceModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  /// Check if the selected row's yarn id is added in winder inward.
  /// If the yarn has been inward, do not allow removal.
  Future<String?> rowRemoveCheck(
      var rowId, var deliveryWinderId, var yarnId, var expectYarnId) async {
    String? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/yarn_delivery_winder_item_remove?row_id=$rowId&delivery_winder_id=$deliveryWinderId&yarn_id=$yarnId&exp_yarn_id=$expectYarnId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        result = "False";
        print('error: ${json['message']}');
      }
    });
    return result;
  }
}
