import 'dart:convert';

import 'package:abtxt/model/productopeningstockModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../utils/app_utils.dart';

class ProductOpeningStockController extends GetxController with StateMixin {
  List<ProductInfoModel> productName = <ProductInfoModel>[].obs;

  var filterData;

  @override
  void onInit() async {
    change(productName = await productInfo());
    super.onInit();
  }

  // product Name
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
    return result;
  }

  Future<List<ProductOpeningStockModel>> openingStockDetails(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<ProductOpeningStockModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_opening_stock_list?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        result = (data as List)
            .map((i) => ProductOpeningStockModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
      }
    });
    return result;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/product_opening_stock_store',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
      }
    });
  }

  void edit(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/product_opening_stock_update',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/product_opening_stock_delete?id=$id&password=$password')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: ${error["message"]}');
      }
    });
  }
}
