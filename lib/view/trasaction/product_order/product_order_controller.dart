import 'dart:convert';

import 'package:abtxt/model/FirmModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../utils/app_utils.dart';

class ProductOrderController extends GetxController with StateMixin {
  List<LedgerModel> customerName = <LedgerModel>[].obs;
  List<ProductInfoModel> productName = <ProductInfoModel>[].obs;
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  RxBool getBackBoolean = RxBool(false);

  int? customerId;
  var itemList = <dynamic>[];
  var filterData;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    customerInfo();
    firmInfo();
    productInfo();
    super.onInit();
  }

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

  // Customer Name
  Future<List<LedgerModel>> customerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=customer')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    change(customerName = result);
    return result;
  }

  // Product Name
  Future<List<ProductInfoModel>> productInfo() async {
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productinfolist/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => ProductInfoModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    change(productName = result);
    return result;
  }

  Future<List<dynamic>> productOrderList({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_order_list?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data'];
      } else {
        var error = jsonDecode(response.data);
        debugPrint(error);
      }
    });
    return list;
  }

  void add(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/product_order_post',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
      }
    });
  }

  void edit(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/product_order_update',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        debugPrint('$error');
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/product_order_delete?id=$id&password=$password')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
      }
    });
  }

  Future<dynamic> productStockBalance(var productId) async {
    change(null, status: RxStatus.loading());
    dynamic result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/product_stock_details?product_id=$productId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']["total_stock"];
        result = data;
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> lastYarnPurchaseDetails(var productId, var customerId) async {
    dynamic result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/latest_product_sale_list?product_id=$productId&customer_id=$customerId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        debugPrint('error: $json');
      }
    });
    return result;
  }

  /// pdf
  Future<String?> productOrderPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_order_bill?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['pdf_url'];
      } else {}
    });
    return url;
  }
}
