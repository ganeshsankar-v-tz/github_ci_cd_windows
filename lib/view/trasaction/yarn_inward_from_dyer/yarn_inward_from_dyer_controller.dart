import 'dart:convert';

import 'package:abtxt/model/YarnInwardFromDyer.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/AccountTypeModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';

class YarnInwardFromDyerController extends GetxController with StateMixin {
  List<YarnModel> YarnName = <YarnModel>[].obs;
  List<AccountTypeModel> Account = <AccountTypeModel>[].obs;
  List<NewColorModel> ColorName = <NewColorModel>[].obs;
  List<LedgerModel> DyerName = <LedgerModel>[].obs;
  @override
  void onInit() async {
    change(DyerName = await dyerNameInfo());
    change(Account = await accountInfo());
    change(YarnName = await YarnNameInfo());
    change(ColorName = await ColorNameInfo());

    super.onInit();
  }

  // Customer Name
  Future<List<LedgerModel>> dyerNameInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/rollbased?ledger_role=supplier')
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

  // AddItem
  // Yarn Name
  Future<List<YarnModel>> YarnNameInfo() async {
    List<YarnModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/yarn/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        print(data);
        print('----------------------------------------------------');
        result = (data as List).map((i) => YarnModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // Account
  Future<List<AccountTypeModel>> accountInfo() async {
    List<AccountTypeModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/account_type')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        print('----------------------------------------------------');
        result =
            (data as List).map((i) => AccountTypeModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // Color Name
  Future<List<NewColorModel>> ColorNameInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        print(data);
        print('----------------------------------------------------');
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> yarninward({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/list_inward_dyer?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => YarnInwardFromDyerModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <YarnInwardFromDyerModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void addYarnInwardfromDyer(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/add_inward_dyer',
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

  Future<dynamic> deleteyarninward(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/delete_inward_dyer/$id')
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

  void updateYarninward(var request, var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/update_inward_dyer',
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
}

//addYarn_Inward_from_Dyer
