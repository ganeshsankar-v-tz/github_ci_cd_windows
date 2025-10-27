import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/YarnModel.dart';
import '../../../model/yarndeliverytodyerdata.dart';
import '../../../utils/app_utils.dart';

class YarnDeliveryToDyerController extends GetxController with StateMixin {
  List<LedgerModel> ledger_dropdown = <LedgerModel>[].obs;
  List<NewColorModel> colors_dropdown = <NewColorModel>[].obs;
  List<YarnModel> yarn_dropdown = <YarnModel>[].obs;
  List<NewColorModel> colorName = <NewColorModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  @override
  void onInit() async {
    change(colors_dropdown = await colorInfo());
    change(ledger_dropdown = await dyernameInfo());
    change(yarn_dropdown = await yarnnameInfo());
    super.onInit();
  }

  //Dropdown Color API call

  // Dropdown yarnName Api call
  Future<List<YarnModel>> yarnnameInfo() async {
    List<YarnModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/yarn/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        print(data);
        result = (data as List).map((i) => YarnModel.fromJson(i)).toList();
        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //Dropdown Color API call
  Future<List<NewColorModel>> colorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        print(data);
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // Dropdown ledger api call
  Future<List<LedgerModel>> dyernameInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/ledger')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> yarnDeliverytoDyer({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/list_yarn_dyer?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => YarnDeliverytoDyerModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <YarnDeliverytoDyerModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void add(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/add_yarn_dyer',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('addLedger: $json');
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
            HttpRequestType.post, 'api/update_yarn_dyer',
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
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/delete_yarn_dyer/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(); //ledgers(page: '1');
        AppUtils.showSuccessToast(message: "${json["message"]}");

      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
