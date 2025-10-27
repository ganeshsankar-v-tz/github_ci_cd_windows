import 'dart:convert';
import 'package:get/get.dart';
import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/OpeningClosingStockValueModel.dart';
import '../../../utils/app_utils.dart';

class OpeningClosingStockValueController extends GetxController
    with StateMixin {
  List<FirmModel> firm_dropdown = <FirmModel>[].obs;
  @override
  void onInit() async {
    change(firm_dropdown = await firmInfo());
    super.onInit();
  }
  //Dropdown  Firm API call

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

  Future<dynamic> OpeningClosingStock(
      {var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/opening_closing_list?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => OpeningClosingStockValueModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <OpeningClosingStockValueModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void addOpeningClosingStock(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/opening_closing_add',
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

  void editOpeningClosingStock(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/opening_closing_update',
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
        print('$error');
      }
    });
  }

  Future<dynamic> deleteOpeningClosingStock(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/opening_closing_delete/$id')
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
