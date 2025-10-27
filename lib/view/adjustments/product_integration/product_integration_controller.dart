import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/product_integration_model.dart';
import '../../../utils/app_utils.dart';

class ProductIntegrationController extends GetxController with StateMixin {
  List<ProductInfoModel> products = <ProductInfoModel>[].obs;
  List<ProductInfoModel> DesignNo = <ProductInfoModel>[].obs;
  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    change(products = await productInfo());
    change(DesignNo = await designInfo());
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

  // Design no
  Future<List<ProductInfoModel>> designInfo() async {
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

  Future<dynamic> productIntegration({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/product_intergration_list?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => ProductIntegrationModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <ProductIntegrationModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void addProductintegration(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/add_product_intergration',
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

  void editProductintegration(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/update_product_intergration',
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

  Future<dynamic> deleteProductintegration(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/delete_product_intergration/$id')
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
