import 'dart:convert';

import 'package:abtxt/model/color_matching_list_data.dart';
import 'package:get/get.dart';
import '../../../utils/app_utils.dart';
import '../../../http/api_repository.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/NewColorModel.dart';

class ColorMatchingListController extends GetxController with StateMixin {
  List<ProductInfoModel> products = <ProductInfoModel>[].obs;
  List<NewColorModel> color_dropdown = <NewColorModel>[].obs;


  Map<String, dynamic> request = <String, dynamic>{};

  @override
  void onInit() async {
    change(color_dropdown = await colorInfo());
    change(products = await productInfo());
    super.onInit();
  }

  Future<dynamic> colorMatching({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/colourmatchnig?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => ColorMatchingListData.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        result = {"list": <ColorMatchingListData>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void addColorMatching(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/addColourMatchnig',
            formDatas: request)
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

  void updateColorMatching(var request, var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/updateColourMatchnig/$id',
            formDatas: request)
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

  Future<dynamic> deleteColorMatching(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/colourmatchnig/$id')
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
  Future<List<ProductInfoModel>> productInfo() async {
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productinfolist/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => ProductInfoModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
}
