import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/ProductReturnFromCustomerModel.dart';
import '../../../utils/app_utils.dart';

class ProductReturnFromCustomerController extends GetxController
    with StateMixin {
  List<FirmModel> firmName = <FirmModel>[].obs;
  List<LedgerModel> Customer = <LedgerModel>[].obs;
  List<ProductInfoModel> products = <ProductInfoModel>[].obs;
  @override
  void onInit() async {
    change(firmName = await firmInfo());
    change(Customer = await customerInfo());
    change(products = await productInfo());
    super.onInit();
  }

  Future<List<ProductInfoModel>> productInfo() async {
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/productinfolist/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        print(data);
        result = (data as List).map((i) => ProductInfoModel.fromJson(i)).toList();
        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
  // Dropdown ledger api call
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

  // Customer Name
  Future<List<LedgerModel>> customerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/rollbased?ledger_role=customer')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        print(data);
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> paginatedList({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/product_return_list?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('${(response.data)}');
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => ProductReturnFromCustomerModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <ProductReturnFromCustomerModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void add(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/product_return_add',
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
            HttpRequestType.post, 'api/product_return_update',
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
            HttpRequestType.delete, 'api/product_return_delete/$id')
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
}
