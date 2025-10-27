import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/NewWarpModel.dart';
import '../../../model/ProductGroupModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/ProductUnitModel.dart';
import '../../../utils/app_utils.dart';

class ProductInfoController extends GetxController with StateMixin {
  List<ProductUnitModel> productUnit = <ProductUnitModel>[].obs;
  List<ProductGroupModel> groups = <ProductGroupModel>[].obs;
  List<NewWarpModel> warpDesignDropdown = <NewWarpModel>[].obs;

  var warpItemList = <dynamic>[];
  var filterData;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    change(groups = await groupInfo());
    change(warpDesignDropdown = await warpDesignInfo());
    super.onInit();
  }

  //New Warp
  Future<List<NewWarpModel>> warpDesignInfo() async {
    List<NewWarpModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/new_warp/list')
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

  //Group name
  Future<List<ProductGroupModel>> groupInfo() async {
    List<ProductGroupModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productgroup/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => ProductGroupModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  /// Warp Or Yarn Deliver Screen To Add New Warp For Selected Product
  Future<ProductInfoModel?> warpOrYarnDeliverToAddWarp(var productId) async {
    change(null, status: RxStatus.loading());
    ProductInfoModel? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/add_warpsin_product?product_id=$productId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = ProductInfoModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<dynamic>> productInfo({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productinfo?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data'];
      } else {
        var error = jsonDecode(response.data);
      }
    });
    return list;
  }

  void addProductInfo(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/addProductInfo',
            formDatas: request)
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

  void updateProductInfo(var request, String id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/updateProductInfo/$id',
            formDatas: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        //  print('addProductInfo: $json');
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
            'api/delete_product?id=$id&password=$password')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error["message"]}');
      }
    });
  }
}
