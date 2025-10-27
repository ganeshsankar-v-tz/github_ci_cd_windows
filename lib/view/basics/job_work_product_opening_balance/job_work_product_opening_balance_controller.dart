import 'dart:convert';
import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:abtxt/model/job_worker_product_model.dart';
import 'package:get/get.dart';
import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';

class JobWorkProductOpeningBalanceController extends GetxController
    with StateMixin {
  List<ProductInfoModel> products = <ProductInfoModel>[].obs;
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  @override
  void onInit() async {
    change(products = await productInfo());
    change(ledgerDropdown = await ledgerInfo());
    super.onInit();
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

  //Ledger name
  Future<List<LedgerModel>> ledgerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/rollbased?ledger_role=job_worker')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> jobWorkProduct({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/jobworkopening?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => JobWorkerProductModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <JobWorkerProductModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void add(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/addJobWorkOpen',
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
            HttpRequestType.upload, 'api/updateJobWorkOpen/$id',
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
            HttpRequestType.delete, 'api/jobworkopening/$id')
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
