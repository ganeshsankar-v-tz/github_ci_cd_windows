import 'dart:convert';

import 'package:abtxt/model/CostingEntryModel.dart';
import 'package:abtxt/model/NewUnitModel.dart';
import 'package:abtxt/model/ProductGroupModel.dart';
import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../utils/app_utils.dart';

class CostingEntryController extends GetxController with StateMixin {
  List<ProductInfoModel> productDropdown = <ProductInfoModel>[].obs;
  List<NewUnitModel> unitDropdown = <NewUnitModel>[].obs;
  List<ProductGroupModel> productGroupDropdown = <ProductGroupModel>[].obs;
  Map<String, dynamic> request = <String, dynamic>{};

  @override
  void onInit() async {
    change(productDropdown = await productInfo());
    change(unitDropdown = await unitInfo());
    change(productGroupDropdown = await productGroupInfo());
    super.onInit();
  }

  Future<dynamic> costingEntry({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/getcostingentry?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list =
            (data as List).map((i) => CostingEntryModel.fromJson(i)).toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <CostingEntryModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void add(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/addCostingEntry',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
        Get.back();
      }
    });
  }

  void edit(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/updateCostingEntry',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
        Get.back();
      }
    });
  }

  Future<dynamic> delete(var id) async {
    print('delete');
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/deletecostingentry/$id')
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
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<ProductGroupModel>> productGroupInfo() async {
    List<ProductGroupModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/productgroup')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']['data'];
        result =
            (data as List).map((i) => ProductGroupModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<NewUnitModel>> unitInfo() async {
    List<NewUnitModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/unit/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => NewUnitModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
}
