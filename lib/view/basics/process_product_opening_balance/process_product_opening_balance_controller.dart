import 'dart:convert';

import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:abtxt/model/process_product_opening_balance_model.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';

class ProcessProductOpeningBalanceController extends GetxController
    with StateMixin {
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<ProductInfoModel> productDropdown = <ProductInfoModel>[].obs;
  @override
  void onInit() async {
    change(ledgerDropdown = await ledgerInfo());
    change(productDropdown = await productInfo());
    super.onInit();
  }

  //Ledger name
  Future<List<LedgerModel>> ledgerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/rollbased?ledger_role=processor')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        print(data);
        print('----------------------------------------------------');
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
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
        result = (data as List)
            .map((i) => ProductInfoModel.fromJson(i))
            .toList();
        print('----------------------------------------------------');
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> processProductOpening({var page = "1",var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/processopening?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => ProcessProductOpeningBalanceModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <ProcessProductOpeningBalanceModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void add(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/addProcessOpen',
            formDatas: request)
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

  void edit(var request, var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/updateProcessOpen/$id',
            formDatas: request)
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
            HttpRequestType.delete, 'api/processopening/$id')
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
