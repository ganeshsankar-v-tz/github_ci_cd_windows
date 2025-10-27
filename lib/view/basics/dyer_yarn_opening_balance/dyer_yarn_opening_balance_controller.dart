import 'dart:convert';

import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/dyer_yarn_opening_balance_model.dart';
import '../../../utils/app_utils.dart';

class DyerYarnOpeningBalanceController extends GetxController with StateMixin {
  List<LedgerModel> ledger_dropdown = <LedgerModel>[].obs;
  List<YarnModel> yarn_dropdown = <YarnModel>[].obs;
  List<NewColorModel> color_dropdown = <NewColorModel>[].obs;

  @override
  void onInit() async {
    change(ledger_dropdown = await dyernameInfo());
    change(yarn_dropdown = await yarnInfo());
    change(color_dropdown = await colorInfo());
    super.onInit();
  }

  Future<dynamic> Dyer({var page = "1",var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/dyaryarnopening?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => DyerYarnOpeningBalanceModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <DyerYarnOpeningBalanceModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void addDyer(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/addDyarYarnOpen',
            formDatas: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('addDyer: $json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void updateDyer(var request, var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/updateDyarYarnOpen/$id',
            formDatas: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('addDyer: $json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> deleteDyer(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/dyaryarnopening/$id')
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

  //yarn name dropdown
  Future<List<YarnModel>> yarnInfo() async {
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

  //color name dropdown
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
}
