import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/product_stock_adjustment_model.dart';
import '../../../utils/app_utils.dart';

class ProductStockController extends GetxController with StateMixin {
  List<ProductInfoModel> products = <ProductInfoModel>[].obs;
  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    change(products = await productInfo());
    super.onInit();
  }

//Product name
  Future<List<ProductInfoModel>> productInfo() async {
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productinfolist/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];

        print('=======');
        result = (data['data'] as List)
            .map((i) => ProductInfoModel.fromJson(i))
            .toList();
        print('----------------------------------------------------');
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> productStock({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/product_stock_list?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => ProductStockAdjustmentsModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <ProductStockAdjustmentsModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void addProductStock(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/product_stocks_add',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        change(null, status: RxStatus.success());
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        change(null, status: RxStatus.success());
        print('error: ${error['message']}');
      }
    });
  }

  void editProductStock(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/product_stocks_update',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        change(null, status: RxStatus.success());
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        change(null, status: RxStatus.success());
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> deleteProductStock(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/product_stocks_delete/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        AppUtils.showSuccessToast(message: "${json["message"]}");
        //ledgers(page: '1');
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
