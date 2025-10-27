import 'dart:convert';

import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/TransportCopyModel.dart';
import 'package:abtxt/model/TransportCopyProductSaleModel.dart';
import 'package:abtxt/model/ledger_role_model.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../utils/app_utils.dart';

class TransportCopyController extends GetxController with StateMixin {
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<TransportCopyProductSaleModel> productSales =
      <TransportCopyProductSaleModel>[].obs;
  List<LedgerRoleModel> role = <LedgerRoleModel>[].obs;
  @override
  void onInit() async {
    change(firmDropdown = await firmInfo());
    change(ledgerDropdown = await ledgerInfo());
    change(ledgerDropdown = await ledgerInfo());
    change(productSales = await productSaleInfo());
    change(role = await roleInfo());
    super.onInit();
  }

  Future<dynamic> transportCopy({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/transport_copy_list?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list =
            (data as List).map((i) => TransportCopyModel.fromJson(i)).toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <TransportCopyModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void add(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/transport_copy_add',
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

  void edit(var request, var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/transport_copy_update',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('$error');
      }
    });
  }

  Future<dynamic> delete(var id) async {
    print('delete');
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/transportcopy_delete/$id')
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

  //  Firm
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

  // Dropdown ledger api call
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

  // Product Sale

  Future<List<TransportCopyProductSaleModel>> productSaleInfo() async {
    List<TransportCopyProductSaleModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/transportproduct')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        result = (data as List)
            .map((i) => TransportCopyProductSaleModel.fromJson(i))
            .toList();
        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // Role info
  Future<List<LedgerRoleModel>> roleInfo() async {
    List<LedgerRoleModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/ledger_role')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']['data'];
        result =
            (data as List).map((i) => LedgerRoleModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
}
