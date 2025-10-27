import 'dart:convert';

import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WarpDesignSheetModel.dart';
import 'package:abtxt/model/roller_warp_opening_balance_model.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';

class RollerWarpOpeningBalanceController extends GetxController
    with StateMixin {
  List<LedgerModel> ledger_dropdown = <LedgerModel>[].obs;
  List<WarpDesignSheetModel> warp_dropdown = <WarpDesignSheetModel>[].obs;
  List<NewColorModel> warpColor_dropdown = <NewColorModel>[].obs;

  @override
  void onInit() async {
    change(ledger_dropdown = await ledgerInfo());
    change(warp_dropdown = await warpdesignInfo());
    change(warpColor_dropdown = await warpColorInfo());
    super.onInit();
  }

//Ledger name
  Future<List<LedgerModel>> ledgerInfo() async {
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

//Warp Design
  Future<List<WarpDesignSheetModel>> warpdesignInfo() async {
    List<WarpDesignSheetModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/warpdesign')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        print(data);
        result = (data['data'] as List)
            .map((i) => WarpDesignSheetModel.fromJson(i))
            .toList();
        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //Warp Color
  Future<List<NewColorModel>> warpColorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        print(data);
        result = (data['data'] as List)
            .map((i) => NewColorModel.fromJson(i))
            .toList();
        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> rollerWarpOpeningBalance({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rolleropening?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => RollerWarpOpeningBalanceModel.fromJson(i))
            .toList();

        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <RollerWarpOpeningBalanceModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void add(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.upload, 'api/addRollerOpen',
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
            HttpRequestType.upload, 'api/updateRollerOpen/$id',
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
            HttpRequestType.delete, 'api/rolleropening/$id')
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
