import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/new_product_image.dart';
import '../../../utils/app_utils.dart';

class ProductImageController extends GetxController with StateMixin {
  List<ProductInfoModel> products = <ProductInfoModel>[].obs;

  @override
  void onInit() async {
    change(products = await productInfo());
    super.onInit();
  }

  //Product Name
  Future<List<ProductInfoModel>> productInfo() async {
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productinfolist/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']['data'];
        print('-----------------------------------------------');
        print(data);

        result =
            (data as List).map((i) => ProductInfoModel.fromJson(i)).toList();
        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> productimages({var page = "1",var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productimage?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => NewProductImageModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <NewProductImageModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void addNewProductImage(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/addProductImage',
            formDatas: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('addNewProductImage: $json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void updateNewProductImage(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/updateProductImage',
            formDatas: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('addNewProductImage: $json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> deleteNewProductImage(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/productimage/$id')
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
