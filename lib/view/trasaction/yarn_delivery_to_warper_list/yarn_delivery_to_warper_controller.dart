import 'dart:convert';

import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/YarnStockBalanceModel.dart';
import '../../../utils/app_utils.dart';

class YarnDeliveryToWarperController extends GetxController with StateMixin {
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<YarnModel> yarnDropdown = <YarnModel>[].obs;
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  RxBool getBackBoolean = RxBool(false);

  var warperName = "";

  var itemList = <dynamic>[];
  Map<String, dynamic> request = <String, dynamic>{};
  var filterData;

  @override
  void onInit() async {
    warperInfo();
    yarnNameInfo();
    colorInfo();
    change(firmDropdown = await firmInfo());

    super.onInit();
  }

  Future<List<dynamic>> yarnDelivery({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/yarn_warper_list?$query')
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

  /// pdf
  Future<String?> yardDeliverytoWarperPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warpper_yarn_delivery_print?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/yarn_warper_add',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/yarn_warper_update',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('$error');
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/warpper_yarn_delivery_delete?id=$id&password=$password')
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

  //Ledger Name Dropdown Api Call
  Future<List<LedgerModel>> warperInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=warper')
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

  // Dropdown yarnName Api call
  Future<List<YarnModel>> yarnNameInfo() async {
    List<YarnModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/yarn_list?yarn_type=Other')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => YarnModel.fromJson(i)).toList();
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
}
